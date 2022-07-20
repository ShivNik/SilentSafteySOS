//
//  ContactViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/16/22.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        let titleLabel = ReusableUIElements.createLabel(fontSize: 31, text: "Custom Contact Number (By default set to 911)")

        let textField = ReusableUIElements.createSkyTextField(placeholder: "Enter ", title: "Enter ", id: "CustomContactField")
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,textField], spacing: 40, distributionType: .fillProportionally)
        view.addSubview(stackView)
        
        // stackView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
           // stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
