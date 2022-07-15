//
//  SettingsViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/14/22.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        let tutorialButton = ReusableUIElements.createButton(title: "Tutorial")
        let profileButton = ReusableUIElements.createButton(title: "Profile")
        let contactButton = ReusableUIElements.createButton(title: "Contact")
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [tutorialButton,profileButton,contactButton], spacing: 40, distributionType: .equalSpacing)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])
    }
}
