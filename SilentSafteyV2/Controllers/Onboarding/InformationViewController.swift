//
//  InformationViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class InformationViewController: UIViewController {

    var validFields: [Bool] = [false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.safeAreaLayoutGuide
        
        let button = ReusableUIElements.createButton(title: "Continue")
        view.addSubview(button)
        button.addTarget(self, action:#selector(buttonAction), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -30)
        
        let skyTextFields = [
            ReusableUIElements.createSkyTextField(placeholder: "Enter Name", title: "Enter Name", id: "Name"),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Race", title: "Enter Race", id: "Race"),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Weight", title: "Enter Weight", id: "Weight"),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Age", title: "Enter Age", id: "Age"),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Height", title: "Enter Height", id: "Height"),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Any Additional Information (Optional)", title: "Any Additional Information", id: "additionalInfo")
        ]
        for (_, skyTextField) in skyTextFields.enumerated() {
            skyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: skyTextFields, spacing: 0, distributionType: .equalSpacing)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
        
        let labelsTwo = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 1 information"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter your information. This will be sent to the police")
        ]
    
    
        let stackViewTwo = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 0, distributionType: .fillEqually)
        view.addSubview(stackViewTwo)
        
        NSLayoutConstraint.activate([
            stackViewTwo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            stackViewTwo.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30),
            stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    func buttonAction(button: UIButton) {
        print(validFields)
        
        var count = 0
        for val in validFields {
            if(val) {
                count += 1
            }
        }
        
        if(count == 5) {
            print("here")
        }
        else {
            button.setTitle("Try Again", for: .normal)
        }
       // self.navigationController?.pushViewController(InformationViewController(), animated: true)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
            
            switch floatingLabelTextField.accessibilityIdentifier {
                
            case "Name":
                if(validateText(skyTextField: floatingLabelTextField)) {
                    floatingLabelTextField.errorMessage = ""
                    validFields[0] = true
                }
                else {
                    floatingLabelTextField.errorMessage = "Invalid Entry"
                    validFields[0] = false
                }
            case "Race":
                if(validateText(skyTextField: floatingLabelTextField)) {
                    floatingLabelTextField.errorMessage = ""
                    validFields[1] = true
                }
                else {
                    floatingLabelTextField.errorMessage = "Invalid Entry"
                    validFields[1] = false
                }
            case "Weight":
                if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 10, highConstraint: 1500)) {
                    floatingLabelTextField.errorMessage = ""
                    validFields[2] = true
                }
                else {
                    floatingLabelTextField.errorMessage = "Invalid Entry"
                    validFields[2] = false
                }

            case "Age":
                if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 0, highConstraint: 123)) {
                    floatingLabelTextField.errorMessage = ""
                    validFields[3] = true
                }
                else {
                    floatingLabelTextField.errorMessage = "Invalid Entry"
                    validFields[3] = false
                }

            case "Height":
                if(validateHeight(skyTextField: floatingLabelTextField)) {
                    floatingLabelTextField.errorMessage = ""
                    validFields[4] = true
                }
                else {
                    floatingLabelTextField.errorMessage = "Invalid Entry"
                    validFields[4] = false
                }
            default:
                print("Do nothing") // change this so something
            }
        }
    }
    
    func validateText(skyTextField: SkyFloatingLabelTextField) -> Bool {
        if skyTextField.text != "" {
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
                
            if((skyTextField.text!).rangeOfCharacter(from: set.inverted) == nil ){
                return true
            }
        }
        return false
    }
    
    func validateNumber(skyTextField: SkyFloatingLabelTextField, lowConstraint: Double, highConstraint: Double) -> Bool {
        
        let val = Double(skyTextField.text!)
        if(skyTextField.text != "" && val != nil) {
            if(val! > lowConstraint && val! < highConstraint) {
                return true
            }
        }
        return false
    }
    
    func validateHeight(skyTextField: SkyFloatingLabelTextField) -> Bool {

        if(skyTextField.text != "") {
            
            let all = (skyTextField.text!).components(separatedBy: " ")
            
            if(all.count == 2 && Double(all[0]) != nil && Double(all[1]) != nil) {
                
                if(Double(all[0])! > 0 && Double(all[0])! <= 9 && Double(all[1])! >= 1 && Double(all[1])! <= 12) {
                    return true
                }
                
            }

        }
        return false
    }
}
