//
//  PhoneCall.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/13/22.
//

import UIKit
import CallKit
import AVFoundation
import AVFAudio
import WidgetKit

class PhoneCall: NSObject, AVSpeechSynthesizerDelegate {
    
    let callObserver: CXCallObserver = CXCallObserver()
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    var firstMessageRecieved = false
    var spokenMessages: [String] = []
    var observeSynthesizerDelegate: ObserveSynthesizer?
    var index = 0
    var target: Int!

    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
    }
    var messageArray: [String] = [] /* {
        willSet {
            print("firstMessageRecieved \(firstMessageRecieved)")
            if(firstMessageRecieved && newValue.count - 1 >= 0) {
                speakMessage(newValue[newValue.count - 1])
            }
        }
    } */
    
    func initiatePhoneCall(phoneNumber: String) {
      //  messageArray = []
        firstMessageRecieved = false
        
        if let url = URL(string: ("tel:" + phoneNumber)) {
            UIApplication.shared.open(url)
        }
    }
}

extension PhoneCall : CXCallObserverDelegate {
    func setUpBackgroundTask() {
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "CallObserver") {
            
            self.endBackGroundTask()
        }
    }
    
    func endBackGroundTask() {
        if self.backgroundTaskID != nil {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = .invalid
        }
    }
    
    func locationPhoneCall() {
        if(AppDelegate.location.checkAuthorization()) {
            print("authorizaed")
            AppDelegate.location.retrieveLocation()
        }
        else {
            print("denied/restricted")
        }
    }
    
    func generateFirstMessage() -> String {
        var templateString = "Hello. This is a call from the Silent Safety App. "
        var dynamicMessage = "I'm "
        
        var oneValuePresent = false
        
        if let name = AppDelegate.userDefaults.string(forKey: AllStrings.name) {
            templateString += "My name is \(name). "
        }
        
        if let race = AppDelegate.userDefaults.string(forKey: AllStrings.race) {
            dynamicMessage += "\(race), "
            oneValuePresent = true
        }
        
        if let gender = AppDelegate.userDefaults.string(forKey: AllStrings.gender) {
            dynamicMessage += "\(gender), "
            oneValuePresent = true
        }
        
        if let weight = AppDelegate.userDefaults.string(forKey: AllStrings.weight) {
            dynamicMessage += "\(weight) pounds, "
            oneValuePresent = true
        }
        
        if let age = AppDelegate.userDefaults.string(forKey: AllStrings.age) {
            dynamicMessage += "\(age) years old, "
            oneValuePresent = true
        }
        
        if let height = AppDelegate.userDefaults.string(forKey: AllStrings.height) {
            let components = height.components(separatedBy: " ")
            dynamicMessage += "\(components[0]) feet \(components[1]) inches, "
            oneValuePresent = true
        }
        
        if let additionalInfo = AppDelegate.userDefaults.string(forKey: AllStrings.additionalInfo) {
            dynamicMessage += ". \(additionalInfo). "
            oneValuePresent = true
        }
        
        if(oneValuePresent) {
            print(templateString + dynamicMessage)
            return (templateString + dynamicMessage)
        } else {
            return templateString
        }
    }
    
    func readMessages(boundOne: Int, boundTwo: Int) {
        for i in boundOne..<boundTwo {
            speakMessage(messageArray[i])
        }
        print("read messages")
        
    }
    
    func callEndedLocationResponse() {
        AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
        
        AppDelegate.location.locationManager.stopUpdatingLocation()
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

        if call.hasEnded == true {
            print("CXCallState :Disconnected")
        
            Response.responseActive = false
            callEndedLocationResponse()
            endBackGroundTask()
            
            messageArray = []
            spokenMessages = []
            index = 0
            
            firstMessageRecieved = false
            self.synthesizer.stopSpeaking(at: .immediate) // Stop speaking after done
         //   self.observeSynthesizerDelegate?.callEnded()

        } else if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
            setUpBackgroundTask()
            Response.responseActive = true
            locationPhoneCall()
            
        } else if call.hasConnected == true && call.hasEnded == false {
            
            print("connected")
            
            let firstMessage = generateFirstMessage()
            messageArray.insert(firstMessage, at: 0)
            speakMessage(firstMessage)
            target = 1
            firstMessageRecieved = true

            
        } else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
        }
        
        
        
        if call.isOutgoing == true && call.isOnHold == true {
           print("outgoing call is on hold")
        }
        
        if call.isOutgoing == false && call.isOnHold == true {
             print("incoming call is on hold")
        }
    }
    
    func createSynthesizer() {
        let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
        
        synthesizer.mixToTelephonyUplink = true
        synthesizer.delegate = self
    }
    
    func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(recievedLocationNotification(notification:)), name: .locationFound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedAdditionalMessageNotification(notification:)), name: .additionalMessage, object: nil)
    }

    @objc func recievedLocationNotification(notification: NSNotification) {
        print("Got location notification")
    
        if let message = notification.userInfo?["placemark"] as? String {
            if(firstMessageRecieved) {
                messageArray.insert(message, at: 1)
            } else {
                messageArray.insert(message, at: 0)
            }
        }
        
        
    }
    
    @objc func recievedAdditionalMessageNotification(notification: NSNotification) {
        print("Got additional message notification notification")
        
        if let message = notification.userInfo?["additionalMessage"] as? String {
            messageArray.append(message)
        }
    }
    
    func speakMessage(_ message: String) {
        let myUtterance = AVSpeechUtterance(string: message)
        myUtterance.rate = 0.5
        synthesizer.speak(myUtterance)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("745 YELLOW BEAMER")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            
        print(messageArray)
        print(spokenMessages)
        print(index)
        
        let text = utterance.speechString.trimmingCharacters(in: .whitespaces)
        print("text \(text)")
        
        if(!checkSpokenMessagesSpoken(text: text)) {
            spokenMessages.append(text)
        }
        
        if(messageArray.count > spokenMessages.count) {
            speakMessage(messageArray[spokenMessages.count])
            
        } else if(messageArray.count == spokenMessages.count) {
            index += 1
            
            if(index == target) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                    print("3 second wait")
                    index = 0
                    target = spokenMessages.count
                    
                    if(messageArray.count >= 1) {
                        speakMessage(messageArray[index])
                    }
                }
            } else {
                speakMessage(messageArray[index])
            }
        }
    }
    
    func checkSpokenMessagesSpoken(text: String) -> Bool {
        for message in spokenMessages {
            if(text == message) {
                return true
            }
        }
        return false
    }
}

protocol ObserveSynthesizer {
    func synthesizerStarted()
    func synthesizerEnded(message: String, changeLabel: Bool)
    func callStarted() 
    func callEnded()
}


/*
 let text = utterance.speechString.trimmingCharacters(in: .whitespaces)
 print("text \(text)")
 if(!checkSpokenMessagesSpoken(text: text)) {
     spokenMessages.append(text)
 }
 
 messageLength -= 1
 print(spokenMessages)
 print(messageArray)
 print(messageLength)
 print(spokenMessages.count)
 print(messageArray.count)
 
 if(messageArray.count > spokenMessages.count) {
     print("RRRAWAAWR")
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
         synthesizer.stopSpeaking(at: .immediate)
         
         for i in spokenMessages.count..<(messageArray.count) {
             print(messageArray[i])
             speakMessage(messageArray[i])
         }
         
         for i in (spokenMessages.count - messageLength)..<(spokenMessages.count) {
             print(spokenMessages[i])
             speakMessage(spokenMessages[i])
         }
 
         messageLength += (messageArray.count - spokenMessages.count)
         print("messageLength \(messageLength)")
     }
     return
 }
 
 if(messageLength == 0) {
     DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         self.messageLength = self.messageArray.count
         print("there")
 
         if(self.messageLength > self.spokenMessages.count) {
             print("here")
             
             self.readMessages(boundOne: self.spokenMessages.count, boundTwo: self.messageArray.count)
             self.readMessages(boundOne: 0, boundTwo: self.spokenMessages.count)
             
         } else {
             self.readMessages(boundOne: 0,boundTwo: self.messageArray.count)
         }
     }
 }
 */
