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

    let directionsLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.translatesAutoresizingMaskIntoConstraints = false
        oneLabel.numberOfLines = 0
        oneLabel.textColor = .white
        oneLabel.textAlignment = .center
        
        return oneLabel
    }()
    
    let messageTipsLabelText: NSMutableAttributedString = {
        
        let myMutableString = NSMutableAttributedString(string: "Message Tips", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(ReusableUIElements.titleFontSize))])
        
        myMutableString.append(NSMutableAttributedString(string: "\n 1. Describe the Situation \n 2. Enter Specific Loction (Apartment/Building number etc.)")) // Describe identifier - Tatoos, Scars, Clothes \n 3.
        
        return myMutableString
    }()
    
    var hangUpButton: UIButton = {
        return ReusableUIElements.createButton(title: "  Hang Up Message  ")
    }()
    
    var textFieldEssential: TextFieldEssential!
    
    var hangUpPressed: Bool = false
    var textViewDidEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEssential = TextFieldEssential(vcView: view)
        textFieldEssential.setupToHideKeyboardOnTapOnView()
        
        createUI()
    
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
        directionsLabel.attributedText = messageTipsLabelText
        directionsLabel.font = directionsLabel.font.withSize(CGFloat(ReusableUIElements.descriptionFontSize))
        directionsLabel.adjustsFontSizeToFitWidth = true
        directionsLabel.minimumScaleFactor = 0.2
        uiView.addSubview(directionsLabel)
        
        NSLayoutConstraint.activate([
            directionsLabel.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            directionsLabel.topAnchor.constraint(equalTo: uiView.topAnchor),
            directionsLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            directionsLabel.leadingAnchor.constraint(equalTo: uiView.leadingAnchor)
        ])
        
        // Navigation Bar Buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        
        hangUpButton.addTarget(self, action: #selector(hangUpButtonPressed), for: .touchUpInside)
        hangUpButton.sizeToFit()
        self.navigationItem.leftItemsSupplementBackButton = true
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
            
            NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": trimmedString])
            
            textView.text = "Type Additional Message Here" // Type additional message here
        }
    }
    
    @objc func hangUpButtonPressed() {
        if(!hangUpPressed) {
            if(Response.responseActive) {
                NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": "The rest of this call will be repeating messages that have already been spoken, please hang up if all information is understood"])
            }
            hangUpPressed = true
        }
    }
    
    @objc func settingsButtonPressed() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}

// MARK: -  Text View Extension
extension MainViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did begin editing")
        if textView.text == "Type Additional Message Here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end editing")
        if textView.text.isEmpty {
            textView.text = "Type Additional Message Here"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let text = textView.text {
            let trimmedString = text.trimmingCharacters(in: .whitespaces)
            
            if(trimmedString != "") {
                textViewDidEdit = true
            }
        }
    
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

// MARK: -  Location Extension
extension MainViewController: LocationProtocol {
    func updateLocationLabel(text: String) {
        let newLineText = "\n" + text

        let myMutableString = NSMutableAttributedString(string: newLineText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(ReusableUIElements.titleFontSize))])
        
        let existingTextMutable = NSMutableAttributedString(attributedString: messageTipsLabelText)
        
        existingTextMutable.append(myMutableString)
        
        directionsLabel.attributedText = existingTextMutable
    }
}

// MARK: -  Phone Extension
extension MainViewController: ObserveSynthesizer {
    func synthesizerStarted() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .green
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
    }
    
    func synthesizerEnded() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }
    
    func callStarted() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hangUpButton)
        textViewDidEdit = false
        hangUpPressed = false
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [self] in
            if(!textViewDidEdit) {
                hangUpButtonPressed()
            }
        }
    
    }
    func callEnded() {
        self.navigationItem.leftBarButtonItem = nil
        textViewDidEdit = false
        hangUpPressed = false
        
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
    }
    
    func callDialing() { // Figre out what to do here
        print("call dialing")
    }
}
