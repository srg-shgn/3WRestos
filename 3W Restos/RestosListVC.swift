//
//  RestosList.swift
//  3W Restos
//
//  Created by Serge Sahaguian on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit

class RestosListVC: UIViewController {
    
    var model: ModelController!
    //var delegate: RestosListVCDelegate?
    var dataSource: RestosTableViewDataSource?
    
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //model = delegate?.getModel()
        dataSource = RestosTableViewDataSource(model: model)
        tableView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetails" { //presentDetails est le nom du segue
            if let restoDetailVC = segue.destination as? RestoDetailVC {
                guard let index = tableView.indexPathForSelectedRow?.row else { return }
                restoDetailVC.localResto = model.restaurants[index]
                restoDetailVC.model = model
            }
        } else if segue.identifier == "presentMap" { //presentMap est le nom du segue
            if let restoMapVC = segue.destination as? RestoMapVC {
                restoMapVC.model = model
            }
        }
    }
    
    func refresh() {
        model.refreshRestaurants() { (result) in
            DispatchQueue.main.async {
                switch result {
                case false : print("Error !!!")
                case true:
                    print("Success in RestoListVC!!!")
                }
            }
        }
    }
}


//protocol RestosListVCDelegate {
//    func getModel() -> ModelController
//}

// MARK: - Data Source

class RestosTableViewDataSource: NSObject, UITableViewDataSource {
    let model: ModelController
    
    init(model: ModelController) {
        self.model = model
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestoCell.identifier, for: indexPath) as! RestoCell
        let resto = model.restaurants[indexPath.row]
        cell.configure(with: resto)
        return cell
    }
    
}

// MARK: - Cell

class RestoCell: UITableViewCell {
    static let identifier = "RestoCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var restoImageView: UIImageView!
    
    func configure(with resto: Restaurant) {
        nameLabel.text = resto.name
        priceLabel.text = "\(resto.price)"
        descriptionLabel.text = resto.description
        if let dist = resto.distance {
            distanceLabel.text = "\(Int(dist)) m"
        } else {
            distanceLabel.text = ""
        }
        //Recupère l'image du resto stockée dans le storage de Firebase
        
        restoImageView.image = UIImage(named: "restaurant-1")
        
        let imageRestoUrl = resto.imageUrl
        print("*** imageRestoUrl ***")
        print(imageRestoUrl)
        let url = URL(fileURLWithPath: imageRestoUrl)
        print("*** URL DEBUT***")
        print(url)
        print("*** URL FIN ***")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("*** error ***")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("WebServiceError.badRequest")
                return
            }
            let statusCode = response.statusCode
            print("*** response ***")
            print("statusCode = \(statusCode)")
            DispatchQueue.main.async {
                self.restoImageView.image = UIImage(data: data!)
                print("*** data ***")
                print(data!)
            }
        }.resume()

    }
}

