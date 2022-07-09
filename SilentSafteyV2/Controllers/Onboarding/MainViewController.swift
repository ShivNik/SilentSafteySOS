//
//  MainViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import UIKit

class MainViewController: UIViewController {

    var textView: UITextView!
    var stepOneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        createUI()
        textView.returnKeyType = .send
    }
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        // Create Text View
        textView = ReusableUIElements.createTextView()
        textView.delegate = self
        view.addSubview(textView)
        ReusableUIElements.textViewConstraints(textView: textView, safeArea: safeArea)

        // Create SOS Button
        let button = ReusableUIElements.createSendButton(textView: textView)
        view.addSubview(button)
        button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
        
        ReusableUIElements.sendButtonConstraints(button: button, view: self.view, safeArea: safeArea, textView: textView)
         
        // Create Directions Title Label
        stepOneLabel = ReusableUIElements.createLabel(fontSize: 25, text: "1. Tap the SOS Button and Start the Call \n")
        stepOneLabel.numberOfLines = 2
        stepOneLabel.lineBreakMode = .byWordWrapping
        view.addSubview(stepOneLabel)
        
        NSLayoutConstraint.activate([
            stepOneLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stepOneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stepOneLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            stepOneLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // Create UIView for Button
        let uiView = UIView()
        view.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: stepOneLabel.bottomAnchor),
            uiView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
        
        // Create SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        uiView.addSubview(sosButton)
        uiView.layoutIfNeeded()

        NSLayoutConstraint.activate([
            sosButton.heightAnchor.constraint(equalToConstant: uiView.frame.size.width - 2),
            sosButton.widthAnchor.constraint(equalToConstant: uiView.frame.size.width - 2),
            sosButton.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            sosButton.centerXAnchor.constraint(equalTo: uiView.centerXAnchor)
        ])
      
    }
    
    @objc func sendPressed() {
        self.navigationController?.pushViewController(CompletionViewController(), animated: true)
    }
    @objc func sosButtonPressed() {
        print("zab")
        stepOneLabel.text = "2. Type an Additional Message and Tap the Send Button"
    }
}

// MARK: -  Text View Delegate Methods
extension MainViewController: UITextViewDelegate {
    
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

extension MainViewController {
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
