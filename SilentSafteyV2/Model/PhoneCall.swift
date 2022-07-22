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

class PhoneCall: NSObject {
    let callObserver: CXCallObserver = CXCallObserver()
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    var synthesizer: AVSpeechSynthesizer!
    var firstMessageRecieved = false

    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
    }
    var messageArray: [String] = [] {
        willSet {
            print("firstMessageRecieved \(firstMessageRecieved)")
            if(firstMessageRecieved && newValue.count - 1 >= 0) {
                speakMessage(newValue[newValue.count - 1])
            }
        }
    }
    
    func initiatePhoneCall(phoneNumber: String) {
      //  messageArray = []
        firstMessageRecieved = false
        
        if let url = URL(string: ("tel:" + phoneNumber)) {
            UIApplication.shared.open(url)
        }
    }
    
  /*  func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    func providerDidBegin(_ provider: CXProvider) {
        print("provider did begin")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started")
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("CALLL HOLD")
    } */
}

extension PhoneCall : CXCallObserverDelegate {
    func setUpBackgroundTask() {
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "CallObserver") {
            print("YYYYEEEESSSS SMOOOGGGGG")
            
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
    
    func readMessages() {
        for i in 0..<messageArray.count {
            speakMessage(messageArray[i])
        }
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
            firstMessageRecieved = false


        } else if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
            
            setUpBackgroundTask()
            Response.responseActive = true
            locationPhoneCall()
            
        } else if call.hasConnected == true && call.hasEnded == false {
            
            print("connected")
            
            let firstMessage = generateFirstMessage()
            messageArray.insert(firstMessage, at: 0)
            readMessages()
            firstMessageRecieved = true
            
        } else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
        }


    }
    
    func createSynthesizer() {
        let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
        
        synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
    }
    
    func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(recievedLocationNotification(notification:)), name: .locationFound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedAdditionalMessageNotification(notification:)), name: .additionalMessage, object: nil)
    }

    @objc func recievedLocationNotification(notification: NSNotification) {
        print("Got location notification")
    
        if let message = notification.userInfo?["placemark"] as? String {
            messageArray.append(message)
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
}




/*  let cxt = CXTransaction(action: CXStartCallAction(call: call.uuid, handle: CXHandle(type: .phoneNumber, value: "4693555568")))
  
  callController.request(cxt) { error in
      if error == nil {
          print("completion heandler")
      } else {
          
      }
  }
  print("call observered")

  print("UUID \(call.uuid)")
  print("Outgoing \(call.isOutgoing)")
  print("hasConnected \(call.hasConnected)")
  print("hasEnded \(call.hasEnded)")
  print("isOnHold \(call.isOnHold)")
  print("called")
  print(call) */
