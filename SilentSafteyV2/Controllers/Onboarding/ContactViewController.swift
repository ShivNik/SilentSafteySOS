//
//  ContactViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/16/22.
//

import UIKit
import SkyFloatingLabelTextField

class ContactViewController: UIViewController {
    
    var textField: SkyFloatingLabelTextField!
    var button: UIButton!
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEssential = TextFieldEssential(vcView: view)
        createUI()
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        displayExisitingNumber()
    }
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        let titleLabel = ReusableUIElements.createLabel(fontSize: 31, text: "Custom Contact Number (By default set to 911)")

        textField = ReusableUIElements.createSkyTextField(placeholder: "Enter ", title: "Enter Phone Number ", id: "CustomContactField")
        textField.addTarget(textFieldEssential, action: #selector(textFieldEssential.textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = textFieldEssential
        
        button = ReusableUIElements.createButton(title: "Save")
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,textField], spacing: 40, distributionType: .fillProportionally)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
           // stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: CGFloat(40))
        ])
        
    }
    
    func displayExisitingNumber() {
        if let number = AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber) {
            textField.text = number
        }
    }
    
    @objc func saveButtonPressed() {
        if(AppDelegate.validation.validatePhoneNumber(skyTextField: textField) || textField.text == "123" ) { // == "911"
            textField.errorMessage = ""
            AppDelegate.userDefaults.set(textField.text, forKey: AllStrings.phoneNumber)
            navigationController?.popToRootViewController(animated: true)
        } else {
            textField.errorMessage = "Invalid Phone Number"
            button.setTitle("Try Again", for: .normal)
        }
    }
}
