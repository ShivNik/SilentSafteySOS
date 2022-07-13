//
//  SceneDelegate.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import MediaPlayer
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var location: Location!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
      //  print("scene delegate willconnectooptions")
        guard let scene = (scene as? UIWindowScene) else { return }
        
    //    AppDelegate.location.checkRequestPermission()
       
        if let userActivity = connectionOptions.userActivities.first {
            print("ConnectOptions \(userActivity.activityType)")
            
            NotificationCenter.default.addObserver(self, selector: #selector(tempFunc(notification:)), name: .locationAuthorizationGiven, object: nil)
            
            AppDelegate.phoneCall.initiatePhoneCall(number: 1231242)
        }
        
      /*  window = UIWindow(windowScene: scene)
        let introVC = TestViewController() // Change this bac
        window?.rootViewController = introVC
        window?.makeKeyAndVisible() */
        
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
       // print("the phone")
        
       
        
       // AppDelegate.userDefaults.set(false, forKey: AllStrings.tutorialFinished)
        
        let navController = UINavigationController()
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.isTranslucent = false
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            navController.addChild(MainViewController())
            window?.rootViewController = navController
        } else {
            
            navController.addChild(IntroViewController())
            navController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            window?.rootViewController = navController
        }
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
       // AppDelegate.location.checkRequestPermission()
      //  print("Scene became active")
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
        // AppDelegate.location.checkAuthorization()
        AppDelegate.phoneCall.initiatePhoneCall(number: 1231242)
        if(AppDelegate.location.retrieveLocationAuthorizaiton() == .notDetermined) {
            print("Not determined in scene continue user activity")
            
            NotificationCenter.default.addObserver(self, selector: #selector(tempFunc(notification:)), name: .locationAuthorizationGiven, object: nil)
        }
        else {
            if(AppDelegate.location.checkAuthorization()) {
                print("authorizaed")
                AppDelegate.location.retrieveLocation()
            }
            else {
                print("denied/restricted")
            }
        }
       // NotificationCenter.default.addObserver(self, selector: #selector(tempFunc(notification:)), name: .locationAuthorizationGiven, object: nil)
        
       /* location = Location()
        location.checkRequestPermission()
    
        NotificationCenter.default.addObserver(self, selector: #selector(tempFunc(notification:)), name: .locationAuthorizationGiven, object: nil) */ 
        
        // location.retrieveLocation()
    }
    
    @objc func tempFunc(notification: NSNotification) {
        if(AppDelegate.location.checkAuthorization()) {
            print("authorizaed")
            AppDelegate.location.retrieveLocation()
        }
        else {
            print("denied/restricted")
        }
        NotificationCenter.default.removeObserver(self)
    }
}

