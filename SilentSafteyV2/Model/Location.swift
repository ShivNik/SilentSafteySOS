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
    
    var locationManager: CLLocationManager!
    var delegate: LocationProtocol?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // KCLLocationAccuracyNavigationBest
    }
    
    func checkRequestPermission() {
        if locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retrieveLocation()  {
        self.locationManager.requestLocation()
    }
    
    func retrieveLocationAuthorizaiton() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let location = locations.last {
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error == nil {
                    print("Number of placemarks \(placemarks!.count)")
                    
                    let pm = placemarks![0]
                    let address = "My Location is " + "\(pm.subThoroughfare!) \(pm.thoroughfare!) \(pm.locality!) within \(Int(location.horizontalAccuracy)) meters of Accuracy"
                    
                    print(address)
                    
                    NotificationCenter.default.post(name: .locationFound, object: nil, userInfo: ["placemark": address])
                }
                else {
                    self.delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error")
        delegate?.updateLocationLabel(text: "Type location in additional message - Location Not Found")
        print(error)
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("changeAuthorization called")
    
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                print("denied, restricted")
                delegate?.updateLocationLabel(text: "Type location in additional message - Permission Not Granted")
            case .authorizedWhenInUse, .authorizedAlways:
             //   NotificationCenter.default.post(name: .locationAuthorizationGiven, object: nil)
            
                print("authorized")
                checkPrecisionAccuracyAuthroization()
            default:
                print("not determiend")
                delegate?.updateLocationLabel(text: "Location Services Enabled Not Determined")
               // checkLocationAuthorization()
        }
    }
    
    func checkPrecisionAccuracyAuthroization() {
        switch locationManager.accuracyAuthorization {
            case .reducedAccuracy:
                print("reduced accuracy")
                delegate?.updateLocationLabel(text: "Type location in additional message - Reduced Accuracy Selected")
            default:
                print("Full acc")
                delegate?.updateLocationLabel(text: "")
                NotificationCenter.default.post(name: .locationAuthorizationGiven, object: nil)
        }
    }
    
    func checkAuthorization() -> Bool {
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                return false
            case .authorizedWhenInUse, .authorizedAlways:
                return true
            default:
                return false
        }
    }
    
    func doesNothing() {
        
    }
}



/* print(pm.country)
 print(pm.locality)
 print(pm.subLocality)
 print(pm.thoroughfare)
 print(pm.postalCode)
 print(pm.subThoroughfare) */
 
/*  print(pm.name) // Not really sure
 print(pm.isoCountryCode)
 print(pm.country)
 print(pm.postalCode)
 print(pm.administrativeArea) // State/Province
 print(pm.subAdministrativeArea) // County
 print(pm.locality) // City
 print(pm.subLocality) // name of the neighborhood or landmark associated with the placemark. It might also refer to a common name that’s associated with the location.
 print(pm.thoroughfare) // Street name
 print(pm.subThoroughfare) //  street number for the location
 print(pm.postalAddress)
 
 let formatter = CNPostalAddressFormatter()
 print(formatter.string(from: pm.postalAddress!)) */


/*   print(location.coordinate.latitude)
   print(location.coordinate.longitude)
   print("Accuracy \(location.horizontalAccuracy)") */


/*func setUpLocation()  {
    checkLocationAuthorization()
} */
