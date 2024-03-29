//
//  ReusableUIElements.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class ReusableUIElements:  NSObject, UITextFieldDelegate {

    static let titleFontSize: Int = {
        
        let bounds = UIScreen.main.bounds
        
        switch (bounds.size.height) {
            case 920..<2000:
                return 25
            case 820..<920:
                return 24
            case 670..<820:
                return 23
            case 570..<670:
                return 22
            default:
                return 20
        }
    }()
    
    static let descriptionFontSize: Int = {
        
        let bounds = UIScreen.main.bounds
        
        switch (bounds.size.height) {
            case 920..<2000:
                return 20
            case 820..<920:
                return 19
            case 670..<820:
                return 18
            case 570..<670:
                return 17
            default:
                return 15
        }
    }()
    
    
    static func createButton(title: String) -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }
    
    static func buttonConstraints(button: UIButton, safeArea: UILayoutGuide, bottomAnchorConstant: Int) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: CGFloat(bottomAnchorConstant))
            
        ])
    }
    
    static func createPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.numberOfPages = 3
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }
    
    static func pageControlConstraints(pageControl: UIPageControl, safeArea: UILayoutGuide, getStartedButton: UIButton) {
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            pageControl.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -16)
        ])
    }
    
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        collectionView.isPagingEnabled = true
       // collectionView.contentInsetAdjustmentBehavior = .never // Check this
        collectionView.backgroundColor = .black
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        
        return collectionView
    }
    
    static func collectionViewConstraints(collectionView: UICollectionView, safeArea: UILayoutGuide, pageControl: UIPageControl) {
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])
    }
    
    static func createImageView(resourceName: String) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: resourceName)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    static func createLabel(fontSize: Int, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = label.font.withSize(CGFloat(fontSize))
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.text = text
        
        return label
    }
    
    static func createStackView(stackViewElements: [UIView], spacing: Int, distributionType: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stackViewElements)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = distributionType
        stackView.alignment = .fill
        stackView.spacing = CGFloat(spacing)
        
        return stackView
    }
    
    static func createSkyTextField(placeholder: String, title: String, id: String) -> SkyFloatingLabelTextField {
        let skyTextField = SkyFloatingLabelTextField()
        skyTextField.translatesAutoresizingMaskIntoConstraints = false
        
        skyTextField.placeholder = placeholder
        skyTextField.title = title
        skyTextField.accessibilityIdentifier = id
        
        skyTextField.errorColor = .red
        skyTextField.textColor = .white
        
        skyTextField.selectedTitleColor = .blue
        skyTextField.selectedLineColor = .blue
        
        return skyTextField
    }
    
    static func createTextView() -> UITextView {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.contentInsetAdjustmentBehavior = .never
        textView.backgroundColor = .darkGray
        textView.autocorrectionType = .no
        textView.text = "Type Additional Message Here"
        textView.textColor = .white
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 20
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        
        return textView
    }
    
    static func textViewConstraints(textView: UITextView, safeArea: UILayoutGuide) {
        
        let cons = textView.heightAnchor.constraint(equalToConstant: 40)
        cons.identifier = "heightConstraint"
        cons.priority = UILayoutPriority(250)
        cons.isActive = true
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            textView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.85)
        ])
    }
    
    static func createSendButton(textView: UITextView) -> UIButton {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: textView.frame.size.height, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "paperplane.fill", withConfiguration: largeConfig)
       
        button.setImage(largeBoldDoc, for: .normal)
        
        return button
    }
    
    static func sendButtonConstraints(button: UIButton, view: UIView, safeArea: UILayoutGuide, textView: UITextView) {
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(safeArea.layoutFrame.width * 0.04)),
            button.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
    }
    
    static func createSosButton() -> UIButton {
        let sosButton = UIButton(type: .custom)
        let sosImage = UIImage(named: "SosButton")
    
        sosButton.setImage(sosImage, for: .normal)
        sosButton.translatesAutoresizingMaskIntoConstraints = false
        
        return sosButton
    }
    
    static func settingButtonConstraint(button: UIButton, safeArea: UILayoutGuide) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: -  Navigation Controller Methods
extension ReusableUIElements {
    static func createNavigationController(rootVC: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootVC)
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .black
        
        navigation.navigationBar.standardAppearance = standardAppearance
        navigation.navigationBar.scrollEdgeAppearance = standardAppearance
        
        return navigation
    }
    
    static func addExitButton(navController: UINavigationController) {
        navController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitPressed))
    }
    
    @objc func exitPressed(navController: UINavigationController) {
        navController.popToRootViewController(animated: true)
    }
    
    static func createNavigationController(root: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: root)

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .black
        
        navController.navigationBar.standardAppearance = standardAppearance
        navController.navigationBar.scrollEdgeAppearance = standardAppearance
        
        return navController
    }
}
