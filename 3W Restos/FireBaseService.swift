//
//  bddManagement.swift
//  3W Restos
//
//  Created by etudiant04 on 17/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import Foundation
import Firebase

//import FirebaseStorage

class FireBaseService {
    var ref: FIRDatabaseReference!
    
    init() {
        FIRApp.configure()
        //ref est ma table wrestos-4658b visible sur mon compte firebase
        ref = FIRDatabase.database().reference()
    }
    
    func addNewRestaurant(name: String, address: String, price: String, description: String, position: Position) {
        let restaurants = ref.child("restaurants").childByAutoId()
        restaurants.child("name").setValue(name)
        restaurants.child("image").setValue("")
        restaurants.child("address").setValue(address)
        restaurants.child("price").setValue(price)
        restaurants.child("position").child("lon").setValue(position.lon)
        restaurants.child("position").child("lat").setValue(position.lat)
        restaurants.child("description").setValue(description)
    }
    
    func uploadImageResto() {
//        let refStorage = FIRStorage
    }
    
    
    /*
    //func ci dessous est asynchrone => va envoyer une variable de type [Restaurant] via l'argument "completion"
    func getRestaurants( completion : @escaping ([Restaurant]) -> () ) {
        //observe toute la bdd
        //let refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
        //Observe uniquement le noeud restaurants
        let refHandle = ref.child("restaurants").observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : Any] ?? [:]
            //on convertit [String: [String:Any]] en [Restaurant]
            //la closure ci dessous appelle la fonction "init" de Restaurant qui attend 1 argument String et 1 argument [String:Any]
            let restos = postDict.map({ Restaurant.init(id: $0.key, value: $0.value as! [String : Any])}) as! [Restaurant]
            completion(restos)
        })
    }
    */
    
    //func asynchrone qui va envoyer à l'appelant, la variable "postDict" de type [String : Any]
    func getResource(at path: String, completion:@escaping ([String : Any])->()) {
        //observe toute la bdd
        //let refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
        //Observe uniquement le noeud path ("restaurants" ou commentaires"
        let refHandle = ref.child(path).observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : Any] ?? [:]
            completion(postDict)
        })
    }
}





