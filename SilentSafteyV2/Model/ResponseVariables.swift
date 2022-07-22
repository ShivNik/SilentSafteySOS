//
//  ResponseVariables.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/15/22.
//

import Foundation

class Response {

    static var responseActive: Bool = false
    
    func completeResponse() {
        if(!Response.responseActive) {
            AppDelegate.location.checkRequestPermission()
            
            if(AppDelegate.location.retrieveLocationAuthorizaiton() == .notDetermined) {
                print("set up notification")
                
                NotificationCenter.default.addObserver(self, selector: #selector(tempFuncMain(notification:)), name: .locationAuthorizationGiven, object: nil)
            }
            else {
                AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: "4693555568")
            }
        } else {
            print("no executed response")
        }
    }
    
    @objc func tempFuncMain(notification: NSNotification) {
        AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: "4693555568")
        NotificationCenter.default.removeObserver(self)
    }
}
