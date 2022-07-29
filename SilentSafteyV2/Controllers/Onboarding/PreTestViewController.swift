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
        
        let buttonUIView = UIView()
        buttonUIView.translatesAutoresizingMaskIntoConstraints = false
        
        // Start Test Button
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Start the Test", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action:#selector(continueToTestButtonPressed), for: .touchUpInside)
        buttonUIView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: buttonUIView.centerXAnchor, constant: 0),
            button.centerYAnchor.constraint(equalTo: buttonUIView.centerYAnchor)
            
        ])
    
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
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "Enter a phone number you can use to test the app (Preferably a second phone nearby so you can hear the audio)"),
            skyView,
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "How to use the App"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "1. Tap the SOS Button and Start the Call"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "2. Go Back to the App"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "3. Type any Additional Messages"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "4. Press the Hang Up Message Button when you're done sending messages"),
            buttonUIView
        ]
        
        // Label Stack View
      //  let directionsStackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 0, distributionType: .fillProportionally)
    
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
    
    @objc func skipButtonPressed() {
        self.navigationController?.pushViewController(CompletionViewController(), animated: true)
    }

    @objc func continueToTestButtonPressed(button: UIButton) {
    
        if(textFieldEssential.validatePhoneNumber(skyTextField: skyTextField)) {
            skyTextField.errorMessage = ""
            button.setTitle("Start the Test", for: .normal)
            AppDelegate.testVC.testPhoneNumber = skyTextField.text!
            
            self.navigationController?.pushViewController(AppDelegate.testVC, animated: true)
            
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

