//
//  StartVC.swift
//  3W Restos
//
//  Created by etudiant04 on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    var model = ModelController()
    
    @IBOutlet weak var restosBtn: UIButton!
    
    @IBAction func pressAddResto() {
        for index in 1...20 {
//            let name = "Resto \(index)"
//            let address = "\(index) rue René CLair, 75012 paris"
//            let description = "cuisine traditionelle \(index)"
//            let newPosition = Position(lat: 48.8935+(Double(index)/10000.0), lon: 2.3528+(Double(index)/1000.0))
            //model.addNewRestaurant(name: name, address: address, price: "€", description: description, position: newPosition)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    func refresh() {
        model.refreshRestaurants() { (result) in
            DispatchQueue.main.async {
                switch result {
                case false : print("Error !!!")
                case true:
                    print("Success !!!")
                    self.restosBtn.isEnabled = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentListRestos" { //presentListRestos est le nom du segue
            //if let restosListVC = segue.destination as? RestosListVC {
            //si on navigue vers un navigationCOntroller il faut ajouter if let navigation = segue.destination as? UINavigationController
            //ci dessous, le if s'applique aux 2 expressions
            // navigation.topViewController permet de pointer sur la 1ere view du UINavigationController
            if let navigation = segue.destination as? UINavigationController, let restosListVC = navigation.topViewController as? RestosListVC {
                //restosListVC.delegate = self
                restosListVC.model = model
            }
        }
    }
}

//extension StartVC: RestosListVCDelegate {
//    func getModel() -> ModelController {
//        return model
//    }
//}

