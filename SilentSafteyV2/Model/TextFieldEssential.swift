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
           replaceDot(skyTextField: floatingLabelTextField)
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

// MARK: -  Validation Methods
extension TextFieldEssential {
    func validateOnlyAlphabet(skyTextField: SkyFloatingLabelTextField) -> Bool {
    
        if skyTextField.text != "" {
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            
            if((skyTextField.text!).rangeOfCharacter(from: set.inverted) == nil){
                return true
            }
            
        } else {
            return true
        }
        return false
    }
    
    func validateNumberConstraints(skyTextField: SkyFloatingLabelTextField, lowConstraint: Int, highConstraint: Int) -> Bool {
        
        let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
        
        let val = Int(trimmedString)
        
        if(trimmedString != "") {
            if(val != nil && val! > lowConstraint && val! < highConstraint) {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    func validateHeight(skyTextField: SkyFloatingLabelTextField) -> Bool {
        
        let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if(trimmedString != "") {
            
            let all = (trimmedString).components(separatedBy: " ")
            
            if(all.count == 2 && Int(all[0]) != nil && Int(all[1]) != nil) {
                
                if(Int(all[0])! >= 0 && Int(all[0])! <= 9 && Int(all[1])! >= 0 && Int(all[1])! <= 11) {
                    return true
                }
            }
        } else {
            return true
        }
        
        return false
    }
    
    func validatePhoneNumber(skyTextField: SkyFloatingLabelTextField) -> Bool {
        
        let trimmedString = skyTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if(trimmedString != "") {
            let set = CharacterSet(charactersIn: trimmedString)
            if CharacterSet.decimalDigits.isSuperset(of: set) && trimmedString.count == 10 {
               return true
            }
        }
        return false
    }
    
    func replaceDot(skyTextField: SkyFloatingLabelTextField) {
        skyTextField.text = skyTextField.text!.replacingOccurrences(of: ".", with: " ")
    }
}
