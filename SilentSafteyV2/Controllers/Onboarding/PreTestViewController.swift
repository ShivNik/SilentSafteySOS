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
        return ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEssential = TextFieldEssential(vcView: view)
        
        createUI()
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipButtonPressed))
    }
    
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
        
        // Start Test Button
        let button = ReusableUIElements.createButton(title: "Start the Test")
        view.addSubview(button)
        button.addTarget(self, action:#selector(continueToTestButtonPressed), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -40)
        
        // Phone Number Sky Text Field
        skyTextField.addTarget(textFieldEssential, action: #selector(textFieldEssential.textFieldDidChange(_:)), for: .editingChanged)
        skyTextField.delegate = textFieldEssential
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
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "Enter a phone number you can test the app with"),
            skyView,
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "How to use the App"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "1. Tap the SOS Button and start the call"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "2. Return back to the app once the phone call begins"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "3. Type any additional Messages into the Text-Field"),
        ]
        
        // Label Stack View
        let directionsStackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 0, distributionType: .fillProportionally)
    
        // Super Stack View
        let superStackView = ReusableUIElements.createStackView(stackViewElements: [  directionsStackView], spacing: 0, distributionType: .fillProportionally)
        view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            superStackView.bottomAnchor.constraint(equalTo: button.topAnchor),
            superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    }
    
    @objc func skipButtonPressed() {
        self.navigationController?.pushViewController(CompletionViewController(), animated: true)
    }

    @objc func continueToTestButtonPressed(button: UIButton) {
    
        if(textFieldEssential.validatePhoneNumber(skyTextField: skyTextField)) {
            skyTextField.errorMessage = ""
            
            let vc = TestViewController()
            vc.testPhoneNumber = skyTextField.text!
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            button.setTitle("Try Again", for: .normal)
            skyTextField.errorMessage = "Invalid Phone Number"
        }
    }
}

// Custom View with Size
class CustomView: UIView {
    var size: CGSize?

    override var intrinsicContentSize: CGSize {
        return size!
    }
}

