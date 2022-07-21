//
//  TestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/7/22.
//

import UIKit

class TestViewController: UIViewController {
    var textView: UITextView!
    var stepOneLabel: UILabel!
    var testPhoneNumber: String = ""
    var mainButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
        createUI()
    }
    
    func createUI() {
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
        
        // Create and Constrain Text View
        textView = ReusableUIElements.createTextView()
        textView.delegate = self
        view.addSubview(textView)
        ReusableUIElements.textViewConstraints(textView: textView, safeArea: safeArea)

        // Create and Constrain SOS Button
        let button = ReusableUIElements.createSendButton(textView: textView)
        view.addSubview(button)
        button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
        
        ReusableUIElements.sendButtonConstraints(button: button, view: self.view, safeArea: safeArea, textView: textView)
         
        // Create and Constrain Directions Title Label
        stepOneLabel = ReusableUIElements.createLabel(fontSize: 25, text: "1. Tap the SOS Button and Start the Call")
        stepOneLabel.numberOfLines = 0
        view.addSubview(stepOneLabel)
        
        NSLayoutConstraint.activate([
            stepOneLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stepOneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stepOneLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            stepOneLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // Create and Constrain SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)

        NSLayoutConstraint.activate([
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.topAnchor.constraint(equalTo: stepOneLabel.bottomAnchor, constant: 16),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
      
    }
    
    @objc func sendPressed() {
        
        if let message = textView.text {
            NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": message])
            textView.text = ""
        }
        
        if(mainButtonPressed) {
            self.navigationController?.pushViewController(CompletionViewController(), animated: true)
        }
    }
    
    @objc func sosButtonPressed() {
        mainButtonPressed = true
        stepOneLabel.text = "2. Type an Additional Message and Tap the Send Button"
        
        if(Response.sosButtonResponse == false && Response.widgetResponse == false) {
            AppDelegate.location.checkRequestPermission()
            
            if(AppDelegate.location.retrieveLocationAuthorizaiton() == .notDetermined) {
                print("Not determined in scene continue user activity")
                
                NotificationCenter.default.addObserver(self, selector: #selector(tempFuncMain(notification:)), name: .locationAuthorizationGiven, object: nil)
            }
            else {
                Response.stringTapped = "sosButton"
                AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: testPhoneNumber)
            }
        }
        else {
            print("not executed sos button")
        }
    }
    
    @objc func tempFuncMain(notification: NSNotification) {
        Response.stringTapped = "sosButton"
        AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: testPhoneNumber)
        NotificationCenter.default.removeObserver(self)
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

// MARK: -  Press Outside -> Drop Keyboard Methods
extension TestViewController {
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
