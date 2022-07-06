//
//  SiriDirectionsViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class SiriDirectionsViewController: UIViewController {
    var pageControl: UIPageControl!
    
    let onboardingObjects = [
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Step 1: Siri", description: "Hold the phone screen ya see"),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Kanye west isSiria rapper", description: "Lil baby is a very cool rapper the very best"),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Someone is the Siri kid", description: "I still don't understand or comprehend it")
    ]
    var getStartedButton: UIButton!
    var collectionView: UICollectionView!
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == onboardingObjects.count - 1 {
                getStartedButton.setTitle("Next Step", for: .normal)
            } else {
                getStartedButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let safeArea = view.safeAreaLayoutGuide
       
        // Get Started Button
        getStartedButton = ReusableUIElements.createButton(title: "Continue")
        view.addSubview(getStartedButton)
        getStartedButton.addTarget(self, action:#selector(getStartedButtonAction), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: getStartedButton, safeArea: safeArea, bottomAnchorConstant: -40)
         
        // Create Page Control
        pageControl = ReusableUIElements.createPageControl()
        view.addSubview(pageControl)
        ReusableUIElements.pageControlConstraints(pageControl: pageControl, safeArea: safeArea, getStartedButton: getStartedButton)
        
        // Create Collection-View
        collectionView = ReusableUIElements.createCollectionView()
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        ReusableUIElements.collectionViewConstraints(collectionView: collectionView, safeArea: safeArea, pageControl: pageControl)
        
    }
    
    @objc
    func getStartedButtonAction(button: UIButton) {
        if currentPage == onboardingObjects.count - 1 {
           self.navigationController?.pushViewController(PreTestViewController(), animated: true)
       } else {
           currentPage += 1
           let indexPath = IndexPath(item: currentPage, section: 0)
           collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
       }
        
    }
}


extension SiriDirectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
