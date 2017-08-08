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
    
    @IBOutlet weak var restoImage: UIImageView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBAction func pressAddImage(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func pressSave(_ sender: UIBarButtonItem) {
        
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
            buildAlert(msg: "Merci d'entrer un nom !")
            return
        }
        if (descriptionTF.text?.characters.count)! < 1 {
            buildAlert(msg: "Merci d'entrer une description !")
            return
        }
        let name = nameTF.text
        let description = descriptionTF.text
        
        if let myImage = restoImage.image {
            model.addNewRestaurant(name: name!, address: addressSelected, price: price, description: description!, position: newPosition, restoImage: myImage)
        } else {
            buildAlert(msg: "Merci d'ajouter une photo !")
            return
        }
        
        let restoListVC = self.storyboard?.instantiateViewController(withIdentifier: "restoListID") as! RestosListVC
        restoListVC.model = self.model
        //on utilse la méthode ci dessous qui demande au NavigationController de charger restoListVC
        self.navigationController?.show(restoListVC, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adressTF.text = addressSelected
    }
    
    private func buildAlert(msg: String) {
        let alertController = UIAlertController(title: "message de 3W Restos", message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SaveRestoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true //affiche l'édireur d'image
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as! UIImage? {
            //on a une editedImage si o a croppé l'image dans l'éditeur
            selectedImageFromPicker = editedImage
        } else if let orignalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage? {
            selectedImageFromPicker = orignalImage
        }
        if let selectedImage = selectedImageFromPicker {
            restoImage.image = selectedImage
        }
        addImageBtn.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}






