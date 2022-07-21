//
//  TextFieldValidation.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/20/22.
//

import Foundation
import SkyFloatingLabelTextField

struct TextFieldValidation {
    
    func validateOnlyAlphabet(skyTextField: SkyFloatingLabelTextField) -> Bool {
        replaceDot(skyTextField: skyTextField)
        
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
        
        replaceDot(skyTextField: skyTextField)
        
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
        
        replaceDot(skyTextField: skyTextField)
        
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
        replaceDot(skyTextField: skyTextField)
        
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
