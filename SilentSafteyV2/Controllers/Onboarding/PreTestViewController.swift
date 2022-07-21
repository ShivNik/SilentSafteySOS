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
    var skyTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        self.setupToHideKeyboardOnTapOnView()
    }

    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
        
        // Create Start Test Button
        let button = ReusableUIElements.createButton(title: "Start the Test")
        button.addTarget(self, action:#selector(continueToTestButtonPressed), for: .touchUpInside)
        
       /* NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
        ]) */
        // Create Phone Number Sky Text Field
        skyTextField = ReusableUIElements.createSkyTextField(placeholder: "Enter phone number", title: "Enter Phone Number", id: "phoneNumber")
        
        skyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Create and Constrain Custom View
        let skyView = CustomView()
        skyView.size = skyTextField.intrinsicContentSize
        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.addSubview(skyTextField)
        
        NSLayoutConstraint.activate([
            skyTextField.centerXAnchor.constraint(equalTo: skyView.centerXAnchor),
            skyTextField.centerYAnchor.constraint(equalTo: skyView.centerYAnchor),
            // skyTextField.heightAnchor.constraint(equalToConstant: 50),
            skyTextField.leadingAnchor.constraint(equalTo: skyView.leadingAnchor),
            skyTextField.trailingAnchor.constraint(equalTo: skyView.trailingAnchor),
        ])

        // Create All Labels
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
        
        // Create and Constrain Label Stack View
        let directionsStackView = UIStackView(arrangedSubviews: labels)
        directionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        directionsStackView.axis = .vertical
        directionsStackView.distribution = .fillProportionally
        directionsStackView.alignment = .fill
    
        // Create and Constrain Super Stack View
        let superStackView = ReusableUIElements.createStackView(stackViewElements: [  directionsStackView], spacing: 0, distributionType: .fillProportionally)
        view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            superStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
    }

    @objc func continueToTestButtonPressed(button: UIButton) {
        if(AppDelegate.validation.validatePhoneNumber(skyTextField: skyTextField)) {
            skyTextField.errorMessage = ""
            
            let vc = TestViewController()
            vc.testPhoneNumber = skyTextField.text!
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            button.setTitle("Try Again", for: .normal)
            skyTextField.errorMessage = "Invalid Phone Number"
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
            AppDelegate.validation.replaceDot(skyTextField: floatingLabelTextField)
        }
    }
}
extension PreTestViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(TestViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
// Custom View with Size
class CustomView: UIView {
    var size: CGSize?

    override var intrinsicContentSize: CGSize {
        return size!
    }
}

