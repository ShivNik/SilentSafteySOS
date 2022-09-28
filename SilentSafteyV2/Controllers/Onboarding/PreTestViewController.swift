//
//  PreTestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class PreTestViewController: UIViewController {

    var skyTextField: SkyFloatingLabelTextField = {
        return ReusableUIElements.createSkyTextField(placeholder: "Enter Phone Number", title: "Enter Phone Number", id: "phoneNumber")
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Generate UI
        createUI()
        displayExistingInformation()
        
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
    }
}
// MARK: -  UI Elements
extension PreTestViewController {
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
        
        let buttonUIView = UIView()
        buttonUIView.translatesAutoresizingMaskIntoConstraints = false
        
        // Start Test Button
        let button = ReusableUIElements.createButton(title: "Start the Test")
        button.addTarget(self, action:#selector(continueToTestButtonPressed), for: .touchUpInside)
        buttonUIView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: buttonUIView.centerXAnchor, constant: 0),
            button.centerYAnchor.constraint(equalTo: buttonUIView.centerYAnchor)
            
        ])
    
        // Phone Number Sky Text Field
        skyTextField.delegate = self
        skyTextField.keyboardType = .asciiCapableNumberPad
        
        // Custom View
        let skyView = CustomView()
        skyView.size = skyTextField.intrinsicContentSize
        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.addSubview(skyTextField)
        
        NSLayoutConstraint.activate([
            skyTextField.centerXAnchor.constraint(equalTo: skyView.centerXAnchor),
            skyTextField.centerYAnchor.constraint(equalTo: skyView.centerYAnchor),
            skyTextField.leadingAnchor.constraint(equalTo: skyView.leadingAnchor),
            skyTextField.trailingAnchor.constraint(equalTo: skyView.trailingAnchor),
        ])

        // All Labels
        let labels = [
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "Step 3: Let's try it out"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "Enter a phone number you can use to test the app (Preferably a second phone nearby so you can hear the audio)"),
            skyView,
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "How to use the App"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "1. Tap the SOS button and confirm the call"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "2. (Optional) Return back to the app"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "3. (Optional) Type any additional messages you would like to convey, in any language"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "4. Your profile, location, and messages will be repeated once."),
            buttonUIView
        ]
    
        // Super Stack View
        let superStackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 0, distributionType: .fillEqually)
        view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            superStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    }
    
    func displayExistingInformation() {
        if let value = AppDelegate.userDefaults.string(forKey: AllStrings.phoneNumber) {
            skyTextField.text = value
        }
    }
}
// MARK: -  Button Action
extension PreTestViewController {
    @objc func continueToTestButtonPressed(button: UIButton) {
    
        if(textFieldEssential.validatePhoneNumber(skyTextField: skyTextField)) {
            
            if var trimmed = skyTextField.text {
                
                trimmed = trimmed.trimmingCharacters(in: .whitespaces)
                skyTextField.errorMessage = ""
                button.setTitle("Start the Test", for: .normal)

                AppDelegate.userDefaults.set(trimmed, forKey: AllStrings.phoneNumber)
                self.navigationController?.pushViewController(AppDelegate.testVC, animated: true)
            }
        
        } else {
            button.setTitle("Try Again", for: .normal)
            skyTextField.errorMessage = "Invalid Phone Number"
        }
    }
}

// MARK: - Custom View With Size
class CustomView: UIView {
    var size: CGSize?

    override var intrinsicContentSize: CGSize {
        return size!
    }
}

// MARK: - TextField Delegate
extension PreTestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
