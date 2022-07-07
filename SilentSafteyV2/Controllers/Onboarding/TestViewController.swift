//
//  TestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/7/22.
//

import UIKit

class TestViewController: UIViewController, UITextViewDelegate {
   
    var textView: UITextView!
    
    override func viewDidLoad() {
        
        let safeArea = view.safeAreaLayoutGuide
        //self.setupToHideKeyboardOnTapOnView()
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.delegate = self
        
        textView.tintColor = .white
        textView.backgroundColor = .darkGray
        textView.textColor = .white
        textView.layer.cornerRadius = 20
       // textView.font = UIFont.preferredFont(forTextStyle: .body)
     /*   textView.autocorrectionType = .no
        textView.text = "Type Additional Message Here"
        textView.textColor = .secondaryLabel */
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       
        let cons = textView.heightAnchor.constraint(equalToConstant: 50)
        cons.priority = UILayoutPriority(250)
        cons.isActive = true
        
        NSLayoutConstraint.activate([
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */
            
        ])
        
        let button = UIButton()
        
        let image = UIImage(systemName: "paperplane.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.setImage(image, for: .normal)
        button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
            button.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40)
            /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */

        ])
        
        
    }
    
    @objc func sendPressed() {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print(textView.frame.size.height)
            let height = textView.frame.size.height

            if height >= 100 {
                textView.isScrollEnabled = true
                textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            } else {
                textView.isScrollEnabled = false
                textView.heightAnchor.constraint(equalToConstant: 100).isActive = false
            }
        }
    
    

  /*  func textViewDidChange(_ textView: UITextView) {
           let newSize = textView.sizeThatFits(CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude))

           let newHeight = min(100, newSize.height)

           textView.frame.size = CGSize(width: 0, height: newHeight)

        
            print(newHeight)
           if newHeight >= 100 {
               print("+ 100")
               textView.isScrollEnabled = true
               textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
           } else {
               print("- 100")
               textView.isScrollEnabled = false
               textView.heightAnchor.constraint(equalToConstant: 100).isActive = false
           }
       } */
}

/*
extension TestViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(TestViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
} */
   /* func textViewDidBeginEditing(_ textView: UITextView) {
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
    } */



/*
 let safeArea = view.safeAreaLayoutGuide
 
 let textView = UITextView()
 view.addSubview(textView)
 textView.translatesAutoresizingMaskIntoConstraints = false

 textView.backgroundColor = .white
 textView.autocorrectionType = .no
 textView.text = "Type Additional Message Here"
 textView.backgroundColor = .secondarySystemBackground
 textView.textColor = .secondaryLabel
 textView.font = UIFont.systemFont(ofSize: 20)
 textView.layer.cornerRadius = 20
 textView.isScrollEnabled = true
 
/* let constraint = textView.heightAnchor.constraint(equalToConstant: 75)
 constraint.priority = UILayoutPriority(250)
 constraint.isActive = true */
 
 
 NSLayoutConstraint.activate([
     textView.heightAnchor.constraint(equalToConstant: 100),
     textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
     /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     button.topAnchor.constraint(equalTo: view.topAnchor),
     button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */
     
 ])

 /*
 let button = UIButton(type: .custom)
 let image = UIImage(named: "SosButton")

 button.setImage(image, for: .normal)
 button.translatesAutoresizingMaskIntoConstraints = false
 textView.addSubview(button)
 
 NSLayoutConstraint.activate([
     button.heightAnchor.constraint(equalToConstant: 50),
     button.widthAnchor.constraint(equalToConstant: 50),
     button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
     button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    /* button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
     button.trailingAnchor.constraint(equalTo: view.trailingAnchor) */
     /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     button.topAnchor.constraint(equalTo: view.topAnchor),
     button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */
     
 ]) */
 /*
 let button = UIButton(type: .custom)
 let image = UIImage(named: "SosButton")

 button.setImage(image, for: .normal)

 button.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(button)
 
 NSLayoutConstraint.activate([
     button.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -80),
     button.heightAnchor.constraint(equalToConstant: view.frame.size.width - 2),
     button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 2)
     /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     button.topAnchor.constraint(equalTo: view.topAnchor),
     button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */
     
 ]) */
 
 let button = UIButton(type: .custom)
 let image = UIImage(named: "SosButton")

 button.setImage(image, for: .normal)

 button.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(button)
 
 NSLayoutConstraint.activate([
     button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
     button.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
     button.heightAnchor.constraint(equalToConstant: view.frame.size.width - 2),
     button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 2)
     /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     button.topAnchor.constraint(equalTo: view.topAnchor),
     button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */
     
 ])
 
 let labelsTwo = [
     ReusableUIElements.createLabel(fontSize: 31, text: "Step 3: Let's try it out"),
     ReusableUIElements.createLabel(fontSize: 20, text: "Enter a phone number you can test the app with")
 ]

 let stackViewTwo = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 20, distributionType: .fillEqually)
 view.addSubview(stackViewTwo)
 
 NSLayoutConstraint.activate([
     stackViewTwo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
     stackViewTwo.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
     stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
     stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
     stackViewTwo.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50)
 ])
 
 /*
 let tutorialButton = UIButton(type: .custom)
 view.addSubview(tutorialButton)
 
 tutorialButton.translatesAutoresizingMaskIntoConstraints = false
 tutorialButton.setTitle("Settings", for: .normal)
 tutorialButton.setTitleColor(.systemBlue, for: .normal)
 
 NSLayoutConstraint.activate([
    
     tutorialButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
     tutorialButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
     
 ]) */
 
/* let label = UILabel()
 view.addSubview(label)
 label.translatesAutoresizingMaskIntoConstraints = false
 
 label.text = "The Bot is Currently Speaking"
 label.font = label.font.withSize(30)
 label.textColor = .white
 label.textAlignment = .center
 
 NSLayoutConstraint.activate([
     label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -40),
     label.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
     label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
 ]) */
 
}

/* func textViewDidBeginEditing(_ textView: UITextView) {
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
} */
*/
