//
//  MainViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import UIKit
import IQKeyboardManagerSwift

class MainViewController: UIViewController {
    
    let textView: UITextView = {
        
        let textView = ReusableUIElements.createTextView()
        textView.autocorrectionType = .yes
        return textView
        
    }()

    let directionsLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.translatesAutoresizingMaskIntoConstraints = false
        oneLabel.numberOfLines = 0
        oneLabel.textColor = .white
        oneLabel.textAlignment = .center
        
        return oneLabel
    }()
    
    let messageTipsLabelText: NSMutableAttributedString = {
        let myMutableString = NSMutableAttributedString(string: "Message Tips", attributes: [NSAttributedString.Key.font : UIFont(name: "Georgia", size: 25)!])
        
        myMutableString.append(NSMutableAttributedString(string: "\n 1. Describe the Situation \n 2. Describe identifier - Tatoos, Scars, Clothes \n 3. Enter Specific Loction (Apartment number etc.)"))
        
        return myMutableString
    }()
    
    var textFieldEssential: TextFieldEssential!
    let viewMessageVC = ViewMessageViewController() // Check This
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        createUI()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(pencilPressed))
        
        AppDelegate.location.checkRequestPermission()
        AppDelegate.location.delegate = self
        AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
        
        AppDelegate.phoneCall.observeSynthesizerDelegate = viewMessageVC
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
      
        // SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)
        
        NSLayoutConstraint.activate([
            sosButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
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
        directionsLabel.attributedText = messageTipsLabelText
      //  directionsLabel.font = oneLabel.font.withSize(CGFloat(15.0))
        directionsLabel.adjustsFontSizeToFitWidth = true
        directionsLabel.minimumScaleFactor = 0.2
        uiView.addSubview(directionsLabel)
        
        NSLayoutConstraint.activate([
            directionsLabel.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            directionsLabel.topAnchor.constraint(equalTo: uiView.topAnchor),
            directionsLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            directionsLabel.leadingAnchor.constraint(equalTo: uiView.leadingAnchor)
        ])
    }
    
    @objc func settingsButtonPressed() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc func sendPressed() {
        if let message = textView.text {
            
            let trimmedString = message.trimmingCharacters(in: .whitespaces)
            
            if(trimmedString == "Type Additional Message Here" || trimmedString == "") {
                return
            }
            
            NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": trimmedString])
            
            textView.text = ""
        }
    }
    
    @objc func sosButtonPressed() {
        AppDelegate.response.completeResponse()
    }
    
    @objc func pencilPressed() {
        self.navigationController?.pushViewController(viewMessageVC, animated: true)
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

extension MainViewController: LocationProtocol {
    func updateLocationLabel(text: String) {
        print(text)
        
        let newLineText = "\n" + text

        let myMutableString = NSMutableAttributedString(string: newLineText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])

        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Georgia", size: 25)!, range: NSRange(location: 0, length: newLineText.count))
        
        let existingTextMutable = NSMutableAttributedString(attributedString: messageTipsLabelText)
        
        existingTextMutable.append(myMutableString)
        
        directionsLabel.attributedText = existingTextMutable
    }
}
