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

    var callObserver: CXCallObserver!
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    var synthesizer: AVSpeechSynthesizer!
    var firstMessageRecieved = false
    var inCall: Bool = false
    
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
        setupCallObserver()
        
        if let url = URL(string: ("tel:" + phoneNumber)) {
            UIApplication.shared.open(url) { opened in
                if opened {
                
                }
            }
        }
    }
}

extension PhoneCall : CXCallObserverDelegate {
    
    func setupCallObserver() {
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        print("called")
        print(call)
        if call.hasEnded == true {
            print("CXCallState :Disconnected")
            inCall = false
            
            Response.responseActive = false
            
            AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
            
            AppDelegate.location.locationManager.stopUpdatingLocation()
            
            
           /* if(!SceneDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinishedKey)) {
                print("Endo")
                NotificationCenter.default.post(name: .tutorialPhoneCallFinished, object: nil)
            } */
            
           /* UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = .invalid */
             
            messageArray = []
            firstMessageRecieved = false
            
            print("in call? \(inCall)")

        } else if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
            
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "CallObserver") {
                if self.backgroundTaskID != nil {
                    UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                    self.backgroundTaskID = .invalid
                }
            }
            
            inCall = true
        
            Response.responseActive = true
    
            if(AppDelegate.location.checkAuthorization()) {
                print("authorizaed")
                AppDelegate.location.retrieveLocation()
            }
            else {
                print("denied/restricted")
            }
            
        } else if call.hasConnected == true && call.hasEnded == false {
            print("connected")
            let firstMessage = "Hello. My name is Shivansh Nikhra and I'm really good at soccer"
            messageArray.insert(firstMessage, at: 0)
            
            for i in 0..<messageArray.count {
                speakMessage(messageArray[i])
            }
            
            firstMessageRecieved = true
        } else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
        }

    }
    
    func createSynthesizer() {
        print("create synthesizers")
        let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
        
        synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
        

      /*  if let currentChannels =
            AVAudioSession.sharedInstance().currentRoute.outputs.first?.channels {
            /* print(AVAudioSession.sharedInstance().currentRoute.outputs.count)
            print(AVAudioSession.sharedInstance().currentRoute.outputs) */ 
            synthesizer.outputChannels = currentChannels
        }  */
    }
    
    func setUpObservers() {
        print("set up observers")
        NotificationCenter.default.addObserver(self, selector: #selector(recievedLocationNotification(notification:)), name: .locationFound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedAdditionalMessageNotification(notification:)), name: .additionalMessage, object: nil)
    }
    
   
    @objc func recievedLocationNotification(notification: NSNotification) {
        print("Got location notification")
    
        if let message = notification.userInfo?["placemark"] as? String {
            messageArray.append(message)
        }
      /*  if let message = notification.userInfo?["placemark"] as? String {
            speakMessage(message)
         } */
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

