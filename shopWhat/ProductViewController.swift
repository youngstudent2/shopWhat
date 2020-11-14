//
//  ProductViewController.swift
//  shopWhat
//
//  Created by youngstudent2 on 2020/11/8.
//  Copyright © 2020 youngstudent2. All rights reserved.
//

import UIKit
import os.log
class ProductViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var name_text: UITextField!
    @IBOutlet weak var comment_text: UITextField!
    @IBOutlet weak var photo_image: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    var product:Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        name_text.delegate = self
        
        if let product = product {
            navigationItem.title = product.name
            name_text.text = product.name
            photo_image.image = product.photo
            ratingControl.rating = product.rating
            comment_text.text = product.comment
        }
        
        updateSaveButtonState()
        
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddProductMode = presentingViewController is UINavigationController
        if isPresentingInAddProductMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ProductViewController is not inside a navigation controller.")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    private func updateSaveButtonState() {
        let text = name_text.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        print("tap to select image")
        // Hide the keyboard

        name_text.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following:\(info)")
        }
        photo_image.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling",log:OSLog.default,type:.debug)
            return
        }
        
        let name = name_text.text ?? ""
        let photo = photo_image.image
        let rating = ratingControl.rating
        
        product = Product(name: name, photo: photo, rating: rating)
        
        
    }
    
    
}

