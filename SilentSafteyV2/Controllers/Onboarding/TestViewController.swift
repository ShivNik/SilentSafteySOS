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
        let stepOneLabel = ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "1. Tap the SOS Button, Start the Call, and Return back to the app")
        stepOneLabel.numberOfLines = 0
        return stepOneLabel
    }()
    
    let middleUILabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "")
    }()
    
    let middleUIView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let buttonStackView: UIStackView = {
        
        let continueButton = ReusableUIElements.createButton(title: "Continue")
        let restartTutorial = ReusableUIElements.createButton(title: "Restart Tutorial")
        
        let buttonStackView = ReusableUIElements.createStackView(stackViewElements: [restartTutorial,continueButton], spacing: 40, distributionType: .fillEqually)
        
        buttonStackView.axis = .horizontal
        
        return buttonStackView
    }()
    
    var middleUILabelConstraints: [NSLayoutConstraint] = []
    var middleStackViewConstraints: [NSLayoutConstraint] = []

    var testPhoneNumber: String = ""
    var textFieldEssential: TextFieldEssential!
    
    var mainButtonPressed = false
    var sendButtonPressed = false
    var hangupButtonPressed = false
    var phoneCallEnded = false
    var greenTextShown = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        for element in buttonStackView.arrangedSubviews {
            let button = element as! UIButton
            
            if(button.titleLabel?.text == "Continue") {
                button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(restartTutorialPressed), for: .touchUpInside)
            }
        }
        middleUILabelConstraints = [
            middleUILabel.topAnchor.constraint(equalTo: middleUIView.topAnchor),
            middleUILabel.bottomAnchor.constraint(equalTo: middleUIView.bottomAnchor),
            middleUILabel.leadingAnchor.constraint(equalTo: middleUIView.leadingAnchor),
            middleUILabel.trailingAnchor.constraint(equalTo: middleUIView.trailingAnchor)
        ]
        
        middleStackViewConstraints = [
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            buttonStackView.widthAnchor.constraint(equalToConstant: 350),
            
            buttonStackView.centerXAnchor.constraint(equalTo: middleUIView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: middleUIView.centerYAnchor)
        ]
        
        
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
     /*   let safeArea = view.safeAreaLayoutGuide
        
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .red
        
        view.addSubview(uiview)
        
        NSLayoutConstraint.activate([
            uiview.topAnchor.constraint(equalTo: safeArea.topAnchor),
            uiview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiview.removeFromSuperview()
            
            let button = UIButton()

            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .systemRed
            button.setTitle("Totle ", for: .normal)
            button.layer.cornerRadius = 10
            self.view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: safeArea.topAnchor),
                button.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            ])
        } */
        
        createUI()
        
     /*   DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("first 5 seconds")
            self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("second 5 ")
                self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    print("trhid 5 seconds")
                    self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        print("fourth 5 ")
                        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
                        
                    }
                }
            }
        } */
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
        view.addSubview(directionsLabel)
        NSLayoutConstraint.activate([
            directionsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            directionsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            directionsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            directionsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // Create and Constrain SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)

        NSLayoutConstraint.activate([
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 70),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 70),
            sosButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 16),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Hang up Button
        let hangUpButton = ReusableUIElements.createButton(title: "  Hang Up Message  ")
        hangUpButton.addTarget(self, action: #selector(hangUpButtonPressed), for: .touchUpInside)
        hangUpButton.sizeToFit()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hangUpButton)
      //  self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        self.navigationItem.leftItemsSupplementBackButton = true
        
        // Middle UI View
        view.addSubview(middleUIView)
        
        NSLayoutConstraint.activate([
            middleUIView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            middleUIView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            middleUIView.topAnchor.constraint(equalTo: sosButton.bottomAnchor),
            middleUIView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
        
        // Middle Label
        middleUIView.addSubview(middleUILabel)
        NSLayoutConstraint.activate(middleUILabelConstraints)
    }
    
    @objc func sosButtonPressed() {
        AppDelegate.response.completeResponse()
      /*  if(self.navigationItem.leftBarButtonItem?.customView?.isHidden == false) {
            self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        } else {
            self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        } */
        
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
                    
                    sendButtonPressed = true
                    directionsLabel.text = "3. Press the Hang Up Button to Notify the police that there are no more Messages"
                }
            }
            
            textView.text = ""
        }
    }

    @objc func hangUpButtonPressed() {
        if(mainButtonPressed && sendButtonPressed && !hangupButtonPressed) {
            
            if(Response.responseActive) {
                NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": "No Other Information - Please Hang Up"])
                
                hangupButtonPressed = true
                
                directionsLabel.text = "4. Once you hear the message, hang up the call from the other phone to finish the tutorial"
                
                middleUILabel.font = middleUILabel.font.withSize(CGFloat(ReusableUIElements.descriptionFontSize))
                
                middleUILabel.text = "In a Real Situation, if you don't edit the message bar 30 seconds after the call connected, the hang up message will be sent automatically"
            }
        }
    }
}

// MARK: -  Observe Synthesizer Delegate
extension TestViewController: ObserveSynthesizer {
    func synthesizerStarted() {
        if(!greenTextShown) {
            middleUILabel.text = "The green background indicates that the bot is speaking"
            greenTextShown = true
        }
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .green
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
    }
    
    func synthesizerEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        print("sythesizer ended")
    }
    
    func callStarted() {
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        print("Call started \(self.navigationItem.leftBarButtonItem?.customView)")
        mainButtonPressed = true
        directionsLabel.text = "2. Type an Additional Message and Tap the Send Button"
    }
    
    func callEnded() {
        self.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        print("Call ended \(self.navigationItem.leftBarButtonItem?.customView)")
        middleUILabel.text = ""
        
        if(mainButtonPressed && sendButtonPressed && hangupButtonPressed) {
            
            directionsLabel.text = "Test Run Finished"
            deactivateLabel()
            self.navigationController?.pushViewController(CompletionViewController(), animated: true)
            
        } else {
            directionsLabel.text = "Don't End the Call Until All Messages have been said - Restarting Tutorial"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.restartTutorial()
            }
        }
    }
    
    @objc func continueButtonPressed() {
        self.navigationController?.pushViewController(CompletionViewController(), animated: true)
    }
    
    @objc func restartTutorialPressed() {
        restartTutorial()
        deactivateStackView()
    }
    
    func restartTutorial() {
        directionsLabel.text = "1. Tap the SOS Button, Start the Call, and Return back to the App"
        
        middleUILabel.text = ""
        middleUILabel.font = middleUILabel.font.withSize(CGFloat(ReusableUIElements.titleFontSize))
       
        mainButtonPressed = false
        sendButtonPressed = false
        hangupButtonPressed = false
        phoneCallEnded = false
        greenTextShown = false
    }
    
    func deactivateLabel() {
        middleUILabel.removeFromSuperview()
        
        middleUIView.addSubview(buttonStackView)
        NSLayoutConstraint.activate(middleStackViewConstraints)
    }
    
    func deactivateStackView() {
        buttonStackView.removeFromSuperview()
        middleUIView.addSubview(middleUILabel)
        NSLayoutConstraint.activate(middleUILabelConstraints)
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
