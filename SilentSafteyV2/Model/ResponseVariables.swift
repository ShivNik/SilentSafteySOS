//
//  ResponseVariables.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/15/22.
//

import Foundation

// Change number to AppDelegate.userDefaults.string(AllStrings.phoneNumber)
class Response {

    static var responseActive: Bool = false
    
    func completeResponse() {
        if(!Response.responseActive) {
            AppDelegate.location.checkRequestPermission()
            
            if(AppDelegate.location.retrieveLocationAuthorization() == .notDetermined) {
                print("set up notification")
                
                NotificationCenter.default.addObserver(self, selector: #selector(initiateDelayedResponse(notification:)), name: .locationAuthorizationDetermined, object: nil)
            }
            else {
                AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber)!)
            }
        } else {
            print("no executed response")
        }
    }
    
    @objc func initiateDelayedResponse(notification: NSNotification) {
        AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber)!)
        NotificationCenter.default.removeObserver(self)
    }
}
