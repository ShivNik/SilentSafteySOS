//
//  TextFieldEssential.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/21/22.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class TextFieldEssential: NSObject {
    
    let viewControllerView: UIView
    
    init(vcView: UIView) {
        self.viewControllerView = vcView
    }
}

// MARK: -  Keyboard
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

// MARK: -  Validation Methods
extension TextFieldEssential {
    func validateOnlyAlphabet(skyTextField: SkyFloatingLabelTextField) -> Bool {
    
        if var trimmedString = skyTextField.text {
            
            trimmedString = trimmedString.trimmingCharacters(in: .whitespaces)
            
            if trimmedString != "" {
                
                let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
                
                if(trimmedString.rangeOfCharacter(from: set.inverted) == nil) {
                    return true
                }
                
            } else {
                return true
            }
        }
        
        return false
    }
    
    func validateNumberConstraints(skyTextField: SkyFloatingLabelTextField, lowConstraint: Int, highConstraint: Int) -> Bool {
        
        if var trimmedString = skyTextField.text {
            trimmedString = trimmedString.trimmingCharacters(in: .whitespaces)
            
            let val = Int(trimmedString)
            
            if(trimmedString != "") {
                if let val = val {
                    if(val > lowConstraint && val < highConstraint) {
                        return true
                    }
                }
            } else {
                return true
            }
        }
        return false
    }
    
    func validateHeight(skyTextField: SkyFloatingLabelTextField) -> Bool {
        
        if var trimmedString = skyTextField.text {
            trimmedString = trimmedString.trimmingCharacters(in: .whitespaces)
            
            if(trimmedString != "") {
                
                let all = trimmedString.components(separatedBy: " ")
                let firstNum = Int(all[0])
                let secondNum = Int(all[1])
                
                if(all.count == 2) {
                    if let firstNum = firstNum, let secondNum = secondNum {
                        if(firstNum >= 0 && firstNum <= 9 && secondNum >= 0 && secondNum <= 11) {
                            return true
                        }
                    }
                }
                
            } else {
                return true
            }
        }
        
        return false
    }
    
    func validatePhoneNumber(skyTextField: SkyFloatingLabelTextField) -> Bool {
        
        if var trimmedString = skyTextField.text {
            trimmedString = trimmedString.trimmingCharacters(in: .whitespaces)
            
            if(trimmedString != "") {
                let set = CharacterSet(charactersIn: trimmedString)
                
                if(CharacterSet.decimalDigits.isSuperset(of: set) && trimmedString.count == 10) {
                   return true
                } else if(trimmedString == "911") {
                    return true
                }
            }
        }
        return false
    }
}
