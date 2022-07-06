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
        contentView.backgroundColor = .black
        
        imageView = ReusableUIElements.createImageView(resourceName: "greenPhone")
        contentView.addSubview(imageView)
    
        titleLabel = ReusableUIElements.createLabel(fontSize: 31, text: "Automated SOS Calls")
        descriptionLabel = ReusableUIElements.createLabel(fontSize: 17, text: "Have fun with your friends and the family this is really long on purpose")
        
        let stackView = ReusableUIElements.createStackView(stackViewElements: [titleLabel,descriptionLabel], spacing: 16)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(onboardingObject: OnboardingObject) {
        imageView.image = onboardingObject.image
        titleLabel.text = onboardingObject.title
        descriptionLabel.text = onboardingObject.description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


/*
 

 class OnboardingCollectionViewCell: UICollectionViewCell {
     
     static let identifier = "OnboardingCollectionViewCell"
     
     private let myImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.font = label.font.withSize(31)
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .systemRed
         label.textAlignment = .center
         return label
     }()
     
     private let descriptionLabel: UILabel = {
         let label = UILabel()
         label.font = label.font.withSize(17)
         label.numberOfLines = 0
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .systemRed
         label.textAlignment = .center
         return label
     }()
     
     private var stackView: UIStackView!
     
     func setUpStackView() {
         let stackViewElements = [titleLabel,descriptionLabel]
         stackView = UIStackView(arrangedSubviews: stackViewElements)
         stackView.axis = .vertical
         stackView.distribution = .fillEqually
         stackView.spacing = 0
         stackView.translatesAutoresizingMaskIntoConstraints = false
     }
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.backgroundColor = .black
         
         let imageView = UIImageView()
         contentView.addSubview(imageView)
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(imageLiteralResourceName: "greenPhone")
         imageView.contentMode = .scaleAspectFit
     
         
         let titleLabel = UILabel()
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         
         titleLabel.font = titleLabel.font.withSize(31)
         titleLabel.numberOfLines = 0
         titleLabel.textColor = .white
         titleLabel.textAlignment = .center
         titleLabel.text = "Automated SOS Calls"
         
         let descriptionLabel = UILabel()
         descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
         
         descriptionLabel.font = descriptionLabel.font.withSize(20)
         descriptionLabel.numberOfLines = 0
         descriptionLabel.textColor = .white
         descriptionLabel.textAlignment = .center
         descriptionLabel.text = "Have fun with your friends and the fmaily this is really long on purpose"
         
         let stackViewElements = [titleLabel,descriptionLabel]
         let stackView = UIStackView(arrangedSubviews: stackViewElements)
         contentView.addSubview(stackView)
         stackView.translatesAutoresizingMaskIntoConstraints = false
         
         stackView.axis = .vertical
         stackView.distribution = .fillProportionally
         stackView.alignment = .fill
         stackView.spacing = 16
         
         
         NSLayoutConstraint.activate([
             stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
             stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
             stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
         ])
         
         NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
             imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             imageView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
         ])
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
     }
     
     func configure(onboardingObject: OnboardingObject) {
         myImageView.image = onboardingObject.image
         titleLabel.text = onboardingObject.title
         descriptionLabel.text = onboardingObject.description
     }
     
     override func prepareForReuse() {
         super.prepareForReuse()
     }
 }

 */
