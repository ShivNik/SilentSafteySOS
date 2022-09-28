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
            
            if(AppDelegate.location.retrieveLocationAuthorization() == .notDetermined) {
                NotificationCenter.default.addObserver(self, selector: #selector(initiateDelayedResponse(notification:)), name: .locationAuthorizationDetermined, object: nil)
            }
            else {
                if let phoneNumber = AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber) {
                    AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: phoneNumber)
                }
            }
        }
    }
    
    @objc func initiateDelayedResponse(notification: NSNotification) {
        if let phoneNumber = AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber) {
            AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: phoneNumber)
        }
        NotificationCenter.default.removeObserver(self)
    }
}
