//
//  ReusableUIElements.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import Foundation
import UIKit

class ReusableUIElements {
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
        pageControl.tintColor = .blue
        pageControl.numberOfPages = 3
        
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
    
    static func createStackView(stackViewElements: [UILabel], spacing: Int) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stackViewElements)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = CGFloat(spacing)
        
        return stackView
    }
}
