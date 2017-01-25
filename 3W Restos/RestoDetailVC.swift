//
//  RestoVC.swift
//  3W Restos
//
//  Created by Serge Sahaguian on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit

class RestoDetailVC: UIViewController {
    
    var model: ModelController!
    var localResto:Restaurant!
    
    @IBOutlet weak var imageResto: UIImageView!
    
    @IBOutlet weak var restoName: UILabel!
    @IBOutlet weak var restoPrice: UILabel!
    @IBOutlet weak var restoAddress: UILabel!
    @IBOutlet weak var restoDescription: UILabel!
    @IBOutlet weak var restoDistance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshUI()
    }
    
    func refreshUI() {
        print(localResto)
        if let resto = localResto {
            restoName.text = resto.name
            restoPrice.text = resto.price
            restoAddress.text = resto.address
            restoDescription.text = resto.description
            if let dist = resto.distance {
                restoDistance.text = "\(Int(dist)) m"
            } else {
                restoDistance.text = ""
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetailMap" { //presentDetailMap est le nom du segue
            if let restoMapVC = segue.destination as? RestoMapVC {
                guard let selectedResto = localResto else { return }
                restoMapVC.selectedResto = selectedResto
                restoMapVC.model = model
            }
        }
    }

}


