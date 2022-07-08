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
        super.viewDidLoad()
        
        let safeArea = view.safeAreaLayoutGuide
        // self.automaticallyAdjustsScrollViewInsets = false
        textView = UITextView()
        textView.delegate = self
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.backgroundColor = .white
        textView.autocorrectionType = .no
        textView.text = "Type Additional Message Here"
        textView.backgroundColor = .secondarySystemBackground
        textView.textColor = .red
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
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    
        ])

    /*    let button = UIButton(type: .custom)
        let image = UIImage(named: "SosButton")
    
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sosButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -80),
            button.heightAnchor.constraint(equalToConstant: view.frame.size.width - 2),
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 2)
           
        ]) */
    
      /*  let tutorialButton = UIButton(type: .custom)
        view.addSubview(tutorialButton)
        
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.setTitle("Settings", for: .normal)
        tutorialButton.setTitleColor(.systemBlue, for: .normal)
        
        NSLayoutConstraint.activate([
           
            tutorialButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tutorialButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            
        ]) */
    }
    
    func changeConstraint() {
        let cons = textView.heightAnchor.constraint(equalToConstant: 40)
        cons.isActive = true
    }
    @objc func sosButtonPressed() {
        print("zab")
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


/*
 print(textView.isScrollEnabled)
 let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
 
 let newHeight = newSize.height
 
 if newHeight >= 100 {
     if(!textView.isScrollEnabled) {
         textView.isScrollEnabled = true
         let consTwo = textView.heightAnchor.constraint(equalToConstant: newHeight)
         consTwo.identifier = "heightTwo"
         consTwo.isActive = true
     }
 } else {
     if(textView.isScrollEnabled) {
         for constraint in textView.constraints {
             if(constraint.identifier == "heightTwo") {
                 constraint.isActive = false
             }
             else if(constraint.identifier == "heightConstraint") {
                 print("here")
                 constraint.constant = newHeight
                 constraint.priority = UILayoutPriority(1000)
             }
         }
     }
     textView.isScrollEnabled = false
     textView.heightAnchor.constraint(equalToConstant: newHeight).isActive = false
 }
 */






/*
 // let newHeight = 200
  if newHeight >= 100 {
      textView.isScrollEnabled = true
      textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
  } else {
      textView.isScrollEnabled = false
      textView.heightAnchor.constraint(equalToConstant: 100).isActive = false
  }
 */


/*
 /*  let button = UIButton()
   
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

   ]) */
   
 */



/*
 let sendButton = UIButton()
 let sendImage = UIImage(systemName: "paperplane.fill")
   
 sendButton.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(sendButton)
   sendButton.setImage(sendImage, for: .normal)
   sendButton.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
 
 
 NSLayoutConstraint.activate([
   sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
   sendButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
   sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
   sendButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40)
     /* button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     button.topAnchor.constraint(equalTo: view.topAnchor),
     button.bottomAnchor.constraint(equalTo: view.bottomAnchor) */

 ])
 */
