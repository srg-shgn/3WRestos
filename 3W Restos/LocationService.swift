//
//  LocationService.swift
//  3W Restos
//
//  Created by etudiant04 on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    lazy var geocoder = CLGeocoder()
    
    var isAuthorised = false {
        didSet {
            if isAuthorised {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAuthorised = (status == .authorizedWhenInUse)
    }
    
    //calule la distance entre le resto et ma position
    func distance(of coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return currentLocation?.distance(from: location) ?? Double.infinity
    }
    
    //Récupération de l'adresse à partir des coordonnées
    
    //func getAddressFromCoord(location: CLLocation) {
    func getAddressFromCoord(location: CLLocation, completion:@escaping (String)->()) {
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            let address = self.processResponse(withPlacemarks: placemarks, error: error)
            completion(address)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> String {
        var returnAddress = ""
        if let error = error {
            returnAddress = "Unable to Reverse Geocode Location (\(error))"
            //locationLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                if let address = placemark.compactAddress {
                    returnAddress = address
                }
            } else {
                returnAddress = "No Matching Addresses Found"
            }
        }
        return returnAddress
    }
}

//Récupération des infos détaillées de l'adresse pour l'affichage
extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            //            if let street = thoroughfare {
            //                result += ", \(street)"
            //            }
            if let cp = postalCode {
                result += ", \(cp)"
            }
            if let city = locality {
                result += " \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}








