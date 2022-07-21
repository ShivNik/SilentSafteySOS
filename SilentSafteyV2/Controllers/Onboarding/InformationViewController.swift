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
        createUI()
        displayExistingInformation()
        setupToHideKeyboardOnTapOnView()
        setKeyBoardType()
    }

    @objc
    func saveButtonAction(button: UIButton) {
    
        var allValid = true
        
        for skyTextField in skyTextFields {
            let trimmed = skyTextField.text!.trimmingCharacters(in: .whitespaces)
            
            if(!allValidation(floatingLabelTextField: skyTextField)) {
                allValid = false
            }  else if trimmed == "" {
                continue
            }  else {
                AppDelegate.userDefaults.set(trimmed, forKey: skyTextField.accessibilityIdentifier!)
            }
        }
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            if let vcLength = navigationController?.viewControllers.count {
                print(vcLength)
                let vc = (navigationController?.viewControllers[vcLength - 2])!
                let vcType = type(of: vc)
                
                if(vcType.self == SettingsViewController.self) {
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
            }
        }

        if(allValid) {
            self.navigationController?.pushViewController(WidgetDirectionViewController(), animated: true)
        }
    }
}

// MARK: -  UI Elements
extension InformationViewController {
    
    func createUI() {
        view.backgroundColor = .black
      
        // Inset Value Top and Bottom
        let window = UIApplication.shared.windows.first
        let topPadding = window!.safeAreaInsets.top
        let bottomPadding = window!.safeAreaInsets.bottom
        
        let safeArea = self.view.safeAreaLayoutGuide

        // Create and Constrain Scroll View
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
        ])
        
        // Create and Constrain UIView
        let uiView = UIStackView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            uiView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            uiView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Create and Constrain Save Button
        let saveButton = ReusableUIElements.createButton(title: "Save")
        uiView.addSubview(saveButton)
        saveButton.addTarget(self, action:#selector(saveButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.centerXAnchor.constraint(equalTo: uiView.centerXAnchor, constant: 0),
            saveButton.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: CGFloat(-40))
            
        ])
        
        // Create Title Labels
        let titleLabels = [
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "Step 1 information"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "Enter your information. This will be sent to the police")
        ]
    
        // Create and Constraint Stack View Labels
        let titleLabelStackView = ReusableUIElements.createStackView(stackViewElements: titleLabels, spacing: 0, distributionType: .fillEqually)
        uiView.addSubview(titleLabelStackView)
        
        NSLayoutConstraint.activate([
            titleLabelStackView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor, constant: 0),
            titleLabelStackView.topAnchor.constraint(equalTo: uiView.topAnchor),
            titleLabelStackView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 16),
            titleLabelStackView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -16)
        ])
        
        titleLabelStackView.layoutIfNeeded()
        
        // Create the skyTextFields for inputting information
        skyTextFields = [
            ReusableUIElements.createSkyTextField(placeholder: "Enter Name", title: "Enter Name", id: AllStrings.name),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Race", title: "Enter Race", id: AllStrings.race),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Gender", title: "Enter Gender", id: AllStrings.gender),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Weight", title: "Enter Weight", id: AllStrings.weight),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Age", title: "Enter Age", id: AllStrings.age),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Height", title: "Enter Height", id: AllStrings.height),
            ReusableUIElements.createSkyTextField(placeholder: "Enter Any Additional Information (Optional)", title: "Any Additional Information", id: AllStrings.additionalInfo),
        ]
        
        skyTextFields[0].autocorrectionType = .no
    
        for (_, skyTextField) in skyTextFields.enumerated() {
            skyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            skyTextField.delegate = self
            skyTextField.returnKeyType = .done
        }
    
        let skyTextFieldStackView = ReusableUIElements.createStackView(stackViewElements: skyTextFields, spacing: 0, distributionType: .equalSpacing)
        uiView.addSubview(skyTextFieldStackView)
        
        skyTextFieldStackView.layoutIfNeeded()
        
        // Determine Stack View Spaincg
        let navControllerHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let stackViewSpace = (view.frame.size.height - (topPadding + bottomPadding + navControllerHeight) - 130 - titleLabelStackView.frame.size.height)
        
        let spacing = (stackViewSpace - (skyTextFields[0].frame.size.height * CGFloat(skyTextFields.count))) / CGFloat((skyTextFields.count - 1))
        
        print("spacing \(spacing)")
        
        if(spacing < 25) {
            skyTextFieldStackView.spacing = 25
        }
        else {
            skyTextFieldStackView.spacing = spacing
        }
    
        // Constraint Sky Text Field Stack View
        NSLayoutConstraint.activate([
            skyTextFieldStackView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            skyTextFieldStackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            skyTextFieldStackView.topAnchor.constraint(equalTo: titleLabelStackView.bottomAnchor, constant: 20),
            skyTextFieldStackView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 16),
            skyTextFieldStackView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -16)
        ])
    }
    
    func displayExistingInformation() {
        for skyTextField in skyTextFields {
            if let value = AppDelegate.userDefaults.string(forKey: skyTextField.accessibilityIdentifier!) {
                skyTextField.text = value
            }
        }
    }
    
    func setKeyBoardType() {
        for i in 3...5 {
            skyTextFields[i].keyboardType = .asciiCapableNumberPad
        }
    }
}

// MARK: -  Text Validation Methods
extension InformationViewController {
    
    func allValidation(floatingLabelTextField: SkyFloatingLabelTextField) -> Bool {
        let errorMessage = "Invalid \(floatingLabelTextField.accessibilityIdentifier!)"
        
        switch floatingLabelTextField.accessibilityIdentifier {
            
        case AllStrings.name, AllStrings.race, AllStrings.gender:
            if(AppDelegate.validation.validateOnlyAlphabet(skyTextField: floatingLabelTextField)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }
        case AllStrings.weight:
            if(AppDelegate.validation.validateNumberConstraints(skyTextField: floatingLabelTextField, lowConstraint: 10, highConstraint: 1500)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.age:
            if(AppDelegate.validation.validateNumberConstraints(skyTextField: floatingLabelTextField, lowConstraint: 0, highConstraint: 123)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.height:
            if(AppDelegate.validation.validateHeight(skyTextField: floatingLabelTextField)) {
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
           AppDelegate.validation.replaceDot(skyTextField: floatingLabelTextField)
       }
    }
}

extension InformationViewController {
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
