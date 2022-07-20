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
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        let tutorialButton = ReusableUIElements.createButton(title: "Tutorial")
        let profileButton = ReusableUIElements.createButton(title: "Profile")
        let contactButton = ReusableUIElements.createButton(title: "Contact")
        
        tutorialButton.addTarget(self, action: #selector(tutorialButtonPressed), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        contactButton.addTarget(self, action: #selector(contactButtonPressed), for: .touchUpInside)
        
        ReusableUIElements.settingButtonConstraint(button: tutorialButton, safeArea: safeArea)
        ReusableUIElements.settingButtonConstraint(button: profileButton, safeArea: safeArea)
        ReusableUIElements.settingButtonConstraint(button: contactButton, safeArea: safeArea)
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [tutorialButton,profileButton,contactButton], spacing: 40, distributionType: .fillEqually)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    @objc func tutorialButtonPressed() {
        self.navigationController?.pushViewController(IntroViewController(), animated: true)
    }
    @objc func profileButtonPressed() {
        self.navigationController?.pushViewController(InformationViewController(), animated: true)
       /* let allVCs = self.navigationController!.children
        print(allVCs.description) */
        
    }
    
    @objc func contactButtonPressed() {
        self.navigationController?.pushViewController(ContactViewController(), animated: true)
    }
}
