//
//  IntroViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class IntroViewController: UIViewController {

    let pageControl: UIPageControl = {
       return ReusableUIElements.createPageControl()
    }()
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    let onboardingObjects = [
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated SOS Calling", description: "Call 911 with an automated call bot that speaks to the police when you can't speak on the phone"),
        
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Automated Message", description: "Our call bot will give police relevant informaiton about yourself and your lcoation. Type in additional Messages as well "),
        
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Easy Access", description: "Begin the call using SOS button in app or SOS widget")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI() {        
        view.backgroundColor = .black
        let safeArea = view.safeAreaLayoutGuide
    
        // Get Started Button
        let getStartedButton = ReusableUIElements.createButton(title: "Get Started!")
        getStartedButton.addTarget(self, action:#selector(getStartedButtonPressed), for: .touchUpInside)
        view.addSubview(getStartedButton)
        ReusableUIElements.buttonConstraints(button: getStartedButton, safeArea: safeArea, bottomAnchorConstant: -40)
         
        // Page Control
        view.addSubview(pageControl)
        ReusableUIElements.pageControlConstraints(pageControl: pageControl, safeArea: safeArea, getStartedButton: getStartedButton)
        
        // Collection View
        let collectionView = ReusableUIElements.createCollectionView()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        ReusableUIElements.collectionViewConstraints(collectionView: collectionView, safeArea: safeArea, pageControl: pageControl)
    }
    
    @objc func getStartedButtonPressed(button: UIButton) {
        self.navigationController?.pushViewController(InformationViewController(), animated: true)
    }
}

// MARK: -  Populate Collection View Cells
extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Number of Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Create Cell + Configure
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.configure(onboardingObject: onboardingObjects[indexPath.row])
        return cell
    }
    
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // Update Current Page
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
