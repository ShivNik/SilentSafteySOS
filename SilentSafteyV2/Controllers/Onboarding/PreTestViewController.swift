//
//  PreTestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class PreTestViewController: UIViewController {
    var validTextField = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        
        let safeArea = self.view.safeAreaLayoutGuide
        let button = ReusableUIElements.createButton(title: "Let's do it!")
        view.addSubview(button)
        button.addTarget(self, action:#selector(continueToTestAction), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -80)
        
        let directionsLabel = ReusableUIElements.createLabel(fontSize: 31, text: "How to use the App")
        directionsLabel.font = UIFont.boldSystemFont(ofSize: 31)
        
        let labels = [
            directionsLabel,
            ReusableUIElements.createLabel(fontSize: 20, text: "1. Tap the SOS Button and start the call"),
            ReusableUIElements.createLabel(fontSize: 20, text: "2. Return back to the app once the phone call begins"),
            ReusableUIElements.createLabel(fontSize: 20, text: "3. Type any additional Messages into the Text-Field")
        ]
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 0, distributionType: .equalSpacing)
        self.view.addSubview(stackView)
    
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
    
        let labelsTwo = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with")
        ]

        let stackViewTwo = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 20, distributionType: .fillEqually)
        view.addSubview(stackViewTwo)
        
        NSLayoutConstraint.activate([
            stackViewTwo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackViewTwo.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
        let phoneNumberSkyTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
        view.addSubview(phoneNumberSkyTextField)
        phoneNumberSkyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            phoneNumberSkyTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            phoneNumberSkyTextField.topAnchor.constraint(equalTo: stackViewTwo.bottomAnchor, constant: 40),
            phoneNumberSkyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneNumberSkyTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])  
    }
    
    @objc
    func continueToTestAction(button: UIButton) {
        if(true) { // Change back to validTextField
            self.navigationController?.pushViewController(TestViewController(), animated: true)
        } else {
            button.setTitle("Try Again", for: .normal)
        }
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
            if(validatePhoneNumber(skyTextField: floatingLabelTextField)) {
                floatingLabelTextField.errorMessage = ""
                validTextField = true
            }
            else {
                floatingLabelTextField.errorMessage = "Invalid Phone Number"
                validTextField = false
            }
        }
    }
    
    func validatePhoneNumber(skyTextField: SkyFloatingLabelTextField) -> Bool {
        if skyTextField.text != "" && Double(skyTextField.text!) != nil {
            if(skyTextField.text!.count == 10) {
                return true
            }
        }
        return false
    }
}
