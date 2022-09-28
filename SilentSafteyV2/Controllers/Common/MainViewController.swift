//
//  MainViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import UIKit

class MainViewController: UIViewController {
    
    let textView: UITextView = {
        let textView = ReusableUIElements.createTextView()
        textView.autocorrectionType = .yes
        return textView
    }()

    let messageTipsLabel: UILabel = {
        let oneLabel = ReusableUIElements.createLabel(fontSize: 0, text: "")
        return oneLabel
    }()
    
    let messageTipsLabelText: NSMutableAttributedString = {
        let myMutableString = NSMutableAttributedString(string: "Message Tips", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(ReusableUIElements.titleFontSize))])
        
        myMutableString.append(NSMutableAttributedString(string: "\n 1. Describe the Situation \n 2. Enter Additional Location Information (Apartment/Building number etc.)"))
        
        return myMutableString
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Generate UI
        createUI()
        
        // Tap outside Keyboard
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        // Location Start-Up
        AppDelegate.location.checkRequestPermission()
        AppDelegate.location.delegate = self
        AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate.phoneCall.observeSynthesizerDelegate = self
    }
}

// MARK: -  UI Elements
extension MainViewController {
    func createUI() {
        
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
        
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
            sosButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Middle UI View
        let uiView = UIView()
        view.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: sosButton.bottomAnchor),
            uiView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
    
        // Tips Label
        messageTipsLabel.attributedText = messageTipsLabelText
        messageTipsLabel.font = messageTipsLabel.font.withSize(CGFloat(ReusableUIElements.descriptionFontSize))
        messageTipsLabel.adjustsFontSizeToFitWidth = true
        messageTipsLabel.minimumScaleFactor = 0.2
        uiView.addSubview(messageTipsLabel)
        
        NSLayoutConstraint.activate([
            messageTipsLabel.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            messageTipsLabel.topAnchor.constraint(equalTo: uiView.topAnchor),
            messageTipsLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            messageTipsLabel.leadingAnchor.constraint(equalTo: uiView.leadingAnchor)
        ])
        
        // Navigation Bar Buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonPressed))
    }
}

// MARK: -  Button Actions
extension MainViewController {
    
    @objc func sosButtonPressed() {
        AppDelegate.response.completeResponse()
    }
    
    @objc func sendPressed() {
        if let message = textView.text {
            let trimmedString = message.trimmingCharacters(in: .whitespaces)
            
            if(trimmedString == "Type Additional Message Here" || trimmedString == "") {
                return
            }
            
            textView.text = "Type Additional Message Here"
            
            TranslationManager.shared.detectLanguage(forText: trimmedString) {[self] (language) in
                if let language = language {
                    if language != "en" {
                        TranslationManager.shared.translate(textToTranslate: trimmedString, sourceLanguageCode: language, targetLanguageCode: "en") { [self] (translation) in
                            
                            if let translation = translation {
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
    
    func sendAdditionalMessageNotification(additionalMessage: String) {
        NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": additionalMessage])
    }

    @objc func settingsButtonPressed() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}

// MARK: -  Text View Delegate Methods
extension MainViewController: UITextViewDelegate {
    
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
                }
            }
        }
    }
}

// MARK: -  Location Delegate Methods
extension MainViewController: LocationProtocol {
    func updateLocationLabel(text: String) {
        let newLineText = "\n" + text

        let myMutableString = NSMutableAttributedString(string: newLineText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(ReusableUIElements.titleFontSize))])
        
        let existingTextMutable = NSMutableAttributedString(attributedString: messageTipsLabelText)
        
        existingTextMutable.append(myMutableString)
        
        messageTipsLabel.attributedText = existingTextMutable
    }
}

// MARK: -  Observe Synthesizer Delegate Methods
extension MainViewController: ObserveSynthesizer {
    func synthesizerStarted() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .green
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
    }
    
    func synthesizerEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }

    func callEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }
    
    func callDialing() {
        print("call dialing")
    }
}
