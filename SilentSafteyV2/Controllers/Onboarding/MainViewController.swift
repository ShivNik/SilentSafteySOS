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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main view did load")
        self.setupToHideKeyboardOnTapOnView()
        createUI()
        textView.returnKeyType = .send
        
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
            sosButton.widthAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 10),
            sosButton.heightAnchor.constraint(equalToConstant: safeArea.layoutFrame.size.width - 10),
            sosButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        let uiView = UIView()
        view.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: sosButton.bottomAnchor),
            uiView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
        
        
        // Create Directions Title Label
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
        
        // Directions Labels stack view creation
        let stackView = ReusableUIElements.createStackView(stackViewElements: labels, spacing: 1, distributionType: .equalSpacing)
        self.view.addSubview(stackView)
        stackView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor)
        ])
        
        accessLocationLabel = locationLabel
        
        AppDelegate.location.checkRequestPermission()
        AppDelegate.location.delegate = self
       // AppDelegate.location.locationManagerDidChangeAuthorization(AppDelegate.location.locationManager)
       
       /* location = Location()
        location.delegate = self
        location.checkRequestPermission() */
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
                AppDelegate.phoneCall.initiatePhoneCall(number: 1231242)
                if(AppDelegate.location.checkAuthorization()) {
                    print("authorizaed")
                    AppDelegate.location.retrieveLocation()
                }
                else {
                    print("denied/restricted")
                }
            }
        }
        else {
            print("not executed sos button")
        }
    }
    @objc func tempFuncMain(notification: NSNotification) {
        AppDelegate.phoneCall.initiatePhoneCall(number: 1231242)
        
        if(AppDelegate.location.checkAuthorization()) {
            print("authorizaed")
            AppDelegate.location.retrieveLocation()
        }
        else {
            print("denied/restricted")
        }
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
        accessLocationLabel.text = text
    }
}
/*
class MainViewController: UIViewController, UITextViewDelegate
{
   
    var textView: UITextView!
    var btn: UIButton!
    var btnSend: UIButton!
    var keyboardHeight : CGFloat = 0
    var isKeyboardShown = false
    var textViewHeight : CGFloat = 0
    var textView_inset : CGFloat = 10
    var textView_insetBottom : CGFloat = 5
   
    let btnSendWidth : CGFloat = 50
    let btnSendHeight : CGFloat = 50

   
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        textViewHeight = 35

       
        textView = UITextView(frame: CGRect(x: textView_inset+self.view.safeAreaInsets.left,
                                            y: self.view!.bounds.height,
                                            width: self.view.frame.width-textView_inset*3-self.view.safeAreaInsets.left-self.view.safeAreaInsets.right-btnSendWidth,
                                            height: textViewHeight))
       
        textView.textAlignment = NSTextAlignment.justified
        textView.backgroundColor = UIColor.lightGray
     //   textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Use RGB colour
        textView.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
       
        // Update UITextView font size and colour
        textView.font = UIFont(name: "Verdana", size: 17)
        textView.textColor = UIColor.white

       
        // Make UITextView web links clickable
        textView.isSelectable = true
        textView.isEditable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.isScrollEnabled = false
       
       
        // Make UITextView corners rounded
        textView.layer.cornerRadius = 10
       
        // Enable auto-correction and Spellcheck
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        // myTextView.autocapitalizationType = UITextAutocapitalizationType.None
       
       
        self.view.addSubview(textView)
        textView.delegate = self
       
        registerForKeyboardNotifications()
       
       
        btn = UIButton()
        btn.setTitle("PRESS", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.frame = CGRect(x: 50, y: 150, width: 100, height: 50)
        btn.addTarget(self, action: #selector(self.showTextView(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
       
       
       
        btnSend = UIButton()
        btnSend.setTitle("SEND", for: .normal)
        btnSend.setTitleColor(.white, for: .normal)
        btnSend.backgroundColor = .red
        btnSend.frame = CGRect(x: self.view.frame.width-self.view.safeAreaInsets.right-btnSendWidth-textView_inset,
                               y: self.view!.bounds.height,
                               width: btnSendWidth,
                               height: btnSendHeight)
        btnSend.addTarget(self, action: #selector(self.sendMessage(sender:)), for: .touchUpInside)
        self.view.addSubview(btnSend)

    }

   
    override func viewWillLayoutSubviews()
    {
        var textView_y : CGFloat = 0
        var btnSend_y : CGFloat = 0
       
        // Required to ensure that the TextView's height is changed dynamically!
        if isKeyboardShown
        {
            textView_y = self.view!.bounds.height-keyboardHeight-textView.frame.height-textView_insetBottom
            btnSend_y = self.view!.bounds.height-keyboardHeight-btnSendHeight-textView_insetBottom
        }
        else
        {
            textView_y = self.view!.bounds.height
            btnSend_y = self.view!.bounds.height
        }
       
        textView.frame = CGRect(x: textView_inset+self.view.safeAreaInsets.left,
                                y: textView_y,
                                width: self.view.frame.width-textView_inset*3-self.view.safeAreaInsets.left-self.view.safeAreaInsets.right-btnSendWidth,
                                height: textViewHeight)
       
        btnSend.frame = CGRect(x: self.view.frame.width-self.view.safeAreaInsets.right-self.btnSendWidth-textView_inset,
                               y: btnSend_y,
                               width: btnSendWidth,
                               height: btnSendHeight)
    }
   
   
    @objc func showTextView(sender: UIButton!)
    {
        textView.becomeFirstResponder()
    }
   
   
    @objc func sendMessage(sender: UIButton!)
    {
        print("------SEND MESSAGE-------")
    }
   

    func textViewDidChange(_ textView: UITextView)
    {
        let fixedWidth = textView.frame.size.width
             
        // Changing height of the message UITextView
        var newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
       
       
        // Limit the height to 100
        if newSize.height > 100
        {
            newSize.height = 100
            textView.isScrollEnabled = true
        }
        else
        {
            textView.isScrollEnabled = false
        }
       
       
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
       
       
        textViewHeight = newFrame.height
       
        var newOrigin = textView.frame.origin
       
        newOrigin.y -= (newSize.height - newFrame.size.height)
          
        textView.frame = CGRect(origin: newOrigin, size: CGSize(width: newFrame.width, height: newFrame.height))
    }

      
    func registerForKeyboardNotifications()
    {
        let notificationCenter = NotificationCenter.default
          
        notificationCenter.addObserver( self,
                                        selector: #selector(MainViewController.keyboardWillShow(_:)),
                                        name: UIResponder.keyboardWillShowNotification,
                                        object: nil )
          
        notificationCenter.addObserver( self,
                                        selector: #selector(MainViewController.keyboardWillBeHidden(_:)),
                                        name: UIResponder.keyboardWillHideNotification,
                                        object: nil)
    }
      

    func unregisterForKeyboardNotifications()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(  self,
                                            name: UIResponder.keyboardWillShowNotification,
                                            object: nil)
          
        notificationCenter.removeObserver(  self,
                                            name: UIResponder.keyboardWillHideNotification,
                                            object: nil)
    }
      

    @objc func keyboardWillShow(_ notification: Notification)
    {
        isKeyboardShown = true
       
        // Reset the position of the textview to the bottom of the screen
        textView.frame = CGRect(x: textView_inset+self.view.safeAreaInsets.left,
                                y: self.view!.bounds.height,
                                width: self.view.frame.width-textView_inset*3-self.view.safeAreaInsets.left-self.view.safeAreaInsets.right-btnSendWidth,
                                height: textViewHeight)
       
        btnSend.frame = CGRect(x: self.view.frame.width-self.view.safeAreaInsets.right-btnSendWidth-textView_inset,
                               y: self.view!.bounds.height,
                               width: btnSendWidth,
                               height: btnSendHeight)
       
       
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            keyboardHeight = keyboardFrame.cgRectValue.height
           
            // Place the TextView above the keyboard
            self.textView.frame.origin.y -= (keyboardHeight+self.textView.frame.height+textView_insetBottom)
           
            // Determine a new TextView height dynamically
            let fixedWidth = textView.frame.size.width // Width never changes
            var newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT))) // Height is based on the number of characters
           
           
            // Limit the height to 100
            if newSize.height > 100
            {
                newSize.height = 100
                textView.isScrollEnabled = true
            }
            else
            {
                textView.isScrollEnabled = false
            }
           
           

            var newFrame = textView.frame // A new frame: Fixed width; Dynamically changed height
            newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
            textViewHeight = newFrame.height // Assign the height value to the object property
           
            textView.frame = CGRect(origin: textView.frame.origin, size: CGSize(width: newFrame.width, height: newFrame.height))
           
            self.textView.layoutIfNeeded()
           
           
            self.btnSend.frame.origin.y -= (keyboardHeight+self.btnSend.frame.height+textView_insetBottom)
            btnSend.frame = CGRect(origin: btnSend.frame.origin, size: CGSize(width: btnSendWidth, height: btnSendHeight))
        }
    }


    @objc func keyboardWillBeHidden(_ notification : NSNotification)
    {
        isKeyboardShown = false
       
        if let _: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
              
            //let newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
              
            keyboardHeight = 0

            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.textView.frame.origin.y = self.view!.bounds.height
                            self.textView.layoutIfNeeded()
                            self.btnSend.frame.origin.y = self.view!.bounds.height
                            },
                           completion: nil)
        }
          
    }


    func textViewDidBeginEditing(_ textView: UITextView)
    {
        textView.becomeFirstResponder()
       
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(tapDetected(_:)))
          
        if self.view != nil {self.view!.addGestureRecognizer(tapRecognizer)}
    }
      
      

    func textViewDidEndEditing(_ textView: UITextView)
    {
        // Make the active field nil to hide the keyboard
        //self.activeField = nil;
    }
      

    @objc func tapDetected(_ tapRecognizer: UITapGestureRecognizer)
    {
        textView?.resignFirstResponder()
        if self.view != nil {self.view!.removeGestureRecognizer(tapRecognizer)}
    }

} */



/*

 class MainViewController: UIViewController {

     var textView: UITextView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         view.backgroundColor = .black
         createUI()
         textView.returnKeyType = .send
         setupToHideKeyboardOnTapOnView()
     }
     
     func createUI() {
         let safeArea = view.safeAreaLayoutGuide
         
         // Create Text View
         textView = ReusableUIElements.createTextView()
         textView.delegate = self
         view.addSubview(textView)
         ReusableUIElements.textViewConstraints(textView: textView, safeArea: safeArea)

         // Create Send Button
         let button = ReusableUIElements.createSendButton(textView: textView)
         view.addSubview(button)
         button.addTarget(self, action:#selector(sendPressed), for: .touchUpInside)
         
         ReusableUIElements.sendButtonConstraints(button: button, view: self.view, safeArea: safeArea, textView: textView)
          
         // Create Stack View
         
         let tutorialButton = ReusableUIElements.createButton(title: "Tutorial")
         let informationButton = ReusableUIElements.createButton(title: "Profile")
         let stackViewElements = [tutorialButton,informationButton]
         
         let buttonStackView =  UIStackView(arrangedSubviews: stackViewElements)
         buttonStackView.translatesAutoresizingMaskIntoConstraints = false
         
         buttonStackView.axis = .horizontal
         buttonStackView.distribution = .fillEqually
         buttonStackView.alignment = .fill
         buttonStackView.spacing = CGFloat(50)
         buttonStackView.backgroundColor = .black
         view.addSubview(buttonStackView)
         
         NSLayoutConstraint.activate([
             buttonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
             buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
             buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
             buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
         ])
         
         // Create UIView for Button
         let uiView = UIView()
         view.addSubview(uiView)
         uiView.translatesAutoresizingMaskIntoConstraints = false
         uiView.backgroundColor = .black
         
         NSLayoutConstraint.activate([
             uiView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
             uiView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
             uiView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
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




 */
