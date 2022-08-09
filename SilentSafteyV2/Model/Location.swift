//
//  Location.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import Foundation
import CoreLocation

protocol LocationProtocol {
    func updateLocationLabel(text: String)
}

class Location: NSObject, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = {
        
        let locMan = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyBest // KCLLocationAccuracyNavigationBest
        locMan.allowsBackgroundLocationUpdates = true
        locMan.showsBackgroundLocationIndicator = true
        
        return locMan
    }()
    
    var delegate: LocationProtocol?
    var locationsRecieved: [LocationObject] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkRequestPermission() {
        if locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retrieveLocation()  {
        self.locationManager.startUpdatingLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            print("10 seconds after")
            self.locationManager.stopUpdatingLocation()

            if(Response.responseActive) {
                if(self.locationsRecieved.count != 0) {
                    
                    // Determine optimal location
                    var optimalLocationIndex = 0
                    for i in 0..<self.locationsRecieved.count {
                        if self.locationsRecieved[optimalLocationIndex].horizontalAccuracy > self.locationsRecieved[i].horizontalAccuracy {
                            optimalLocationIndex = i
                        }
                    }
                    
                    let optimalLocation = self.locationsRecieved[optimalLocationIndex]
                    let optimalLocationPlacemark = optimalLocation.placemark
                    
                    if let streetNumber = optimalLocationPlacemark.subThoroughfare, let streetName = optimalLocationPlacemark.thoroughfare, let city = optimalLocationPlacemark.locality {
                        
                        var streetNumberSpaced = ""
                        for number in streetNumber {
                            streetNumberSpaced += "\(number) "
                        }
                        print(streetNumberSpaced)
                        
                        let address = "My Location is \(streetNumberSpaced) \(streetName) \(city) within \(Int(optimalLocation.horizontalAccuracy)) meters of Accuracy"
                        print(address)
                        
                        NotificationCenter.default.post(name: .locationFound, object: nil, userInfo: ["placemark": address])
                    }
                } else {
                    self.delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
                }
            }
        
            self.locationsRecieved = []
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let location = locations.last {
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error == nil {

                    guard let place = placemarks?.first else {
                        return
                    }

                    if let streetNumber = place.subThoroughfare, let streetName = place.thoroughfare, let city = place.locality {
                        
                        let address = "My Location is \(streetNumber) \(streetName) \(city) within \(Int(location.horizontalAccuracy)) meters of Accuracy"
                        print(address)
                        
                        let locObj = LocationObject(horizontalAccuracy: location.horizontalAccuracy, placemark: place)
                        self.locationsRecieved.append(locObj)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error")
        delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("changeAuthorization called")
    
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                print("denied, restricted")
                delegate?.updateLocationLabel(text: "Type location in additional message - Permission Not Granted")
                NotificationCenter.default.post(name: .locationAuthorizationDetermined, object: nil)
            case .authorizedWhenInUse, .authorizedAlways:
                print("authorized")
                checkPrecisionAccuracyAuthorization()
                NotificationCenter.default.post(name: .locationAuthorizationDetermined, object: nil)
            default:
                print("not determiend")
                delegate?.updateLocationLabel(text: "Location Services Not Determined")
        }
    }
    
    func checkPrecisionAccuracyAuthorization() {
        if (locationManager.accuracyAuthorization == .fullAccuracy) {
            print("Full acc")
            delegate?.updateLocationLabel(text: "")
        } else {
            print("reduced accuracy")
            delegate?.updateLocationLabel(text: "Type location in additional message - Reduced Accuracy Selected")
        }
    }
    
    func checkAuthorization() -> Bool {
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                return false
            case .authorizedWhenInUse, .authorizedAlways:
                if (locationManager.accuracyAuthorization == .fullAccuracy) {
                    return true
                } else {
                    return false
                }
            default:
                return false
        }
    }
    
    func retrieveLocationAuthorization() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

struct LocationObject {
    let horizontalAccuracy: Double
    let placemark: CLPlacemark
}

