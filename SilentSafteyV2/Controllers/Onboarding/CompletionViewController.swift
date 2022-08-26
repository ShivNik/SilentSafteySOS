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
}

// MARK: -  UI Elements
extension CompletionViewController {
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = self.view.safeAreaLayoutGuide
    
        // Title Labels
        let labelsTwo = [
            ReusableUIElements.createLabel(fontSize: 40, text: "You're Done!"),
            ReusableUIElements.createLabel(fontSize: 25, text: "Set up your custom contact in the settings menu (Current contact set to \(AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber)!))")
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
}

// MARK: - Button Action
extension CompletionViewController {
    @objc func finishTutorialPressed() {

        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            self.navigationController?.popToRootViewController(animated: true)
            
        } else {
            AppDelegate.userDefaults.set(true, forKey: AllStrings.tutorialFinished)

            let navigation = ReusableUIElements.createNavigationController(root:  MainViewController())
            navigation.delegate = AppDelegate.navControllerEssentials

            SceneDelegate.window?.rootViewController = navigation
        }
    }
}
