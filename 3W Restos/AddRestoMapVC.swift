//
//  AddRestoMapVC.swift
//  3W Restos
//
//  Created by Serge Sahaguian on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddRestoMapVC: UIViewController {
    
    var model: ModelController!
    
    var addressSelected = ""
    lazy var geocoder = CLGeocoder()
    
    var newPosition: Position?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationView: UIImageView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationView.layer.cornerRadius = 7
        mapView.delegate = self
        
        let myPosition = model.getCurrentLocation().coordinate
        centerMap(at: myPosition)
        //mapView.addAnnotation(NewRestoAnnotation(coordinate: myPosition))
        
        let lat = Double(myPosition.latitude)
        let lng = Double(myPosition.longitude)
        
        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)
        refreshAddress(location: location)
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSaveResto" { //presentSaveResto est le nom du segue
            if let saveResto = segue.destination as? SaveRestoVC {
                saveResto.model = model
                saveResto.addressSelected = addressSelected
                saveResto.newPosition = newPosition
            }
        }
    }

    
    func refreshAddress(location: CLLocation) {
        newPosition = Position(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        model.getAddressFromCoord(location: location) { (result) in
            self.addressSelected = result
            self.addressLabel.text = result
        }
    }
    
    //MARK: - private func
    private func centerMap(at coordinate: CLLocationCoordinate2D) {
        mapView.setRegion(getRegionMap(at: coordinate), animated: false)
    }
}

//MARK: - NewRestoAnnotation

//class NewRestoAnnotation: NSObject, MKAnnotation {
//    let newRestoCoord: CLLocationCoordinate2D
//    
//    init(coordinate: CLLocationCoordinate2D) {
//        self.newRestoCoord = coordinate
//        super.init()
//    }
//    
//    var coordinate: CLLocationCoordinate2D {
//        return newRestoCoord
//    }
//}

extension AddRestoMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //recupère les coordonnées du centre de la mapView
        //print(mapView.centerCoordinate)
        let lat = mapView.centerCoordinate.latitude
        let lng = mapView.centerCoordinate.longitude
        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)
        refreshAddress(location: location)
    }
}








