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
        locMan.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.locationManager.stopUpdatingLocation()

            if(Response.responseActive) {
                if(self.locationsRecieved.count != 0) {
                    
                    var optimalLocationIndex = 0
                    for i in 0..<self.locationsRecieved.count {
                        if self.locationsRecieved[optimalLocationIndex].horizontalAccuracy >=  self.locationsRecieved[i].horizontalAccuracy {
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
                        
                        let address = "My Location is \(streetNumberSpaced) \(streetName) \(city) within \(Int(optimalLocation.horizontalAccuracy)) meters of Accuracy"
                        
                        NotificationCenter.default.post(name: .locationFound, object: nil, userInfo: ["placemark": address])
                        
                    } else {
                        self.delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
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

                    if let _ = place.subThoroughfare, let _ = place.thoroughfare, let _ = place.locality {
                    
                        let locObj = LocationObject(horizontalAccuracy: location.horizontalAccuracy, placemark: place)
                        self.locationsRecieved.append(locObj)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                delegate?.updateLocationLabel(text: "Type location in additional message - Permission Not Granted")
                NotificationCenter.default.post(name: .locationAuthorizationDetermined, object: nil)
            case .authorizedWhenInUse, .authorizedAlways:
                checkPrecisionAccuracyAuthorization()
                NotificationCenter.default.post(name: .locationAuthorizationDetermined, object: nil)
            default:
                delegate?.updateLocationLabel(text: "Location Services Not Determined")
        }
    }
    
    func checkPrecisionAccuracyAuthorization() {
        if (locationManager.accuracyAuthorization == .fullAccuracy) {
            delegate?.updateLocationLabel(text: "")
        } else {
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
