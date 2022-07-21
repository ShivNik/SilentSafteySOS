//
//  SceneDelegate.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import MediaPlayer
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UINavigationControllerDelegate {

    var window: UIWindow?
    var location: Location!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            AppDelegate.response.completeResponse()
        }
        
        let window = UIWindow(windowScene: scene)
        
        AppDelegate.userDefaults.set(false, forKey: AllStrings.tutorialFinished)
        
        let viewController: UIViewController?
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            viewController = MainViewController()
        } else {
            viewController = IntroViewController()
        }
        
        let navController = ReusableUIElements.createNavigationController(root: viewController!)
        navController.delegate = self
    
        window.rootViewController = navController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
      /*  AppDelegate.location.checkRequestPermission()
        print("Scene became active") */
        print("scene did become active")
      //  AppDelegate.location.locationManager.stopUpdatingLocation()
    
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
  /*  func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        print(userActivityType)
    } */
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(userActivity.activityType)
        print("scene delegate continue suera activty")
    
        AppDelegate.response.completeResponse()
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            let vcType = type(of: viewController)
            print("Scene Delegate \(viewController)")
        
            let vcValid = (vcType == MainViewController.self) || (vcType == SettingsViewController.self) || (vcType == ContactViewController.self)
            
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
