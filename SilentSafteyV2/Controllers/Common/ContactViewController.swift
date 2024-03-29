//
//  ContactViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/16/22.
//

import UIKit
import SkyFloatingLabelTextField

class ContactViewController: UIViewController {
    
    var textField: SkyFloatingLabelTextField = {
        return ReusableUIElements.createSkyTextField(placeholder: "Enter", title: "Enter Phone Number ", id: "CustomContactField")
    }()
    
    var button: UIButton = {
        return ReusableUIElements.createButton(title: "Save")
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Generate UI
        createUI()
        displayExisitingNumber()
        
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
    }
}

// MARK: -  UI Elements
extension ContactViewController {
    func createUI() {
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
        
        // Title Label
        let titleLabel = ReusableUIElements.createLabel(fontSize: 30, text: "Custom Contact Number")

        // Phone Number Text Field
        textField.delegate = self
        
        // Save Button
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        // Title and Text Field Stack VIew
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,textField], spacing: 40, distributionType: .fillProportionally)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
}

// MARK: - Buttion Action
extension ContactViewController {
    @objc func saveButtonPressed() {
        AppDelegate.userDefaults.set(textField.text, forKey: AllStrings.phoneNumber)
        if(textFieldEssential.validatePhoneNumber(skyTextField: textField)) {
            textField.errorMessage = ""
            button.setTitle("Save", for: .normal)
            
            AppDelegate.userDefaults.set(textField.text, forKey: AllStrings.phoneNumber)
            navigationController?.popToRootViewController(animated: true)
            
        } else {
            textField.errorMessage = "Invalid Phone Number"
            button.setTitle("Try Again", for: .normal)
        }
    }
}

// MARK: - TextField Delegate
extension ContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
