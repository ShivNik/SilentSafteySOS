//
//  Translation.swift
//  Silent Saftey
//
//  Created by Shivansh Nikhra on 8/14/22.
//

import Foundation
import NaturalLanguage
import MLKit

protocol TranslationProtocol {
    func recievedTranslation(translation: String)
}

class Translation: NSObject {
    
    var delegate: TranslationProtocol?
    
    func translate(for text: String) {
        let languageId = LanguageIdentification.languageIdentification()

        languageId.identifyLanguage(for: text) { (languageCode, error) in
            if error != nil {

                print(error!.localizedDescription)
                
            } else {
                var successLangCode = false

                if let langCode = languageCode, languageCode != "und" {
                    
                    successLangCode = true
                    
                    if(languageCode != "en") {
                        var urlParams: [String: String] = [:]
                        urlParams["key"] = "AIzaSyCr1JOeOPG6vK5H96roe8aFztAzMd7UkOc"
                        urlParams["q"] = text
                        
                        urlParams["source"] = langCode
                        urlParams["target"] = "en"
                    
                        self.makeRequest(parameters: urlParams) { (results) in
                            guard let results = results else { return }

                            if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                                
                                if translations.count > 0 {
                                    if let translation = translations[0]["translatedText"] {
                                        self.delegate?.recievedTranslation(translation: translation as! String)
                                    }
                                }
                            }
                        }
                    } else {
                        self.delegate?.recievedTranslation(translation: text)
                    }
                }
                
                if(!successLangCode) {
                    let emojiDict = ["🚓": "I require police assistance",
                                     "🚑": "I require Medical assistance",
                                     "🚒": "I require Fireghter assistance"]
                
                    if let val = emojiDict[text] {
                        self.delegate?.recievedTranslation(translation: val)
                        return
                    }

                    self.delegate?.recievedTranslation(translation: text)
                }
            }
        }
    }
    
    func makeRequest(parameters: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        
        if var properties = URLComponents(string: "https://translation.googleapis.com/language/translate/v2") {
            
            properties.queryItems = [URLQueryItem]()
     
            for (key, value) in parameters {
                properties.queryItems?.append(URLQueryItem(name: key, value: value))
            }
     
            if let url = properties.url {
                
                let urlSession = URLSession(configuration: .default)
                let task = urlSession.dataTask(with: URLRequest(url: url)) { (dataRetrieved, responseCode, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        if let data = dataRetrieved {
                            do {
                                if let resultsDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                    completion(resultsDict)
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
