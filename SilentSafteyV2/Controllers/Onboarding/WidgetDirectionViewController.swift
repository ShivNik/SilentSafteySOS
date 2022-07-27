//
//  WidgetDirectionViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/6/22.
//

import UIKit

class WidgetDirectionViewController: UIViewController {
    var pageControl: UIPageControl = {
        return ReusableUIElements.createPageControl()
    }()
    
    let onboardingObjects = [
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Step 1: Hold down the Home Screen", description: "Hold down the homescreen until all the apps begin to wobble and tap the plus button at the top"),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Step 2: Search for Silent Saftey", description: "Search for Silent Saftey, Select the appropriate widget size"),
        OnboardingObject(image: UIImage(imageLiteralResourceName: "greenPhone"), title: "Step 3: Drag and Drop the Widget onto your Home Screen", description: "Tap the widget to initiate a phone call")
    ]
    
    var getStartedButton: UIButton = {
       return ReusableUIElements.createButton(title: "Next")
    }()
    
    var collectionView: UICollectionView = {
        return ReusableUIElements.createCollectionView()
    }()
    
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
        createUI()
        
    }
    
    func createUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
       
        // Next Button
        view.addSubview(getStartedButton)
        getStartedButton.addTarget(self, action:#selector(nextButtonPressed), for: .touchUpInside)
        ReusableUIElements.buttonConstraints(button: getStartedButton, safeArea: safeArea, bottomAnchorConstant: -40)
         
        // Page Control
        view.addSubview(pageControl)
        ReusableUIElements.pageControlConstraints(pageControl: pageControl, safeArea: safeArea, getStartedButton: getStartedButton)
        
        // Collection-View
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        ReusableUIElements.collectionViewConstraints(collectionView: collectionView, safeArea: safeArea, pageControl: pageControl)
    }
    
    
    @objc func nextButtonPressed(button: UIButton) {
        if currentPage == onboardingObjects.count - 1 {
            self.navigationController?.pushViewController(PreTestViewController(), animated: true)
       } else {
           currentPage += 1
           let indexPath = IndexPath(item: currentPage, section: 0)
           collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
       }
    }
}

// MARK: -  Create Cells
extension WidgetDirectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Number of Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Create Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.configure(onboardingObject: onboardingObjects[indexPath.row])
        return cell
    }
    // Return Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // Update Current Page
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
