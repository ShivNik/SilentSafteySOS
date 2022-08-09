//
//  Translation.swift
//  Silent Saftey
//
//  Created by Shivansh Nikhra on 8/9/22.
//

import Foundation
import NaturalLanguage

class Translation {
    func detectLanguage(for string: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        return recognizer.dominantLanguage
    }
}
