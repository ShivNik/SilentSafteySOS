//
//  Location.swift
//  SilentSafteyV2
//
//  Created by Shivansh Nikhra on 7/9/22.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // KCLLocationAccuracyNavigationBest
    }
    
    func checkLocationAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setUpLocation()  {
        checkLocationAuthorization()
    }
    
    func retrieveLocation()  {
        self.locationManager.requestLocation()
    }
    
    func retrieveLocationAuthorizaiton() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print("Accuracy \(location.horizontalAccuracy)")
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error == nil {
                    print("number of placemakr \(placemarks!.count)")
                    let pm = placemarks![0]
                    let address = "My Location is " + "\(pm.subThoroughfare!) \(pm.thoroughfare!) \(pm.locality!) \(pm.administrativeArea!) \(pm.country!)"
                    print(address)
                    print(pm.region)
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
                
                    NotificationCenter.default.post(name: .locationFound, object: nil, userInfo: ["placemark": address])
                }
                else {
                    print("Error occured geocoding")
                }
            })
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager did fail with error")
    }
    
    // Called - the system calls as soon as your app creates the location manager, and any time your app’s authorization status changes.
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("changeAuthorization called")
        
        switch locationManager.accuracyAuthorization {
            case .fullAccuracy:
                print("full accuracy")
            case .reducedAccuracy:
                print("reduce")
            default:
                break
        }
        
        switch locationManager.authorizationStatus {
            case .denied:
                print("denied")
            case .authorizedWhenInUse, .authorizedAlways:
                print("authorized  when in use/always")
            case .restricted :
                print("Restricted")
            default:
                print("Default")
        }
      //  locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDelivery")
    }
    
    
}


