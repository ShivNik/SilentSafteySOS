//
//  TextFieldEssential.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/21/22.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class TextFieldEssential: NSObject, UITextFieldDelegate {
    
    let viewControllerView: UIView
    
    init(vcView: UIView) {
        self.viewControllerView = vcView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    @objc func textFieldDidChange(_ textfield: UITextField) {
       if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
           AppDelegate.validation.replaceDot(skyTextField: floatingLabelTextField)
       }
    }
}

extension TextFieldEssential {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(TextFieldEssential.dismissKeyboard))

        tap.cancelsTouchesInView = false
        viewControllerView.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        viewControllerView.endEditing(true)
    }
}
