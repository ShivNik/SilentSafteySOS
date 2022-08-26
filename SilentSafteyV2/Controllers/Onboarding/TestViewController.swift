//
//  TestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/7/22.
//

import UIKit

class TestViewController: UIViewController {

    let textView: UITextView = {
        let textView = ReusableUIElements.createTextView()
        textView.autocorrectionType = .yes
        return textView
    }()
    
    let directionsLabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "1. Tap the SOS Button, Start the Call, and Return to the App")
    }()

    var middleUIView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let continueButton: UIButton = {
        let continueButton = ReusableUIElements.createButton(title: "Continue")
        return continueButton
    }()
    
    let restartButton: UIButton = {
        let restartButton = ReusableUIElements.createButton(title: "Restart Tutorial")
        return restartButton
    }()
    
    let buttonStackView: UIStackView = {
    
        let buttonStackView = ReusableUIElements.createStackView(stackViewElements: [], spacing: 20, distributionType: .fillEqually)
        buttonStackView.axis = .horizontal
        return buttonStackView
    }()

    var textFieldEssential: TextFieldEssential!
    
    var mainButtonPressed = false
    var sendButtonPressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate UI
        createUI()
    
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        finishTutorial()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate.phoneCall.observeSynthesizerDelegate = self
    }
}

// MARK: -  UI Elements
extension TestViewController {
    
    func createUI() {
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(directionsLabel)
        NSLayoutConstraint.activate([
            directionsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            directionsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            directionsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            directionsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    
        // Text View
        textView.delegate = self
        view.addSubview(textView)
        ReusableUIElements.textViewConstraints(textView: textView, safeArea: safeArea)
        
        // Send Button
        let button = ReusableUIElements.createSendButton(textView: textView)
        view.addSubview(button)
        button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
        
        ReusableUIElements.sendButtonConstraints(button: button, view: self.view, safeArea: safeArea, textView: textView)
      
        // SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)
        
        NSLayoutConstraint.activate([
            sosButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 20),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Middle UI View
        middleUIView = UIView()
        view.addSubview(middleUIView)
        middleUIView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            middleUIView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            middleUIView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            middleUIView.topAnchor.constraint(equalTo: sosButton.bottomAnchor),
            middleUIView.bottomAnchor.constraint(equalTo:  textView.topAnchor)
        ])
        
        // Button Stack View
        buttonStackView.addArrangedSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        continueButton.isHidden = true
        
        buttonStackView.addArrangedSubview(restartButton)
        restartButton.addTarget(self, action: #selector(restartTutorialPressed), for: .touchUpInside)
        restartButton.isHidden = true
        
        middleUIView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: 300),
            
            buttonStackView.centerXAnchor.constraint(equalTo: middleUIView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: middleUIView.centerYAnchor)
        ])
    }
}

// MARK: -  Button Action
extension TestViewController {
    @objc func sosButtonPressed() {
        AppDelegate.response.completeResponse()
    }
    
    @objc func sendPressed() {
        if(mainButtonPressed) {
            if let message = textView.text {
                
                let trimmedString = message.trimmingCharacters(in: .whitespaces)
                
                if(trimmedString == "Type Additional Message Here" || trimmedString == "") {
                    return
                }
                
                textView.text = "Type Additional Message Here"
                
                sendButtonPressed = true
                directionsLabel.text = "3. After the messages are repeated, you can listen to the dispatcher and type responses. Hang up the call to finish the tutorial"
                directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.descriptionFontSize))
                
                TranslationManager.shared.detectLanguage(forText: trimmedString) {[self] (language) in
                    if let language = language {
                        if language != "en" {
                            TranslationManager.shared.translate(textToTranslate: trimmedString, sourceLanguageCode: language, targetLanguageCode: "en") { [self] (translation) in
                                
                                if let translation = translation {
                                    print(translation)
                                    sendAdditionalMessageNotification(additionalMessage: translation)
                                } else {
                                    sendAdditionalMessageNotification(additionalMessage: trimmedString)
                                }
                            }
                        } else {
                            sendAdditionalMessageNotification(additionalMessage: trimmedString)
                        }
                    } else {
                        sendAdditionalMessageNotification(additionalMessage: trimmedString)
                    }
                }
            }
        }
    }
    
    func sendAdditionalMessageNotification(additionalMessage: String) {
        NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": additionalMessage])
    }
    
    @objc func continueButtonPressed() {
        self.navigationController?.pushViewController(CompletionViewController(), animated: true)
    }
    
    @objc func restartTutorialPressed() {
        restartTutorial()
    }
}

// MARK: -  State of Tutorial
extension TestViewController {
    func restartTutorial() {
        directionsLabel.text = "1. Tap the SOS Button, Start the Call, and Return to the App"
        directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.titleFontSize))
       
        mainButtonPressed = false
        sendButtonPressed = false
        
        continueButton.isHidden = true
        restartButton.isHidden = true
    }
    
    func finishTutorial() {
        if(AppDelegate.userDefaults.bool(forKey: AllStrings.tutorialFinished)) {
            directionsLabel.text = "Test Run Finished"
            directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.titleFontSize))
            
            mainButtonPressed = true
            sendButtonPressed = true
            
            continueButton.isHidden = false
            restartButton.isHidden = false
        }
    }
}

// MARK: -  Observe Synthesizer Delegate
extension TestViewController: ObserveSynthesizer {
    func synthesizerStarted() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .green
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
    }
    
    func synthesizerEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }
    
    func callDialing() {
        directionsLabel.text = "2. Type an Additional Message (In any language) and Tap the Send Button. The green bar indicates that the bot is speaking."
        directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.descriptionFontSize))
        
        mainButtonPressed = true
    }
    
    func callEnded() {
        
        if(mainButtonPressed && sendButtonPressed) {
            
            directionsLabel.text = "Test Run Finished"
            directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.titleFontSize))
            
            continueButton.isHidden = false
            restartButton.isHidden = false

            self.navigationController?.pushViewController(CompletionViewController(), animated: true)
            
        } else {
            directionsLabel.text = "Don't End the Call Until All Messages have been said - Restarting Tutorial"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.restartTutorial()
            }
        }
        
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }
}

// MARK: -  Text View Delegate Methods
extension TestViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Additional Message Here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Additional Message Here"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        let newHeight = newSize.height
        
        if newHeight >= 100 {
            if(!textView.isScrollEnabled) {
                textView.isScrollEnabled = true
                for constraint in textView.constraints {
                    if(constraint.identifier == "heightConstraint") {
                        constraint.constant = newHeight
                        constraint.priority = UILayoutPriority(1000)
                    }
                }
            }
        } else {
            textView.isScrollEnabled = false
            for constraint in textView.constraints {
                if(constraint.identifier == "heightConstraint") {
                    constraint.constant = newHeight
                    constraint.priority = UILayoutPriority(250)
                }
            }
        }
    }
}
