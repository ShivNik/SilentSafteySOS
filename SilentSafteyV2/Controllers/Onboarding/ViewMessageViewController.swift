//
//  ViewMessageViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/22/22.
//

import UIKit
/*
class ViewMessageViewController: UIViewController, ObserveSynthesizer {

    let titleLabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: 30, text: "View what messages have been sent")
    }()
    
    let sentMessagesLabel: UILabel = {
        let label = ReusableUIElements.createLabel(fontSize: 20, text: "")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        print("VIEW MESSAGE CONTROLLER PRESENT")
    }
    
    func createUI() {
        let safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = .black
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(sentMessagesLabel)
        NSLayoutConstraint.activate([
            sentMessagesLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 16),
            sentMessagesLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            sentMessagesLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            sentMessagesLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        ])
    }
    
    func synthesizerStarted() {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .green
        print("Synthesizer started")
    }
    
    func synthesizerEnded(message: String, changeLabel: Bool) {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        print("Synthesizer ended")
    
        if(changeLabel) {
            sentMessagesLabel.text = sentMessagesLabel.text! + "\n \n" + message
        }
    }
    
    func callEnded() {
        sentMessagesLabel.text = ""
        // self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        self.navigationController?.popToRootViewController(animated: true)
    }
}
*/ 
