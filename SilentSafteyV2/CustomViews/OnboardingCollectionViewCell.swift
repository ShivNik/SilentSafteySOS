//
//  OnboardingCollectionViewCell.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCollectionViewCell"
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    func createUI() {
        contentView.backgroundColor = .black
        
        // Create Image View
        imageView = ReusableUIElements.createImageView(resourceName: "greenPhone")
        contentView.addSubview(imageView)
    
        // Create Titles
        titleLabel = ReusableUIElements.createLabel(fontSize: ReusableUIElements.titleFontSize, text: "")
        descriptionLabel = ReusableUIElements.createLabel(fontSize: ReusableUIElements.descriptionFontSize, text: "")
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,descriptionLabel], spacing: 16, distributionType: .fillProportionally)
        contentView.addSubview(stackView)
        
        // Titles Constraints
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
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        ])
    }
    
    func configure(onboardingObject: OnboardingObject) {
        imageView.image = onboardingObject.image
        titleLabel.text = onboardingObject.title
        descriptionLabel.text = onboardingObject.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
