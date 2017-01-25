//
//  SaveRestoVC.swift
//  3W Restos
//
//  Created by Serge Sahaguian on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit

class SaveRestoVC: UIViewController {

    var model: ModelController!
    var addressSelected: String!
    var newPosition: Position!
    
    @IBOutlet weak var priceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var descriptionTF: UITextView!
    
    @IBAction func pressSave(_ sender: UIBarButtonItem) {
        print(priceSegmentedControl.selectedSegmentIndex)
        var price: String
        switch priceSegmentedControl.selectedSegmentIndex {
        case 0:
            price = "€"
        case 1:
            price = "€€"
        case 2:
            price = "€€€"
        default:
            price = "€"
        }
    
        if (nameTF.text?.characters.count)! < 1 {
            return
        }
        if (descriptionTF.text?.characters.count)! < 1 {
            return
        }
        let name = nameTF.text
        let description = descriptionTF.text
        print("*** POSITION ***")
        print(newPosition)
        model.addNewRestaurant(name: name!, address: addressSelected, price: price, description: description!, position: newPosition)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adressTF.text = addressSelected
    }
    

}
