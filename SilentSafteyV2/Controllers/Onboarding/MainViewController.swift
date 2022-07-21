//
//  MainViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import UIKit
import IQKeyboardManagerSwift

class MainViewController: UIViewController {
    

    var textView: UITextView!
    var stepOneLabel: UILabel!
    var accessLocationLabel: UILabel!
    var location: Location!
    var messageTipsLabelText: NSMutableAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main view did load")
        self.setupToHideKeyboardOnTapOnView()
        createUI()
      //  textView.returnKeyType = .send
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        
       // navigationController?.navigationBar.tintColor = .brown
      /*  self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Title", style: .plain, target: self, action: nil) */
      /*  print(navigationController?.navigationBar.tintColor)
        navigationController?.navigationBar.tintColor = .green
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: nil, action: nil) */ 
        
    }
    
    @objc func settingsButtonPressed() {
        print("settings button pressed")
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func createUI() {
        
        view.backgroundColor = .black
        // view.safeAreaLayoutGuide.owningView?.backgroundColor = .red
        let safeArea = view.safeAreaLayoutGuide
        
        // Create Text View
        textView = ReusableUIElements.createTextView()
        textView.delegate = self
        view.addSubview(textView)
        ReusableUIElements.textViewConstraints(textView: textView, safeArea: safeArea)
        textView.autocorrectionType = .yes
        
        // Create Send Button
        let button = ReusableUIElements.createSendButton(textView: textView)
        view.addSubview(button)
        button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
        
        ReusableUIElements.sendButtonConstraints(button: button, view: self.view, safeArea: safeArea, textView: textView)
      
        // Create SOS Button
        let sosButton = ReusableUIElements.createSosButton()
        sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        view.addSubview(sosButton)
        
        NSLayoutConstraint.activate([
            sosButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 50),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        let uiView = UIView()
        view.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: sosButton.bottomAnchor),
            uiView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
    
        let myMutableString = NSMutableAttributedString(string: "Message Tips", attributes: [NSAttributedString.Key.font : UIFont(name: "Georgia", size: 25)!])
        
        myMutableString.append(NSMutableAttributedString(string: "\n 1. Describe the Situation \n 2. Describe identifier - Tatoos, Scars, Clothes \n 3. Enter Specific Loction (Apartment number etc.)"))
        
        let oneLabel = UILabel()
        oneLabel.translatesAutoresizingMaskIntoConstraints = false
        oneLabel.numberOfLines = 0
        oneLabel.textColor = .white
        oneLabel.textAlignment = .center
        oneLabel.attributedText = myMutableString
      //  oneLabel.font = oneLabel.font.withSize(CGFloat(15.0))
        oneLabel.adjustsFontSizeToFitWidth = true
        oneLabel.minimumScaleFactor = 0.2
        
        uiView.addSubview(oneLabel)
        
        messageTipsLabelText = myMutableString
        
        NSLayoutConstraint.activate([
            oneLabel.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            oneLabel.topAnchor.constraint(equalTo: uiView.topAnchor),
            oneLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            oneLabel.leadingAnchor.constraint(equalTo: uiView.leadingAnchor)
        ])
        
        accessLocationLabel = oneLabel
        
        AppDelegate.location.checkRequestPermission()
        AppDelegate.location.delegate = self
        AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
    }

    @objc func sendPressed() {
        if let message = textView.text {
            NotificationCenter.default.post(name: .additionalMessage, object: nil, userInfo: ["additionalMessage": message])
            textView.text = ""
        }
        
    }
    @objc func sosButtonPressed() {
        print("sos button rpessed")
        if(Response.sosButtonResponse == false && Response.widgetResponse == false) {
            AppDelegate.location.checkRequestPermission()
            
            if(AppDelegate.location.retrieveLocationAuthorizaiton() == .notDetermined) {
                print("Not determined in scene continue user activity")
                
                NotificationCenter.default.addObserver(self, selector: #selector(tempFuncMain(notification:)), name: .locationAuthorizationGiven, object: nil)
            }
            else {
                Response.stringTapped = "sosButton"
                AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: "4693555568")
            }
        }
        else {
            print("not executed sos button")
        }
    }
    
    @objc func tempFuncMain(notification: NSNotification) {
        Response.stringTapped = "sosButton"
        AppDelegate.phoneCall.initiatePhoneCall(phoneNumber: "4693555568")
        NotificationCenter.default.removeObserver(self)
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
      
        print(newHeight)
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
                   // constraint.priority = UILayoutPriority(250)
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

extension MainViewController {
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        print("restore user activity")
    }
}

extension MainViewController: LocationProtocol {
    func updateLocationLabel(text: String) {
        print(text)
        let newLineText = "\n" + text
        
        let myMutableString = NSMutableAttributedString(string: newLineText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])

        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Georgia", size: 25), range: NSRange(location: 0, length: newLineText.count))
        
        let existingTextMutable = NSMutableAttributedString(attributedString: messageTipsLabelText)
        
        existingTextMutable.append(myMutableString)
        
        accessLocationLabel.attributedText = existingTextMutable
    }
}


/*
 view.backgroundColor = .black
 
 let safeArea = view.safeAreaLayoutGuide
 
 // Bottom View
 let bottomView = UIView()
 bottomView.translatesAutoresizingMaskIntoConstraints = false
 bottomView.backgroundColor = .blue
 
 // Middle View
 let directionsLabel = ReusableUIElements.createLabel(fontSize: 23, text: "Message Tips")
 directionsLabel.font = UIFont.boldSystemFont(ofSize: 23)
 
 let locationLabel = ReusableUIElements.createLabel(fontSize: 23, text: "")
 locationLabel.textColor = .red
 
 let labels = [
     directionsLabel,
     ReusableUIElements.createLabel(fontSize: 17, text: "1. Describe the Situation"),
     ReusableUIElements.createLabel(fontSize: 17, text: "2. Describe identifier - Tatoos, Scars, Clothes"),
     locationLabel
 ]
 
 let middleView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 1, distributionType: .equalSpacing)
 middleView.backgroundColor = .red
 
 // Top View
 let topView = UIView()
 topView.translatesAutoresizingMaskIntoConstraints = false
 topView.backgroundColor = .orange
 
 let sosButton = ReusableUIElements.createSosButton()
 sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
 topView.addSubview(sosButton)


 // Super Stack View
 let superStackView = ReusableUIElements.createStackView(stackViewElements: [topView, middleView, bottomView], spacing: 0, distributionType: .equalCentering)
 view.addSubview(superStackView)
 
 NSLayoutConstraint.activate([
      superStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      superStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      superStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      superStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
  ])
 
  // Text View Creation
 textView = ReusableUIElements.createTextView()
 textView.delegate = self
 bottomView.addSubview(textView)
 
 // Send Button Creation
 let button = ReusableUIElements.createSendButton(textView: textView)
 bottomView.addSubview(button)
 button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)

 // Text View Constraints
 let cons = textView.heightAnchor.constraint(equalToConstant: 40)
 cons.identifier = "heightConstraint"
 cons.priority = UILayoutPriority(250)
 cons.isActive = true
 
 NSLayoutConstraint.activate([
     textView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
     textView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
     textView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.85)
 ])
 
 // Send Button Constraints
 NSLayoutConstraint.activate([
     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(safeArea.layoutFrame.width * 0.04)),
     button.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
 ])
 
 // Sos Button Constraints
 NSLayoutConstraint.activate([
     sosButton.topAnchor.constraint(equalTo: topView.topAnchor),
     sosButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 2),
     sosButton.heightAnchor.constraint(equalToConstant: view.frame.size.width - 2),
     sosButton.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
 ])
 */
