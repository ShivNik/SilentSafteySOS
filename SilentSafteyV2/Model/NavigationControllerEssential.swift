//
//  NavigationControllerEssential.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/21/22.
//

import Foundation
import UIKit

class NavigationControllerEssentials: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            let vcType = type(of: viewController)
            
            let vcValid = (vcType == MainViewController.self) || (vcType == SettingsViewController.self) || (vcType == ContactViewController.self) || (vcType == ViewMessageViewController.self)
            
            if(!vcValid) {
                 let exitBarButton = CustomBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitPressed(sender:)))
                 exitBarButton.navController = navigationController
                 
                 viewController.navigationItem.rightBarButtonItem = exitBarButton
            }
        }
    }
    
    @objc func exitPressed(sender: CustomBarButtonItem) {
        print("Exist pressed")
        sender.navController?.popToRootViewController(animated: true)
    }
}

class CustomBarButtonItem: UIBarButtonItem {
    var navController: UINavigationController?
}
