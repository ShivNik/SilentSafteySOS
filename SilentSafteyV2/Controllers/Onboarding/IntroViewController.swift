//
//  IntroViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class IntroViewController: UIViewController {

    var pageControl: UIPageControl!
    
    let onboardingObjects = [
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated SOS Calling", description: "Automatically call 911 with an automated bot in a situation where you can't talk on the phone with the tap of a button"),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated Message", description: "The automated message sends police relevant information about yourself such as your name, location, race, age, weight, height, etc."),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated SMS For the kids Messaging", description: "Use your voice to send customizable messages to emergency contacts when you can't reach your phone. Very useful!")
    ]
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("hello")
        let safeArea = view.safeAreaLayoutGuide
       
        // Get Started Button
        let getStartedButton = ReusableUIElements.createButton(title: "Get Started!")
        view.addSubview(getStartedButton)
        getStartedButton.addTarget(self, action:#selector(getStartedButtonAction), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: getStartedButton, safeArea: safeArea, bottomAnchorConstant: -40)
         
        // Create Page Control
        pageControl = ReusableUIElements.createPageControl()
        view.addSubview(pageControl)
        ReusableUIElements.pageControlConstraints(pageControl: pageControl, safeArea: safeArea, getStartedButton: getStartedButton)
        
        // Create Collection-View
        let collectionView = ReusableUIElements.createCollectionView()
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        ReusableUIElements.collectionViewConstraints(collectionView: collectionView, safeArea: safeArea, pageControl: pageControl)
        
    }
    
    @objc
    func getStartedButtonAction(button: UIButton) {
        self.navigationController?.pushViewController(InformationViewController(), animated: true)
    }
}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.configure(onboardingObject: onboardingObjects[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}



/*

 class IntroViewController: UIViewController {

     let onboardingObjects = [
         OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated SOS Calling", description: "Automatically call 911 with an automated bot in a situation where you can't talk on the phone with the tap of a button"),
         OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated Message", description: "The automated message sends police relevant information about yourself such as your name, location, race, age, weight, height, etc."),
         OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated SMS For the kids Messaging", description: "Use your voice to send customizable messages to emergency contacts when you can't reach your phone. Very useful!")
     ]
     
     @objc
     func getStartedButtonAction() {
         print("Button pressed")
       /*  let fifthStepVC = FifthViewController()
         fifthStepVC.modalPresentationStyle = .fullScreen
         self.present(fifthStepVC, animated: true) */
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black
         
         print("hello")
         let salGuide = view.safeAreaLayoutGuide
         let button = UIButton()
         button.backgroundColor = .systemRed
         button.setTitle("Get Started!", for: .normal)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.addTarget(self,
                          action: #selector(getStartedButtonAction),
                          for: .touchUpInside)
         view.addSubview(button)
         
         NSLayoutConstraint.activate([
             button.widthAnchor.constraint(equalToConstant: 150),
             button.heightAnchor.constraint(equalToConstant: 50),
             
             button.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
             button.bottomAnchor.constraint(equalTo: salGuide.bottomAnchor, constant: -40)
             
         ])
         
         let pageControl = UIPageControl()
         view.addSubview(pageControl)
         pageControl.translatesAutoresizingMaskIntoConstraints = false
         
         pageControl.currentPageIndicatorTintColor = .red
         pageControl.tintColor = .blue
         pageControl.numberOfPages = 3
         
         NSLayoutConstraint.activate([
             pageControl.centerXAnchor.constraint(equalTo: salGuide.centerXAnchor, constant: 0),
             pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
         ])
         
         
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal
         layout.minimumLineSpacing = 0
         
          
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         view.addSubview(collectionView)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         
         collectionView.dataSource = self
         collectionView.delegate = self
         collectionView.isPagingEnabled = true
        // collectionView.contentInsetAdjustmentBehavior = .never // Check this
         collectionView.backgroundColor = .red
         collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
         
         
         NSLayoutConstraint.activate([
             collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
             collectionView.topAnchor.constraint(equalTo: salGuide.topAnchor),
             collectionView.trailingAnchor.constraint(equalTo: salGuide.trailingAnchor),
             collectionView.leadingAnchor.constraint(equalTo: salGuide.leadingAnchor)
         ])
         
     }
     
     
 }

 extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 3
     }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
         
         cell.configure(onboardingObject: onboardingObjects[indexPath.row])
         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

         return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
     }
 }
 */
