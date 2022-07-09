//
//  InformationViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class InformationViewController: UIViewController {

    var skyTextFields: [SkyFloatingLabelTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        createUI()
        displayExistingInformation()
    }

    @objc
    func saveButtonAction(button: UIButton) {
        for skyTextField in skyTextFields {
            if(skyTextField.text == "") {
                continue
            }
            else {
                if(allValidation(floatingLabelTextField: skyTextField)) {
                    let trimmed = skyTextField.text!.trimmingCharacters(in: .whitespaces)
                    AppDelegate.userDefaults.set(trimmed, forKey: skyTextField.accessibilityIdentifier!)
                }
            }
        }
        retrieveUserDefaults()
        self.navigationController?.pushViewController(WidgetDirectionViewController(), animated: true)
    }
}

// MARK: -  UI Elements
extension InformationViewController {
    func createUI() {
        let safeArea = self.view.safeAreaLayoutGuide

        // Create the Save Button
        let saveButton = ReusableUIElements.createButton(title: "Save")
        view.addSubview(saveButton)
        saveButton.addTarget(self, action:#selector(saveButtonAction), for: .touchUpInside)
        
        ReusableUIElements.buttonConstraints(button: saveButton, safeArea: safeArea, bottomAnchorConstant: -20)
        
        // Create the title Labels
        let titleLabels = [
            ReusableUIElements.createLabel(fontSize: 31, text: "Step 1 information"),
            ReusableUIElements.createLabel(fontSize: 20, text: "Enter your information. This will be sent to the police")
        ]
    
        // Create and constraint the stack view that holds the title labels
        let titleLabelStackView = ReusableUIElements.createStackView(stackViewElements: titleLabels, spacing: 0, distributionType: .fillEqually)
        view.addSubview(titleLabelStackView)
        
        NSLayoutConstraint.activate([
            titleLabelStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            titleLabelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    
        // Create the skyTextFields for inputting information
        skyTextFields = [
            ReusableUIElements.createSkyTextField(placeholder: "Enter Name", title: "Enter Name", id: AllStrings.name),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Race", title: "Enter Race", id: AllStrings.race),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Weight", title: "Enter Weight", id: AllStrings.weight),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Age", title: "Enter Age", id: AllStrings.age),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Height", title: "Enter Height", id: AllStrings.height),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Any Additional Information (Optional)", title: "Any Additional Information", id: AllStrings.additionalInfo)
        ]
    
        for (_, skyTextField) in skyTextFields.enumerated() {
            skyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            skyTextField.delegate = self
            skyTextField.returnKeyType = .done
        }
        
        // Create the sky text field stack view and constrain it
        let skyTextFieldStackView = ReusableUIElements.createStackView(stackViewElements: skyTextFields, spacing: 0, distributionType: .equalSpacing)
        view.addSubview(skyTextFieldStackView)
        
        NSLayoutConstraint.activate([
            skyTextFieldStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            skyTextFieldStackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -30),
            skyTextFieldStackView.topAnchor.constraint(equalTo: titleLabelStackView.bottomAnchor, constant: 30),
            skyTextFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            skyTextFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func displayExistingInformation() {
        
        for skyTextField in skyTextFields {
            if let value = AppDelegate.userDefaults.string(forKey: skyTextField.accessibilityIdentifier!) {
                
                skyTextField.text = value
            }
        }
     /*   if let name = AppDelegate.userDefaults.string(forKey: AllStrings.name) {
            skyTextFields[0].text = name
        }
        
        if let race = AppDelegate.userDefaults.string(forKey: AllStrings.race) {
            skyTextFields[1].text = race
        }
    
        if let weight = AppDelegate.userDefaults.string(forKey: AllStrings.weight) {
            skyTextFields[2].text = weight
        }
        
        if let age = AppDelegate.userDefaults.string(forKey: AllStrings.age) {
            skyTextFields[3].text = age
        }
        
        if let height = AppDelegate.userDefaults.string(forKey: AllStrings.height) {
            skyTextFields[4].text = height
        }
        
        if let additionalInfo = AppDelegate.userDefaults.string(forKey: AllStrings.additionalInfo) {
            skyTextFields[5].text = additionalInfo
        } */
    }
    
}

// MARK: -  Text Validation Methods
extension InformationViewController {
    func validateText(skyTextField: SkyFloatingLabelTextField) -> Bool {
        replaceDot(skyTextField: skyTextField)
        
        if skyTextField.text != "" {
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
                
            if((skyTextField.text!).rangeOfCharacter(from: set.inverted) == nil){
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func validateNumber(skyTextField: SkyFloatingLabelTextField, lowConstraint: Int, highConstraint: Int) -> Bool {
        
        replaceDot(skyTextField: skyTextField)
        
        let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let val = Int(trimmedString)
        
        if(trimmedString != "") {
            if(val != nil && val! > lowConstraint && val! < highConstraint) {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func validateHeight(skyTextField: SkyFloatingLabelTextField) -> Bool {
        
        replaceDot(skyTextField: skyTextField)
        
        let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if(trimmedString != "") {
            
            let all = (trimmedString).components(separatedBy: " ")
            
            if(all.count == 2 && Int(all[0]) != nil && Int(all[1]) != nil) {
                
                if(Int(all[0])! > 0 && Int(all[0])! <= 9 && Int(all[1])! >= 1 && Int(all[1])! <= 12) {
                    return true
                }
            }
        } else {
            return true
        }
        
        return false
    }
    
    func allValidation(floatingLabelTextField: SkyFloatingLabelTextField) -> Bool {
        let errorMessage = "Invalid \(floatingLabelTextField.accessibilityIdentifier!)"
        
        switch floatingLabelTextField.accessibilityIdentifier {
            
        case AllStrings.name, AllStrings.race:
            if(validateText(skyTextField: floatingLabelTextField)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }
        case AllStrings.weight:
            if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 10, highConstraint: 1500)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.age:
            if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 0, highConstraint: 123)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.height:
            if(validateHeight(skyTextField: floatingLabelTextField)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }
        default:
            return true
        }
    }
}

// MARK: -  Text Field Delegate Methods

extension InformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
            allValidation(floatingLabelTextField: floatingLabelTextField)
        }
    }

    func replaceDot(skyTextField: SkyFloatingLabelTextField) {
        skyTextField.text = skyTextField.text!.replacingOccurrences(of: ".", with: " ")
    }
}

// MARK: -  Testing Methods

extension InformationViewController {
    func retrieveUserDefaults() {
        print("Name \(AppDelegate.userDefaults.string(forKey: AllStrings.name))")
        print("Race \(AppDelegate.userDefaults.string(forKey: AllStrings.race))")
        print("Height \(AppDelegate.userDefaults.string(forKey: AllStrings.height))")
        print("Weight \(AppDelegate.userDefaults.string(forKey: AllStrings.weight))")
        print("Age \(AppDelegate.userDefaults.string(forKey: AllStrings.age))")
        print("Additional info \(AppDelegate.userDefaults.string(forKey: AllStrings.additionalInfo))")
    }
    
    func everythingBack() {
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.name)
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.race)
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.weight)
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.height)
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.age)
        AppDelegate.userDefaults.set(nil, forKey: AllStrings.additionalInfo)
    }
}


/*
 class InformationViewController: UIViewController {

     var validFields: [Bool] = [false, false, false, false, false, true]
     var skyTextFields: [SkyFloatingLabelTextField] = []
     
     override func viewDidLoad() {
         super.viewDidLoad()
       //  everythingBack()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         
         let safeArea = self.view.safeAreaLayoutGuide

         let button = ReusableUIElements.createButton(title: "Save")
         view.addSubview(button)
         button.addTarget(self, action:#selector(buttonAction), for: .touchUpInside)
         ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -30)
         
         skyTextFields = [
             ReusableUIElements.createSkyTextField(placeholder: "Enter Name", title: "Enter Name", id: AllStrings.name),
             ReusableUIElements.createSkyTextField(placeholder: "Enter Race", title: "Enter Race", id: AllStrings.race),
             ReusableUIElements.createSkyTextField(placeholder: "Enter Weight", title: "Enter Weight", id: AllStrings.weight),
             ReusableUIElements.createSkyTextField(placeholder: "Enter Age", title: "Enter Age", id: AllStrings.age),
             ReusableUIElements.createSkyTextField(placeholder: "Enter Height", title: "Enter Height", id: AllStrings.height),
             ReusableUIElements.createSkyTextField(placeholder: "Enter Any Additional Information (Optional)", title: "Any Additional Information", id: AllStrings.additionalInfo)
         ]
         for (_, skyTextField) in skyTextFields.enumerated() {
             skyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
             skyTextField.delegate = self
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
         
         displayExistingInformation()
     }
     
     @objc
     func buttonAction(button: UIButton) {
       /*  self.navigationController?.pushViewController(WidgetDirectionViewController(), animated: true) */
         
         var count = 0
         for val in validFields {
             if(val) {
                 count += 1
             }
         }
         
         if(count == 6) {
             for skyTextField in skyTextFields {
                 print(skyTextField.accessibilityIdentifier)
                 let trimmed = skyTextField.text!.trimmingCharacters(in: .whitespaces)
                 print(trimmed)
                 AppDelegate.userDefaults.set(trimmed, forKey: skyTextField.accessibilityIdentifier!)
             }
             self.navigationController?.pushViewController(WidgetDirectionViewController(), animated: true)
         }
         else {
             for i in 0..<5 {
                 if(!validFields[i]) {
                     skyTextFields[i].errorMessage = "Invalid " + skyTextFields[i].accessibilityIdentifier!
                 }
             }
             button.setTitle("Try Again", for: .normal)
         }
     }
     
     @objc func textFieldDidChange(_ textfield: UITextField) {
         
         if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
             
             switch floatingLabelTextField.accessibilityIdentifier {
                 
             case AllStrings.name:
                 if(validateText(skyTextField: floatingLabelTextField)) {
                     floatingLabelTextField.errorMessage = ""
                     validFields[0] = true
                 }
                 else {
                     floatingLabelTextField.errorMessage = "Invalid Entry"
                     validFields[0] = false
                 }
             case AllStrings.race:
                 if(validateText(skyTextField: floatingLabelTextField)) {
                     floatingLabelTextField.errorMessage = ""
                     validFields[1] = true
                 }
                 else {
                     floatingLabelTextField.errorMessage = "Invalid Entry"
                     validFields[1] = false
                 }
             case AllStrings.weight:
                 if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 10, highConstraint: 1500)) {
                     floatingLabelTextField.errorMessage = ""
                     validFields[2] = true
                 }
                 else {
                     floatingLabelTextField.errorMessage = "Invalid Entry"
                     validFields[2] = false
                 }

             case AllStrings.age:
                 if(validateNumber(skyTextField: floatingLabelTextField,lowConstraint: 0, highConstraint: 123)) {
                     floatingLabelTextField.errorMessage = ""
                     validFields[3] = true
                 }
                 else {
                     floatingLabelTextField.errorMessage = "Invalid Entry"
                     validFields[3] = false
                 }

             case AllStrings.height:
                 if(validateHeight(skyTextField: floatingLabelTextField)) {
                     floatingLabelTextField.errorMessage = ""
                     validFields[4] = true
                 }
                 else {
                     floatingLabelTextField.errorMessage = "Invalid Entry"
                     validFields[4] = false
                 }
             default:
                 validFields[5] = true
             }
         }
     }
     
     func validateText(skyTextField: SkyFloatingLabelTextField) -> Bool {
         skyTextField.text = skyTextField.text!.replacingOccurrences(of: ".", with: " ")
         if skyTextField.text != "" {
             let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
                 
             if((skyTextField.text!).rangeOfCharacter(from: set.inverted) == nil ){
                 return true
             }
         }
         return false
     }
     
     func validateNumber(skyTextField: SkyFloatingLabelTextField, lowConstraint: Int, highConstraint: Int) -> Bool {
         skyTextField.text = skyTextField.text!.replacingOccurrences(of: ".", with: " ")
         let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
         
         let val = Int(trimmedString)
         if(trimmedString != "" && val != nil) {
             if(val! > lowConstraint && val! < highConstraint) {
                 return true
             }
         }
         return false
     }
     
     func validateHeight(skyTextField: SkyFloatingLabelTextField) -> Bool {
         
         skyTextField.text = skyTextField.text!.replacingOccurrences(of: ".", with: " ")
         let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
         
         if(trimmedString != "") {
             
             let all = (trimmedString).components(separatedBy: " ")
             
             if(all.count == 2 && Int(all[0]) != nil && Int(all[1]) != nil) {
                 
                 if(Int(all[0])! > 0 && Int(all[0])! <= 9 && Int(all[1])! >= 1 && Int(all[1])! <= 12) {
                     return true
                 }
                 
             }

         }
         return false
     }
 }

 extension InformationViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.endEditing(true)
         return true
     }
     
     func retrieveUserDefaults() {
         print("Name \(AppDelegate.userDefaults.string(forKey: AllStrings.name))")
         print("Race \(AppDelegate.userDefaults.string(forKey: AllStrings.race))")
         print("Height \(AppDelegate.userDefaults.string(forKey: AllStrings.height))")
         print("Weight \(AppDelegate.userDefaults.string(forKey: AllStrings.weight))")
         print("Age \(AppDelegate.userDefaults.string(forKey: AllStrings.age))")
         print("Additional info \(AppDelegate.userDefaults.string(forKey: AllStrings.additionalInfo))")
     }
     
     func everythingBack() {
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.name)
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.race)
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.weight)
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.height)
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.age)
         AppDelegate.userDefaults.set(nil, forKey: AllStrings.additionalInfo)
     }
     
     func displayExistingInformation() {
         print(UserDefaults.standard.string(forKey: AllStrings.name))
         if let name = UserDefaults.standard.string(forKey: AllStrings.name) {
             skyTextFields[0].text = name
         }
         
         if let race = UserDefaults.standard.string(forKey: AllStrings.race) {
             skyTextFields[1].text = race
         }
         
         if let weight = UserDefaults.standard.string(forKey: AllStrings.weight) {
             skyTextFields[2].text = weight
         }
         
         if let age = UserDefaults.standard.string(forKey: AllStrings.age) {
             skyTextFields[3].text = age
         }
         
         if let height = UserDefaults.standard.string(forKey: AllStrings.height) {
             skyTextFields[4].text = height
         }
         
         if let additionalInfo = UserDefaults.standard.string(forKey: AllStrings.additionalInfo) {
             skyTextFields[5].text = additionalInfo
         }
     }
 }

 
 */
