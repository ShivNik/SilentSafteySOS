//
//  PreTestViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit
import SkyFloatingLabelTextField

class PreTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let salGuide = self.view.safeAreaLayoutGuide
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Get Started!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: salGuide.bottomAnchor, constant: -80)
            
        ])
        let directionsLabel = createLabel(title: "How to use the App", fontSize: 31)
        directionsLabel.font = UIFont.boldSystemFont(ofSize: 31)
        
        let labels = [directionsLabel, createLabel(title: "1. Tap the SOS Button and start the call", fontSize: 20), createLabel(title: "2. Return back to the app once the phone call begins", fontSize: 20), createLabel(title: "3. Type any additional Messages into the Text-Field", fontSize: 20)]
        
        var stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
     //   stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
    
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        let labelsTwo = [createLabel(title: "Step 3: Let's try it out", fontSize: 31), createLabel(title: "Enter a phone number you can test the app with", fontSize: 20)]

        let stackViewTwo = UIStackView(arrangedSubviews: labelsTwo)
        stackViewTwo.axis = .vertical
        stackViewTwo.distribution = .fillEqually
        stackViewTwo.spacing = 20
        stackViewTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackViewTwo)
        
        NSLayoutConstraint.activate([
            stackViewTwo.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
            stackViewTwo.topAnchor.constraint(equalTo: salGuide.topAnchor, constant: 20),
            stackViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
        let phoneNumberSkyTextField = SkyFloatingLabelTextField()
        phoneNumberSkyTextField.placeholder = "Enter a Phone Number"
        phoneNumberSkyTextField.backgroundColor = .black
        phoneNumberSkyTextField.textColor = .white
        phoneNumberSkyTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberSkyTextField.selectedTitleColor = .red
        phoneNumberSkyTextField.selectedLineColor = .blue
        view.addSubview(phoneNumberSkyTextField)
        
        NSLayoutConstraint.activate([
            phoneNumberSkyTextField.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
            phoneNumberSkyTextField.topAnchor.constraint(equalTo: stackViewTwo.bottomAnchor, constant: 40),
            phoneNumberSkyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneNumberSkyTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func createLabel(title: String, fontSize: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         
        label.text = title
        label.font = label.font.withSize(CGFloat(fontSize))
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }
}
