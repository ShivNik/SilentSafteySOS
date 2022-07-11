//
//  CompletionViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/8/22.
//

import UIKit

class CompletionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        let labelsTwo = [ReusableUIElements.createLabel(fontSize: 50, text: "You're Done!") , ReusableUIElements.createLabel(fontSize: 31, text: "Set up your contacts and custom Messages")]
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: labelsTwo, spacing: 20, distributionType: .fillEqually)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        let button = ReusableUIElements.createButton(title: "Finish Tutorial")
        button.addTarget(self, action: #selector(finishTutorialPressed), for: .touchUpInside)
        view.addSubview(button)
        ReusableUIElements.buttonConstraints(button: button, safeArea: safeArea, bottomAnchorConstant: -40)
    }
    
    @objc func finishTutorialPressed() {
        AppDelegate.userDefaults.set(true, forKey: AllStrings.tutorialFinished)
        self.navigationController?.dismiss(animated: false, completion: nil)
        
        let newNavController = UINavigationController(rootViewController:  MainViewController())
        
        self.present(newNavController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
