//
//  ModelController.swift
//  3W Restos
//
//  Created by etudiant04 on 17/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ModelController {
    
    var restaurants = [Restaurant]()
    var restaurantsSortedByDistance = [Restaurant]()
    
    private let restaurantService = RestaurantService()
    private let locationService = LocationService()

    func addNewRestaurant(name: String, address: String, price: String, description: String, position: Position, restoImage: UIImage) {
        restaurantService.addNewRestaurant(name: name, address: address, price: price, description: description, position: position, restoImage: restoImage)
     }
    
    func refreshRestaurants(completion: @escaping (Bool)->()) {
        restaurantService.getRestaurants(for: "restaurants") { result in
            var listResto = [Restaurant]()
            for var item in result {
                item.distance = self.distance(of: item.position.coordinate)
                listResto.append(item)
            }
            //self.restaurants = result
            //ci dessous, on trie par distance
            listResto = listResto.sorted(by: self.byDistance)
            self.restaurants = listResto
            completion(true)
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        return locationService.currentLocation!
    }
    
    func getAddressFromCoord(location: CLLocation, completion: @escaping (String) -> () ) {
        locationService.getAddressFromCoord(location: location) {(result: String) in
            completion(result)
        }
    }
    
    //MARK: - Private functions
    private func distance(of: CLLocationCoordinate2D) -> CLLocationDistance {
        return locationService.distance(of: of)
    }
    
    private func byDistance(_ resto1: Restaurant, _ resto2: Restaurant) -> Bool {
        return Int(resto1.distance!) < Int(resto2.distance!)
    }
}


















