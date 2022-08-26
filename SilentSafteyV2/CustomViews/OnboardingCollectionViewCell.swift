//
//  OnboardingCollectionViewCell.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCollectionViewCell"
    
    private let imageView: UIImageView = {
        return ReusableUIElements.createImageView(resourceName: "redPhone")
    }()
    
    private let titleLabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "")
    }()
    
    private let descriptionLabel: UILabel = {
        return ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "")
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: -  UI Elements
extension OnboardingCollectionViewCell {
    func createUI() {
        contentView.backgroundColor = .black
        
        // Image View
        contentView.addSubview(imageView)
    
        // Title/Description Stack View
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,descriptionLabel], spacing: 16, distributionType: .fillProportionally)
        contentView.addSubview(stackView)
        
        // Stack View Constraints
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        // Image View Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
    }
    
    func configure(onboardingObject: OnboardingObject) {
        imageView.image = onboardingObject.image
        titleLabel.text = onboardingObject.title
        descriptionLabel.text = onboardingObject.description
    }
}

// MARK: - Onboarding Object Struct
struct OnboardingObject {
    let image: UIImage
    let title: String
    let description: String
}
