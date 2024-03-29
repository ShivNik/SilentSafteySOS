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
    
    // Call Observer, Background Task, Synthesizer
    var callObserver: CXCallObserver?
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // Repetitions
    var messageArray: [String] = [] {
        willSet {
            if(numRepetitions == 2 && newValue.count - 1 >= 0) {
                speakMessage(newValue[newValue.count - 1])
            }
        }
    }
    
    var spokenMessages: [String] = []
    var observeSynthesizerDelegate: ObserveSynthesizer?
    var index = 0
    var target = 1
    var numRepetitions = 0

    override init() {
        super.init()
    }
    
    func initiatePhoneCall(phoneNumber: String) {
        callObserver = CXCallObserver()
        callObserver?.setDelegate(self, queue: nil)
        
        if let url = URL(string: ("tel:" + phoneNumber)) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: -  Call Observer and Responses
extension PhoneCall : CXCallObserverDelegate {
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            callEnded()
            
        } else if call.isOutgoing == true && call.hasConnected == false {
            callDialed()
            
        } else if call.hasConnected == true && call.hasEnded == false {
            callConnected()
        }
    }
    
    func callDialed() {
        startBackGroundTask()
        observeSynthesizerDelegate?.callDialing()
        Response.responseActive = true
        
        // Adding Base Messages to Message Array
        messageArray.insert("Hello. This is a call from the Silent Safety App.", at: 0)
        
        let firstMessage = generateFirstMessage()
        messageArray.insert(firstMessage, at: 1)
        
        // Start Location
        startLocation()
    }
    
    func callConnected() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            if(Response.responseActive) {
                speakMessage(messageArray[index])
            }
        }
    }
    
    func callEnded() {
        callObserver = nil
        
        Response.responseActive = false
        endLocation()
        endBackGroundTask()
        
        messageArray = []
        spokenMessages = []
        index = 0
        target = 1
        numRepetitions = 0
        
        self.synthesizer.stopSpeaking(at: .immediate) // Stop speaking after done
        observeSynthesizerDelegate?.callEnded()
    }
}

// MARK: -  Set Up Methods
extension PhoneCall {
    func createSynthesizer() {
        let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session: \(error.localizedDescription)")
        }
        
        synthesizer.mixToTelephonyUplink = true
        synthesizer.delegate = self
    }
    
    func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(recievedLocationNotification(notification:)), name: .locationFound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedAdditionalMessageNotification(notification:)), name: .additionalMessage, object: nil)
    }
    
    @objc func recievedLocationNotification(notification: NSNotification) {
        if let message = notification.userInfo?["placemark"] as? String {
            messageArray.append(message)
        }
    }
    
    @objc func recievedAdditionalMessageNotification(notification: NSNotification) {
        if let message = notification.userInfo?["additionalMessage"] as? String {
            messageArray.append(message)
        }
    }
    
    func startBackGroundTask() {
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
}

// MARK: -  Synthesizer Delegate Methods
extension PhoneCall {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        observeSynthesizerDelegate?.synthesizerStarted()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        observeSynthesizerDelegate?.synthesizerEnded()
    
        if(Response.responseActive) {
            if(numRepetitions == 2) {
                return
            }
            
            let text = utterance.speechString.trimmingCharacters(in: .whitespaces)
            
            if(!checkSpokenMessagesSpoken(text: text)) {
                spokenMessages.append(text)
            }
            
            if(messageArray.count > spokenMessages.count) {
                speakMessage(messageArray[spokenMessages.count])
                
            } else if(messageArray.count == spokenMessages.count) {
                index += 1
                
                if(index == target) {
                    
                    numRepetitions += 1
                    if(numRepetitions == 2) {
                        speakMessage("The user is now avaliable to listen to questions and type messages")
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                        if(Response.responseActive) {
                            index = 0
                            target = spokenMessages.count
            
                            if(messageArray.count >= 1) {
                                speakMessage(messageArray[index])
                            }
                        }
                    }
                } else {
                    speakMessage(messageArray[index])
                }
            }
        }
    }
}

// MARK: -  Helper Methods
extension PhoneCall {
    func generateFirstMessage() -> String {
        var templateString = ""
        var dynamicMessage = "I'm "
        
        var oneValuePresent = false
        
        if let name = AppDelegate.userDefaults.string(forKey: AllStrings.name) {
            if(noValuePresent(text: name)) {
                templateString += "My name is \(name). "
            }
        }
        
        if let race = AppDelegate.userDefaults.string(forKey: AllStrings.race) {
            if(noValuePresent(text: race)) {
                dynamicMessage += "\(race), "
                oneValuePresent = true
            }
        }
        
        if let gender = AppDelegate.userDefaults.string(forKey: AllStrings.gender) {
            if(noValuePresent(text: gender)) {
                dynamicMessage += "\(gender), "
                oneValuePresent = true
            }
        }
        
        if let weight = AppDelegate.userDefaults.string(forKey: AllStrings.weight) {
            if(noValuePresent(text: weight)) {
                dynamicMessage += "\(weight) pounds, "
                oneValuePresent = true
            }
        }
        
        if let age = AppDelegate.userDefaults.string(forKey: AllStrings.age) {
            if(noValuePresent(text: age)) {
                dynamicMessage += "\(age) years old, "
                oneValuePresent = true
            }
        }
        
        if let height = AppDelegate.userDefaults.string(forKey: AllStrings.height) {
            if(noValuePresent(text: height)) {
                let components = height.components(separatedBy: " ")
                dynamicMessage += "\(components[0]) feet \(components[1]) inches, "
                oneValuePresent = true
            }
        }
        
        if let additionalInfo = AppDelegate.userDefaults.string(forKey: AllStrings.additionalInfo) {
            if(noValuePresent(text: additionalInfo)) {
                dynamicMessage += ". \(additionalInfo). "
                oneValuePresent = true
            }
        }
        
        if(oneValuePresent) {
            return (templateString + dynamicMessage)
        } else {
            return templateString
        }
    }
    
    func noValuePresent(text: String) -> Bool {
        if(text == "") {
            return false
        }
        return true
    }
    
    func speakMessage(_ message: String) {
        let myUtterance = AVSpeechUtterance(string: message)
        myUtterance.rate = 0.5
        self.synthesizer.speak(myUtterance)
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

// MARK: -  Location Start and Stop
extension PhoneCall {
    func startLocation() {
        if(AppDelegate.location.checkAuthorization()) {
            AppDelegate.location.retrieveLocation()
        }
    }
    
    func endLocation() {
        AppDelegate.location.locationManager.stopUpdatingLocation()
        AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
    }
}

protocol ObserveSynthesizer {
    func synthesizerStarted()
    func synthesizerEnded()
    func callDialing()
    func callEnded()
}
