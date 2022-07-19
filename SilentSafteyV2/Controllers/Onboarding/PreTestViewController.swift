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
        view.backgroundColor = .brown
     //   self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .done, target: nil, action: nil)
        print("rains it pours")
        createUI()
    }
    
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
        
        let button = ReusableUIElements.createButton(title: "Let's do it!")
        button.addTarget(self, action:#selector(continueToTestAction), for: .touchUpInside)
        
        
        let skyTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
        
        let skyView = CustomView()
        skyView.size = skyTextField.intrinsicContentSize
        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.addSubview(skyTextField)
        
        NSLayoutConstraint.activate([
            skyTextField.centerXAnchor.constraint(equalTo: skyView.centerXAnchor),
            skyTextField.centerYAnchor.constraint(equalTo: skyView.centerYAnchor),
            skyTextField.heightAnchor.constraint(equalToConstant: 50),
            skyTextField.leadingAnchor.constraint(equalTo: skyView.leadingAnchor),
            skyTextField.trailingAnchor.constraint(equalTo: skyView.trailingAnchor),
            
        ])
        
       // skyView.backgroundColor = .brown
       
        print(skyTextField.heightAnchor.accessibilityTraits.rawValue)

        let labels = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with"),
            skyView,
            ReusableUIElements.createLabel(fontSize: 31, text: "How to use the App"),
            ReusableUIElements.createLabel(fontSize: 20, text: "1. Tap the SOS Button and start the call"),
            ReusableUIElements.createLabel(fontSize: 20, text: "2. Return back to the app once the phone call begins"),
            ReusableUIElements.createLabel(fontSize: 20, text: "3. Type any additional Messages into the Text-Field"),
            button
        ]
        
        // Directions Labels stack view creation
        let directionsStackView = UIStackView(arrangedSubviews: labels)
        directionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        directionsStackView.axis = .vertical
        directionsStackView.distribution = .fillProportionally
        directionsStackView.alignment = .fill
      //  directionsStackView.backgroundColor = .brown
    
     /*   let phoneNumberElements = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with"),
        //    ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
        ]
        
        let phoneNumberStackView = ReusableUIElements.createStackView(stackViewElements: phoneNumberElements, spacing: 0, distributionType: .fillEqually)
        phoneNumberStackView.backgroundColor = .blue
        
        let skyTextFieldTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
       
        let uiview = UIView()
        uiview.addSubview(skyTextFieldTextField)
        // uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            skyTextFieldTextField.leadingAnchor.constraint(equalTo: uiview.leadingAnchor),
            skyTextFieldTextField.trailingAnchor.constraint(equalTo: uiview.trailingAnchor),
            skyTextFieldTextField.bottomAnchor.constraint(equalTo: uiview.bottomAnchor),
            
        ]) */
    
        let superStackView = ReusableUIElements.createStackView(stackViewElements: [  directionsStackView], spacing: 0, distributionType: .fillProportionally)
        view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            superStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
      /*  NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]) */

        
    /*
        // Let's do it Button Creation
        let button = ReusableUIElements.createButton(title: "Let's do it!")
        button.addTarget(self, action:#selector(continueToTestAction), for: .touchUpInside)
    
     /*   let buttonUIView = UIView()
        buttonUIView.backgroundColor = .orange
        buttonUIView.translatesAutoresizingMaskIntoConstraints = false */
      //  buttonUIView.addSubview(button)
        
        
        NSLayoutConstraint.activate([
          //  button.widthAnchor.constraint(equalToConstant: 150),
          //  button.heightAnchor.constraint(equalToConstant: 50),
            
          //  button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
          //  button.bottomAnchor.constraint(equalTo: buttonUIView.bottomAnchor, constant: -20)
        ])
         
        
        
        // Direction labels
        let labels = [
            ReusableUIElements.createLabel(fontSize: 31, text: "How to use the App"),
            ReusableUIElements.createLabel(fontSize: 20, text: "1. Tap the SOS Button and start the call"),
            ReusableUIElements.createLabel(fontSize: 20, text: "2. Return back to the app once the phone call begins"),
            ReusableUIElements.createLabel(fontSize: 20, text: "3. Type any additional Messages into the Text-Field")
        ]
        
        // Directions Labels stack view creation
        let directionsStackView = UIStackView(arrangedSubviews: labels)
        directionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        directionsStackView.axis = .vertical
        directionsStackView.distribution = .fillProportionally
        directionsStackView.alignment = .fill
        // directionsStackView.backgroundColor = .brown
        
      /*  NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]) */

        let phoneNumberElements = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with"),
        ]
        
        let phoneNumberStackView = ReusableUIElements.createStackView(stackViewElements: phoneNumberElements, spacing: 0, distributionType: .fillEqually)
       // phoneNumberStackView.backgroundColor = .red
        
      //  stepThreeLabel.backgroundColor = .blue
        let uiViewTemp = UIView()
      //  uiViewTemp.backgroundColor = .orange
        
        let skyTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
        skyTextField.translatesAutoresizingMaskIntoConstraints = false
        uiViewTemp.addSubview(skyTextField)
        
        NSLayoutConstraint.activate([
            skyTextField.trailingAnchor.constraint(equalTo: uiViewTemp.trailingAnchor),
            skyTextField.leadingAnchor.constraint(equalTo: uiViewTemp.leadingAnchor),
            skyTextField.topAnchor.constraint(equalTo: uiViewTemp.topAnchor),
            skyTextField.bottomAnchor.constraint(equalTo: uiViewTemp.bottomAnchor)
        ])
        
       // var skyTextFieldPhoneNumber = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber"),
        
        let superStackView = ReusableUIElements.createStackView(stackViewElements:                [phoneNumberStackView, uiViewTemp, directionsStackView, button], spacing: 0, distributionType: .fillProportionally)
        view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            superStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    
       // superStackView.addSubview(buttonUIView)
     //   superStackView.addSubview(directionsStackView) */
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

/*
 // Let's do it Button Creation
 let button = ReusableUIElements.createButton(title: "Let's do it!")
 view.addSubview(button)
 button.addTarget(self, action:#selector(continueToTestAction), for: .touchUpInside)
 ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -20)
 
 // Title Label Creation
 let labelsTwo = [
     ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
     ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with")
 ]
 
 // Stack View Title Creation
 let stackViewTwo = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 0, distributionType: .fillEqually)
 view.addSubview(stackViewTwo)
 
 NSLayoutConstraint.activate([
     stackViewTwo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
     stackViewTwo.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
     stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
     stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
 ])
 
 // Directions Label Creation
 let directionsLabel = ReusableUIElements.createLabel(fontSize: 31, text: "How to use the App")
 directionsLabel.font = UIFont.boldSystemFont(ofSize: 31)
 
 let labels = [
     directionsLabel,
     ReusableUIElements.createLabel(fontSize: 20, text: "1. Tap the SOS Button and start the call"),
     ReusableUIElements.createLabel(fontSize: 20, text: "2. Return back to the app once the phone call begins"),
     ReusableUIElements.createLabel(fontSize: 20, text: "3. Type any additional Messages into the Text-Field")
 ]
 
 // Directions Labels stack view creation
 let stackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 0, distributionType: .equalSpacing)
 self.view.addSubview(stackView)

 NSLayoutConstraint.activate([
     stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
     stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
 ])

 // UIView for phone number text field
 let uiView = UIView()
 view.addSubview(uiView)
 uiView.translatesAutoresizingMaskIntoConstraints = false
 uiView.backgroundColor = .black
 
 NSLayoutConstraint.activate([
     uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
     uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
     uiView.topAnchor.constraint(equalTo: stackViewTwo.bottomAnchor),
     uiView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
 ])
 
 // Phone number text field
 let phoneNumberSkyTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
 uiView.addSubview(phoneNumberSkyTextField)
 phoneNumberSkyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
 
 NSLayoutConstraint.activate([
     phoneNumberSkyTextField.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
     phoneNumberSkyTextField.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
     phoneNumberSkyTextField.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 16),
     phoneNumberSkyTextField.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -16),
 ])
 
 
 */





/*
 view.backgroundColor = .black
 self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
 
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
 */
class CustomView: UIView {
    var size: CGSize?
    
    override var intrinsicContentSize: CGSize {
        return size!
    }
}
