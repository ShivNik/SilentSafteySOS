//
//  TermsOfServiceViewController.swift
//  Silent Saftey
//
//  Created by Shivansh Nikhra on 8/6/22.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = view.safeAreaLayoutGuide
        
        // Text View
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // Attributed String
        let attributedString = NSMutableAttributedString(string: "By continuing, you agree to our Terms and Conditions and Privacy Policy")
        let urlPrivacy = URL(string: "https://www.apple.com")!
        let urlTAC = URL(string: "https://www.apple.com")!

        attributedString.setAttributes([.link: urlPrivacy], range: NSRange(location: 32, length: 20))
        attributedString.setAttributes([.link: urlTAC], range: NSRange(location: 57, length: 14))
        
        attributedString.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 31))
        attributedString.setAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 53, length: 3))

        // Text View Characteristics
        textView.attributedText = attributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textAlignment = .center
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.font = UIFont.systemFont(ofSize: CGFloat(10))
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            
        ])
    }
}
