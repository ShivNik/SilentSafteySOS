//
//  CompletionViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/8/22.
//

import UIKit

class CompletionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Title Labels
        let labelsTwo = [
            ReusableUIElements.createLabel(fontSize: 50, text: "You're Done!"),
            ReusableUIElements.createLabel(fontSize: 30, text: "Set up your contacts and custom Messages")
        ]
        
        // Title Labels Stack View
        let stackView = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 20, distributionType: .fill)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // Finish tutorial Button
        let button = ReusableUIElements.createButton(title: "Finish Tutorial")
        button.addTarget(self, action: #selector(finishTutorialPressed), for: .touchUpInside)
        view.addSubview(button)
        ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -40)
    }
    
    @objc func finishTutorialPressed() {
        // AppDelegate.phoneCall.clearMessageArray() cuz send message in tutorial 
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            self.navigationController?.popToRootViewController(animated: true)
            
        } else {
            AppDelegate.userDefaults.set(true, forKey: AllStrings.tutorialFinished)

            let viewController = MainViewController()
            let navigation = ReusableUIElements.createNavigationController(root: viewController)
            navigation.delegate = AppDelegate.navControllerEssentials

            SceneDelegate.window?.rootViewController = navigation
            // Set default number to 911 - AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber)
        }
    }
}
