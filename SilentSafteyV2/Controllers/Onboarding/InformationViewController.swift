//
//  InformationViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class InformationViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.indicatorStyle = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let skyTextFields: [SkyFloatingLabelTextField] = [
        ReusableUIElements.createSkyTextField(placeholder: "Enter Name", title: "Enter Name", id: AllStrings.name),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Race", title: "Enter Race", id: AllStrings.race),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Gender", title: "Enter Gender", id: AllStrings.gender),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Weight (Lb)", title: "Enter Weight (Lb)", id: AllStrings.weight),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Age", title: "Enter Age", id: AllStrings.age),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Height (Feet Inches)", title: "Enter Height (Feet Inches)", id: AllStrings.height),
        ReusableUIElements.createSkyTextField(placeholder: "Enter Additional Information", title: "Enter Additional Information", id: AllStrings.additionalInfo),
    ]
    
    var textFieldEssential: TextFieldEssential!
    var timerForShowScrollIndicator: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Generate UI 
        createUI()
        displayExistingInformation()
        setKeyBoardType()
        startTimerForShowScrollIndicator()
        
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
    }
}

// MARK: -  Button Actions
extension InformationViewController {
    @objc func saveButtonAction(button: UIButton) {
    
        var allValid = true
        
        for skyTextField in skyTextFields {
            let trimmed = skyTextField.text!.trimmingCharacters(in: .whitespaces)
            
            if(!allValidation(floatingLabelTextField: skyTextField)) {
                allValid = false
            } else {
                AppDelegate.userDefaults.set(trimmed, forKey: skyTextField.accessibilityIdentifier!)
            }
        }
        
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            if let vcLength = navigationController?.viewControllers.count {
                if vcLength >= 2 {
                    let vc = (navigationController?.viewControllers[vcLength - 2])!
                    let vcType = type(of: vc)
                    
                    if(vcType == SettingsViewController.self) {
                        self.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
            }
        }

        if(allValid) {
            self.navigationController?.pushViewController(WidgetDirectionViewController(), animated: true)
        }
    }
}

// MARK: -  Scroll View Indicator
extension InformationViewController {
    @objc func showScrollIndicatorsInContacts() {
         self.scrollView.flashScrollIndicators()
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: false)
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

        // Scroll View
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
        ])
        
        // Stack View Scroll View
        let scrollViewStackView = UIStackView()
        scrollViewStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewStackView)
        
        NSLayoutConstraint.activate([
            scrollViewStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Save Button
        let saveButton = ReusableUIElements.createButton(title: "Save")
        scrollViewStackView.addSubview(saveButton)
        saveButton.addTarget(self, action:#selector(saveButtonAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.centerXAnchor.constraint(equalTo: scrollViewStackView.centerXAnchor, constant: 0),
            saveButton.bottomAnchor.constraint(equalTo: scrollViewStackView.bottomAnchor, constant: CGFloat(-40))
        ])
        
        // Title Label
        let titleLabels = [
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "Step 1: Create your Profile"),
            ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "Your profile information will be sent to 911 when you initiate an SOS call")
        ]
        
        // Label Stack View
        let titleLabelStackView = ReusableUIElements.createStackView(stackViewElements: titleLabels, spacing: 0, distributionType: .fillEqually)
        scrollViewStackView.addSubview(titleLabelStackView)
        
        NSLayoutConstraint.activate([
            titleLabelStackView.centerXAnchor.constraint(equalTo: scrollViewStackView.centerXAnchor, constant: 0),
            titleLabelStackView.topAnchor.constraint(equalTo: scrollViewStackView.topAnchor),
            titleLabelStackView.leadingAnchor.constraint(equalTo: scrollViewStackView.leadingAnchor, constant: 16),
            titleLabelStackView.trailingAnchor.constraint(equalTo: scrollViewStackView.trailingAnchor, constant: -16)
        ])
        titleLabelStackView.layoutIfNeeded()
        
        // Information Sky Text Field
        skyTextFields[0].autocorrectionType = .no
    
        for (_, skyTextField) in skyTextFields.enumerated() {
            skyTextField.addTarget(textFieldEssential, action: #selector(textFieldEssential.textFieldDidChange(_:)), for: .editingChanged)
            skyTextField.delegate = textFieldEssential
            skyTextField.returnKeyType = .done
        }
    
        let skyTextFieldStackView = ReusableUIElements.createStackView(stackViewElements: skyTextFields, spacing: 0, distributionType: .equalSpacing)
        scrollViewStackView.addSubview(skyTextFieldStackView)
        
        skyTextFieldStackView.layoutIfNeeded()
        
        // Stack View Spacing
        let navControllerHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let stackViewSpace = (view.frame.size.height - (topPadding + bottomPadding + navControllerHeight) - 130 - titleLabelStackView.frame.size.height)
        
        let spacing = (stackViewSpace - (skyTextFields[0].frame.size.height * CGFloat(skyTextFields.count))) / CGFloat((skyTextFields.count - 1))
        
        if(spacing < 25) {
            skyTextFieldStackView.spacing = 25
        }
        else {
            skyTextFieldStackView.spacing = spacing
        }

        NSLayoutConstraint.activate([
            skyTextFieldStackView.centerXAnchor.constraint(equalTo: scrollViewStackView.centerXAnchor),
            skyTextFieldStackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            skyTextFieldStackView.topAnchor.constraint(equalTo: titleLabelStackView.bottomAnchor, constant: 20),
            skyTextFieldStackView.leadingAnchor.constraint(equalTo: scrollViewStackView.leadingAnchor, constant: 16),
            skyTextFieldStackView.trailingAnchor.constraint(equalTo: scrollViewStackView.trailingAnchor, constant: -16)
        ])
        
        let hyperLinkTextView = textViewHyperLink()
        
        view.addSubview(hyperLinkTextView)
        
        NSLayoutConstraint.activate([
            hyperLinkTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            hyperLinkTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            hyperLinkTextView.topAnchor.constraint(equalTo: saveButton.bottomAnchor),
            hyperLinkTextView.bottomAnchor.constraint(equalTo: scrollViewStackView.bottomAnchor)
        ])
    }
    
    func textViewHyperLink() -> UITextView {

        // Text View
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // Attributed String
        let attributedString = NSMutableAttributedString(string: "By continuing, you agree to our Terms and Conditions and Privacy Policy")
        let urlPrivacy = URL(string: "https://www.apple.com")!
        let urlTAC = URL(string: "https://www.apple.com")!

        attributedString.setAttributes([.link: urlPrivacy], range: NSRange(location: 32, length: 20))
        attributedString.setAttributes([.link: urlTAC], range: NSRange(location: 57, length: 14))
        
        attributedString.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 31))
        attributedString.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 53, length: 3))

        // Text View Characteristics
        textView.attributedText = attributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textAlignment = .center
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.font = UIFont.systemFont(ofSize: CGFloat(12))
        return textView
    }
    
    func displayExistingInformation() {
        for skyTextField in skyTextFields {
            if let value = AppDelegate.userDefaults.string(forKey: skyTextField.accessibilityIdentifier!) {
                skyTextField.text = value
            }
        }
    }
    
    func setKeyBoardType() {
        for i in 3...4 {
            skyTextFields[i].keyboardType = .asciiCapableNumberPad
        }
    }
}

// MARK: -  Text Field Validation Method
extension InformationViewController {
    
    func allValidation(floatingLabelTextField: SkyFloatingLabelTextField) -> Bool {
        let errorMessage = "Invalid \(floatingLabelTextField.accessibilityIdentifier!)"
        
        switch floatingLabelTextField.accessibilityIdentifier {
            
        case AllStrings.name, AllStrings.race, AllStrings.gender:
            if(textFieldEssential.validateOnlyAlphabet(skyTextField: floatingLabelTextField)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }
        case AllStrings.weight:
            if(textFieldEssential.validateNumberConstraints(skyTextField: floatingLabelTextField, lowConstraint: 10, highConstraint: 1500)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.age:
            if(textFieldEssential.validateNumberConstraints(skyTextField: floatingLabelTextField, lowConstraint: 0, highConstraint: 123)) {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else {
                floatingLabelTextField.errorMessage = errorMessage
                return false
            }

        case AllStrings.height:
            if(textFieldEssential.validateHeight(skyTextField: floatingLabelTextField)) {
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
