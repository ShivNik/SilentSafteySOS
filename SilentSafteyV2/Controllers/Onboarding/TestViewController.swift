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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupToHideKeyboardOnTapOnView()
        createUI()
        textView.returnKeyType = .send
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func createUI() {
        view.backgroundColor = .black
        
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


/*

 class TestViewController: UIViewController, UITextViewDelegate {
     var textView: UITextView!
     var stepOneLabel: UILabel!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         self.setupToHideKeyboardOnTapOnView()
         
         self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = .black
         
         let safeArea = view.safeAreaLayoutGuide
         // self.automaticallyAdjustsScrollViewInsets = false
         textView = UITextView()
         textView.delegate = self
         view.addSubview(textView)
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.contentInsetAdjustmentBehavior = .never
         textView.backgroundColor = .darkGray
         textView.autocorrectionType = .no
         textView.text = "Type Additional Message Here"
             // textView.backgroundColor = .secondarySystemBackground
         textView.textColor = .white
         textView.font = UIFont.preferredFont(forTextStyle: .body)
         textView.layer.cornerRadius = 20
         textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
         textView.isScrollEnabled = false
         let cons = textView.heightAnchor.constraint(equalToConstant: 40)
         cons.identifier = "heightConstraint"
         cons.priority = UILayoutPriority(250)
         cons.isActive = true
         
         NSLayoutConstraint.activate([
           //  textView.heightAnchor.constraint(equalToConstant: 50),
            // textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
             textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
             textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
             textView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.85)
     
         ])
     
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(button)
         
         let largeConfig = UIImage.SymbolConfiguration(pointSize: textView.frame.size.height, weight: .bold, scale: .large)
         let largeBoldDoc = UIImage(systemName: "paperplane.fill", withConfiguration: largeConfig)
        
         button.setImage(largeBoldDoc, for: .normal)
         button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
         
         NSLayoutConstraint.activate([
             button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(safeArea.layoutFrame.width * 0.04)),
             button.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
         ])
          
        /* stepTwoLabel = ReusableUIElements.createLabel(fontSize: 25, text: "2. Type an Additional Message")
         view.addSubview(stepTwoLabel)
         NSLayoutConstraint.activate([
             stepTwoLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
             stepTwoLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -40),
             stepTwoLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
             stepTwoLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
         ])
         stepTwoLabel.isHidden = true */
     
         stepOneLabel = ReusableUIElements.createLabel(fontSize: 25, text: "1. Tap the SOS Button and begin the call duiqhwidhw hqwiuhfq uqwhif")
         view.addSubview(stepOneLabel)
         NSLayoutConstraint.activate([
             stepOneLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
             stepOneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
             stepOneLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
             stepOneLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            // stepOneLabel.bottomAnchor.constraint(equalTo: sosButton.topAnchor)
         ])
         
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
         
         let sosButton = UIButton(type: .custom)
         let sosImage = UIImage(named: "SosButton")
     
         sosButton.setImage(sosImage, for: .normal)
         sosButton.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
         sosButton.translatesAutoresizingMaskIntoConstraints = false
         uiView.addSubview(sosButton)
         uiView.layoutIfNeeded()
         
         print(uiView.frame.size.width)
         print(uiView.bounds)
         NSLayoutConstraint.activate([
             sosButton.heightAnchor.constraint(equalToConstant: uiView.frame.size.width - 2),
             sosButton.widthAnchor.constraint(equalToConstant: uiView.frame.size.width - 2),
             sosButton.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
             sosButton.centerXAnchor.constraint(equalTo: uiView.centerXAnchor)
            // sosButton.topAnchor.constraint(equalTo: stepOneLabel.bottomAnchor, constant: 40),
           //  sosButton.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -60)
           /*  sosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             sosButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40) */
         ])
       
     }
     
     @objc func sendPressed() {
         self.navigationController?.pushViewController(CompletionViewController(), animated: true)
     }
     func changeConstraint() {
         let cons = textView.heightAnchor.constraint(equalToConstant: 40)
         cons.isActive = true
     }
     @objc func sosButtonPressed() {
         print("zab")
         stepOneLabel.text = "2. Type and Additional Message"
     }
     
     
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.text == "Type Additional Message Here" {
             textView.text = nil
             textView.textColor = UIColor.black
         }
     }
     func textViewDidEndEditing(_ textView: UITextView) {
         if textView.text.isEmpty {
             textView.text = "Placeholder"
             textView.textColor = UIColor.lightGray
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

 extension TestViewController
 {
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

 */
