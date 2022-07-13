//
//  PhoneCall.swift
//  FinalIterationOne
//
//  Created by Shivansh Nikhra on 6/30/22.
//



import UIKit
import CallKit
import AVFoundation
import AVFAudio
import WidgetKit


class PhoneCall: NSObject, CXProviderDelegate {
    
    private var provider: CXProvider!
    private var callController: CXCallController!
    var callObserver: CXCallObserver!
    var backgroundTaskID: UIBackgroundTaskIdentifier?
    var synthesizer: AVSpeechSynthesizer!
    var firstMessageRecieved = false
    
    var messageArray: [String] = [] {
        willSet {
            print("firstMessageRecieved \(firstMessageRecieved)")
            if(firstMessageRecieved && newValue.count - 1 >= 0) {
                speakMessage(newValue[newValue.count - 1])
            }
        }
    }
    
    func initiatePhoneCall(number: Double) {
        messageArray = []
        firstMessageRecieved = false
        
        setupCallObserver()
        if let url = URL(string: "tel:\(4693555568)") {
            UIApplication.shared.open(url) { opened in
                if opened {
                    self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "CallObserver") {
                        
                        if self.backgroundTaskID != nil {
                            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                            self.backgroundTaskID = .invalid
        
                        }
                        
                    }
                }
            }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
}


extension PhoneCall : CXCallObserverDelegate {
    
    func setupCallObserver() {
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

        if call.hasEnded == true {
            print("CXCallState :Disconnected")
            messageArray = []
            firstMessageRecieved = false
           /* if(!SceneDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinishedKey)) {
                print("Endo")
                NotificationCenter.default.post(name: .tutorialPhoneCallFinished, object: nil)
            } */
            
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = .invalid

        }
        
        if call.isOutgoing == true && call.hasConnected == false {
            print("CXCallState :Dialing")
        }
        
        if call.hasConnected == true && call.hasEnded == false {
            print("connected")
        
            if(AppDelegate.location.checkAuthorization()) {
                 print("authorizaed")
                 AppDelegate.location.retrieveLocation()
             }
             else {
                 print("denied/restricted")
             }
            
            let firstMessage = "Hello. My name is Shivansh Nikhra and I'm really good at soccer"
            messageArray.insert(firstMessage, at: 0)
            
            for i in 0..<messageArray.count {
                speakMessage(messageArray[i])
            }
            
            firstMessageRecieved = true
        }
        
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("CXCallState :Incoming")
        }

    }
    
    func createSynthesizer() {
        print("create synthesizers")
        let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        
        synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
        
        if let currentChannels = AVAudioSession.sharedInstance().currentRoute.outputs.first?.channels {
            synthesizer.outputChannels = currentChannels
        }
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



/*
 import UIKit
 import CallKit
 import AVFoundation
 import AVFAudio
 import WidgetKit

 class PhoneCall: NSObject, CXProviderDelegate {
     
     private var provider: CXProvider!
     private var callController: CXCallController!
     var callObserver: CXCallObserver!
     var backgroundTaskID: UIBackgroundTaskIdentifier?
     var synthesizer: AVSpeechSynthesizer!
     
     func initiatePhoneCall(number: Double) {
         setupCallObserver()
         
         if let url = URL(string: "tel:\(4693555568)") {
             UIApplication.shared.open(url) { opened in
                 if opened {
                     self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "CallObserver") {
                         
                         if self.backgroundTaskID != nil {
                             if self.backgroundTaskID != nil {
                                 UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                                 self.backgroundTaskID = .invalid
                             }
                         }
                         
                     }
                 }
             }
         }

     }
     
     func providerDidReset(_ provider: CXProvider) {
         
     }

     func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
         action.fulfill()
     }
 }


 extension PhoneCall : CXCallObserverDelegate {
     
     func setupCallObserver() {
         callObserver = CXCallObserver()
         callObserver.setDelegate(self, queue: nil)
     }
     
     func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

         if call.hasEnded == true {
             print("CXCallState :Disconnected")
         
            /* if(!SceneDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinishedKey)) {
                 print("Endo")
                 NotificationCenter.default.post(name: .tutorialPhoneCallFinished, object: nil)
             } */
             
             UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
             self.backgroundTaskID = .invalid

         }
         
         if call.isOutgoing == true && call.hasConnected == false {
             print("CXCallState :Dialing")
         }
         
         if call.hasConnected == true && call.hasEnded == false {
             print("connected")
             self.sayMessage(message: "Hello. ")
             // \(SceneDelegate.userDefaults.string(forKey: AllStrings.nameKey)!))
         }
         
         if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
             print("CXCallState :Incoming")
         }
     }
     
     public func sayMessage(message: String) {
         let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
         do {
             // 1) Configure your audio session category, options, and mode
             // 2) Activate your audio session to enable your custom configuration
             try AVAudioSession.sharedInstance().setActive(true)
         } catch let error as NSError {
             print("Unable to activate audio session:  \(error.localizedDescription)")
         }
         
         synthesizer = AVSpeechSynthesizer()
         synthesizer.mixToTelephonyUplink = true
         
         if let currentChannels = AVAudioSession.sharedInstance().currentRoute.outputs.first?.channels {
             synthesizer.outputChannels = currentChannels
             
             print(AVAudioSession.sharedInstance().currentRoute.outputs.count)
         }
         
         speakMessage(message)
         NotificationCenter.default.addObserver(self, selector: #selector(recievedLocationNotification(notification:)), name: .locationFound, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(recievedAdditionalMessageNotification(notification:)), name: .additionalMessage, object: nil)
        // setupCallObserver()
        
     }
     /*
      let _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
      
      synthesizer = AVSpeechSynthesizer()
      synthesizer.mixToTelephonyUplink = true
      
      if let currentChannels = AVAudioSession.sharedInstance().currentRoute.outputs.first?.channels {
          print(AVAudioSession.sharedInstance().currentRoute.outputs.count)
          synthesizer.outputChannels = currentChannels
      }
      */
     @objc func recievedLocationNotification(notification: NSNotification) {
         print("Got location notification")
         
         if let message = notification.userInfo?["placemark"] as? String {
             speakMessage(message)
         }
     }
     
     @objc func recievedAdditionalMessageNotification(notification: NSNotification) {
         print("Got additional message notification notification")
         
         if let message = notification.userInfo?["additionalMessage"] as? String {
             speakMessage(message)
         }
     }
     
     func speakMessage(_ message: String) {
         let myUtterance = AVSpeechUtterance(string: message)
         myUtterance.rate = 0.5
         synthesizer.speak(myUtterance)
     }
 }*/
