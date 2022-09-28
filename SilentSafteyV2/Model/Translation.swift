import Foundation

enum TranslationAPI {
    case detectLanguage
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        var urlString = ""
 
        switch self {
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"
 
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
 
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
 
        return urlString
    }
    
    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
}

class TranslationManager: NSObject {

    static let shared = TranslationManager()
    private var apiKey = ""
    
    override init() {
        super.init()
        if let key = Bundle.main.infoDictionary?["API_KEY"] as? String {
            apiKey = key
        }
    }
    
    func translate(textToTranslate: String, sourceLanguageCode: String, targetLanguageCode: String, completion: @escaping (_ translations: String?) -> Void) {
       
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguageCode
        urlParams["format"] = "text"
        urlParams["source"] = sourceLanguageCode

        makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { (results) in
            guard let results = results else { completion(nil); return }

            if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                
                var allTranslations = [String]()
                
                for translation in translations {
                    if let translatedText = translation["translatedText"] as? String {
                        allTranslations.append(translatedText)
                    }
                }
             
                if allTranslations.count > 0 {
                    completion(allTranslations[0])
                } else {
                    completion(nil)
                }
             
             
            } else {
                completion(nil)
            }
        }
    }
    
    func detectLanguage(forText text: String, completion: @escaping (_ language: String?) -> Void) {
        let urlParams = ["key": apiKey, "q": text]

        makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { (results) in

            guard let results = results else { completion(nil); return }

            if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                var detectedLanguages = [String]()
     
                for detection in detections {
                    for currentDetection in detection {
                        if let language = currentDetection["language"] as? String {
                            detectedLanguages.append(language)
                        }
                    }
                }
     
                if detectedLanguages.count > 0 {
                    completion(detectedLanguages[0])
                } else {
                    completion(nil)
                }
                
            } else {
                completion(nil)
            }
        }
    }

    func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        
        var boolCompleted: Bool? = nil

        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
     
            for (key, value) in urlParams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
     
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = api.getHTTPMethod()
     
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { (results, response, error) in
                    
                    if error == nil {
                        if let response = response as? HTTPURLResponse, let results = results {
                            if response.statusCode == 200 || response.statusCode == 201 {
                                do {
                                    if let resultsDict = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                        
                                        boolCompleted = true
                                        completion(resultsDict)
                                        return
                                        
                                    } else {
                                        boolCompleted = false
                                    }
                                } catch {
                                    boolCompleted = false
                                }
                            } else {
                                boolCompleted = false
                            }
                        } else {
                            boolCompleted = false
                        }
                    } else {
                        boolCompleted = false
                    }
                    
                    if(boolCompleted == false) {
                        completion(nil)
                        return
                    }
                }
                
                task.resume()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if(boolCompleted == nil) {
                        switch task.state {
                            case .canceling,.running,.suspended:
                                task.cancel()
                                completion(nil)
                            default:
                                print("default")
                        }
                        return
                    }
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
