//
//  Entities.swift
//  3W Restos
//
//  Created by etudiant04 on 17/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation
import CoreLocation

struct Position {
    let lat: Double, lon: Double
}

extension Position {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct Restaurant {
    let idRestaurant: String
    let name: String
    let address: String
    let imageUrl: String
    let price: String
    let position: Position
    let description: String
    var distance: Double? = nil
}


extension Restaurant {
    
    init?(id: String, value: [String: Any]) {
        
        let id = id as String
        guard let name = value["name"] as? String,
            let imageUrl = value["imageUrl"] as? String,
            let address = value["address"] as? String,
            let price = value["price"] as? String,
            let position = value["position"] as? [String:Double],
            let lat = position["lat"],
            let lon = position["lon"],
            let description = value["description"] as? String
            else {
                return nil
        }
        self.idRestaurant = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
        self.price = price
        self.position = Position(lat: lat, lon: lon)
        self.description = description
    }
}
