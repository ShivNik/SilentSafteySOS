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
    
    var stepOneLabel: UILabel = {
        let stepOneLabel = ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "1. Tap the SOS Button, Start the Call, and Return back to the App")
        stepOneLabel.numberOfLines = 0
        return stepOneLabel
    }()
    
    var greenBotLabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "")
    }()
    
    
    var testPhoneNumber: String = ""
    var textFieldEssential: TextFieldEssential!
    
    var mainButtonPressed = false
    var sendButtonPressed = false
    var hangupButtonPressed = false
    var phoneCallEnded = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        createUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate.phoneCall.observeSynthesizerDelegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppDelegate.phoneCall.observeSynthesizerDelegate = nil
    }
    
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
         
        // Title Label
        view.addSubview(stepOneLabel)
        NSLayoutConstraint.activate([
            stepOneLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stepOneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            stepOneLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            stepOneLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // Create and Constrain SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)

        NSLayoutConstraint.activate([
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 70),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 70),
            sosButton.topAnchor.constraint(equalTo: stepOneLabel.bottomAnchor, constant: 16),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Hang up Button
        let hangUpButton = ReusableUIElements.createButton(title: "  Hang Up Message  ")
        hangUpButton.addTarget(self, action: #selector(hangUpButtonPressed), for: .touchUpInside)
        hangUpButton.sizeToFit()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hangUpButton)
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        
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
        
        // Green Bot Label
        uiView.addSubview(greenBotLabel)
        
        NSLayoutConstraint.activate([
            greenBotLabel.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            greenBotLabel.centerYAnchor.constraint(equalTo: uiView.centerYAnchor)
        ])
    }
    
    @objc func sendPressed() {
        
        if(mainButtonPressed) {
            if let message = textView.text {
                
                let trimmedString = message.trimmingCharacters(in: .whitespaces)
                
                if(trimmedString == "Type Additional Message Here" || trimmedString == "") {
                    return
                }
                
                if(Response.responseActive) {
                    NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": trimmedString])
                }
                
                sendButtonPressed = true
                stepOneLabel.text = "3. Press the Hang Up Button to Notify the police that there are no more Messages"
            }
            
            textView.text = ""
        }
        print("send pressed")
        
        pushNextVC()
    }
    
    @objc func sosButtonPressed() {
        AppDelegate.response.completeResponse()
        pushNextVC()
    }
    
    @objc func hangUpButtonPressed() {
        if(mainButtonPressed && sendButtonPressed && !hangupButtonPressed) {
            
            if(Response.responseActive) {
                NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": "No Other Information - Please Hang Up"])
            }
            
            hangupButtonPressed = true
            
            stepOneLabel.text = "4. Once you hear the message, hang up the call from the other phone"
            
        }
        
        pushNextVC()
    }
    
    func pushNextVC() {
        if(phoneCallEnded) {
            self.navigationController?.pushViewController(CompletionViewController(), animated: true)
        }
    }
}

// MARK: -  Text View Delegate Methods
extension TestViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Additional Message Here" {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Additional Message Here"
            textView.textColor = UIColor.white
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

extension TestViewController: ObserveSynthesizer {
    func synthesizerStarted() {
        greenBotLabel.text = "Green means that the Bot is Talking"
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .green
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
        print("Synthesizer started")
    }
    
    func synthesizerEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        print("Synthesizer ended")
    }
    
    func callStarted() {
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        mainButtonPressed = true
        stepOneLabel.text = "2. Type an Additional Message and Tap the Send Button"
    }
    
    func callEnded() {
        greenBotLabel.text = ""
        
        if(mainButtonPressed && sendButtonPressed && hangupButtonPressed) {
            
            stepOneLabel.text = "Test Run Finished"
            phoneCallEnded = true
            pushNextVC()
            
        } else {
            stepOneLabel.text = "Don't End the Call Until All Messages have been said - Restarting Tutorial"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.restartTutorial()
            }
        }
    }
    
    func restartTutorial() {
        stepOneLabel.text = "1. Tap the SOS Button, Start the Call, and Return back to the App"
        mainButtonPressed = false
        sendButtonPressed = false
        hangupButtonPressed = false
        phoneCallEnded = false
    }
}
