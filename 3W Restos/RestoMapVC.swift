//
//  RestoMapVC.swift
//  3W Restos
//
//  Created by Serge Sahaguian on 19/01/2017.
//  Copyright © 2017 3wa. All rights reserved.
//

import UIKit
import MapKit

class RestoMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var model:ModelController!
    var selectedResto: Restaurant?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //on utilise le delegate pour accéder à plus de func de mapView
        //il faut ajouter le protocol MKMapViewDelegate à la classe
        mapView.delegate = self
        
        //si selected resto nil, j'affiche tous les resto et je centre map sur currentLocation
        //si selected resto not nil, j'affiche le resto sélectionné et je centre map sur ses coordonnées
        if let myResto = selectedResto {
            centerMap(at: myResto.position.coordinate)
            //on affiche le resto selectionné
            mapView.addAnnotation(RestoAnnotation.init(resto: myResto))
        } else {
            //on centre sur currentLocation et on affiche tous les restos
            let myPosition = model.getCurrentLocation().coordinate
            centerMap(at: myPosition)
            //On affiche tous les restos
            mapView.addAnnotations(model.restaurants.map(RestoAnnotation.init))
        }
        
        mapView.showsUserLocation = true
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentAddMap" { //presentAddMap est le nom du segue
            if let addRestoMapVC = segue.destination as? AddRestoMapVC {
                addRestoMapVC.model = model
            }
        }
    }
    
    //MARK: - PRIVATE FUNC
    
    private func centerMap(at coordinate: CLLocationCoordinate2D) {
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        mapView.setRegion(region, animated: false)
        mapView.setRegion(getRegionMap(at: coordinate), animated: false)
    }
}

//MARK: - RestoAnnotation

class RestoAnnotation: NSObject, MKAnnotation {
    let resto: Restaurant
    
    init(resto: Restaurant) {
        self.resto = resto
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return resto.position.coordinate
    }
    
    var title: String? {
        return resto.name
    }
    
    var subtitle: String? {
        var distance = ""
        if let dist = resto.distance {
            distance = "\(Int(dist))"
        }
        return "\(resto.price) - \(distance) m"
    }
}

//MARK: - MKMapViewDelegate

extension RestoMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestoAnnotation else { return nil }
        let backButton = UIButton(type: .system)
        backButton.setTitle(">", for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let annotationView: MKPinAnnotationView
        if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: "restaurant") as? MKPinAnnotationView {
            annotationView = reusedView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "restaurant")
            annotationView.canShowCallout = true //autorise l'affichage de l'annotation
            //annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.system)
            //un UIButton est une vue
            annotationView.rightCalloutAccessoryView = backButton
            //annotationView.detailCalloutAccessoryView //view en bas de l'annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //On downcast en RestoAnnotation pour accéder à la propriéte resto de l'annotation
        let restoAnnotation = view.annotation as! RestoAnnotation
        let idResto = restoAnnotation.resto.idRestaurant
        //let restoDetailVC = restoDetailVC() //cette méthode d'instanciation, ne permet pas de récupérer les éléments graphique du storyboard
        //du coup, on utilisera la fonction ci dessous qui crée une instance de notre objet à partir de la version du storyboard
        //NE PAS OUBLIER DE DOWNCASTER EN RestoDetailVC pour accéder à ses propriétés
        let restoDetailVC = storyboard?.instantiateViewController(withIdentifier: "restoDetailID") as! RestoDetailVC
        restoDetailVC.model = model
        restoDetailVC.localResto = getResto(with: idResto)
        
        //self.present(restoDetailVC, animated: true, completion: nil) //cette méthode de chargement de l'écran restoDetailVC ne conserve pas les proriétés du NavigationController
        //du coup on va utilser la méthode ci dessous qui demande au NavigationController de charger restoDetailVC
        self.navigationController?.show(restoDetailVC, sender: self)
    }
    
    private func getResto(with id: String) -> Restaurant {
        for restoItem in model.restaurants {
            if restoItem.idRestaurant == id {
                return restoItem
            }
        }
        //si ne trouve pas, retourne le 1er resto de la liste
        return model.restaurants[0]
    }
}



