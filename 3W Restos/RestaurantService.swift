//
//  RestaurantService.swift
//  3W Restos
//
//  Created by etudiant04 on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation

class RestaurantService {
    let fbService = FireBaseService()

    
    //va envoyer à l'appelant la variable "restos" de type [Restaurant]
    func getRestaurants(for node: String, completion: @escaping ([Restaurant]) -> () ) {
        fbService.getResource(at: "restaurants") { (result: [String: Any]) in
            //convertit le tableau de type [String: Any] (plus exactement [String:[String:Any]])  en [Restaurant]
            let restos = result.flatMap({ Restaurant.init(id: $0.key, value: $0.value as! [String : Any] )})
            completion(restos)
        }
    }
    
    func addNewRestaurant(name: String, address: String, price: String, description: String, position: Position) {
        fbService.addNewRestaurant(name: name,address: address, price: price, description: description, position: position)
    }
}
