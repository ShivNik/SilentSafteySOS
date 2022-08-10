//
//  LanguageSelectionViewController.swift
//  Silent Saftey
//
//  Created by Shivansh Nikhra on 8/9/22.
//

import UIKit
import SkyFloatingLabelTextField

class LanguageSelectionViewController: UIViewController {

    var textField: SkyFloatingLabelTextField = {
        return ReusableUIElements.createSkyTextField(placeholder: "Enter ", title: "Enter Phone Number ", id: "CustomContactField")
    }()
    
    var button: UIButton = {
        return ReusableUIElements.createButton(title: "Save")
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Generate UI
        createUI()
        
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
    }
}

extension LanguageSelectionViewController {
    func createUI() {
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
        
        // Title Label
        let titleLabel = ReusableUIElements.createLabel(fontSize: 30, text: "Custom Contact Number (By default set to 911)")

        // Language Selection Label
        textField.addTarget(textFieldEssential, action: #selector(textFieldEssential.textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = textFieldEssential
        
        // Save Button
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        // Title and Text Field Stack VIew
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,textField], spacing: 40, distributionType: .fillProportionally)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: CGFloat(40))
        ])
        
    }
}

// MARK: - Buttion Action
extension LanguageSelectionViewController {
    @objc func saveButtonPressed() {
        let languages: [String] = textField.text!.components(separatedBy: ",")
        print(languages)
    }
}
