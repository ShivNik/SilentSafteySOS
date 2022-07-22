//
//  ViewMessageViewController.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/22/22.
//

import UIKit

class ViewMessageViewController: UIViewController, ObserveSynthesizer {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
    }
    
    func createUI() {
        view.backgroundColor = .black
    }
    
    func synthesizerStarted(message: String) {
        view.backgroundColor = .green
        print(message)
        print("ended")
    }
    
    func synthesizerEnded() {
        print("started")
    }
    
    
}
