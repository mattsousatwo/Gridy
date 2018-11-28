//
//  HomeVC.swift
//  Gridy
//
//  Created by Matthew Sousa on 11/28/18.
//  Copyright © 2018 Matthew Sousa. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class HomeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   
    @IBAction func randomPickButton(_ sender: Any) {
        print("Choosing Random Photo")
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        displayLibrary()
        
    }
    
    
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissonMessage = "Gridy does not have access to your photo library. Please go to Settings to allow Gridy to access your photo library."
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlertMessage(message: noPermissonMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
                
            case .denied, .restricted:
                self.troubleAlertMessage(message: noPermissonMessage)
            }
        }
            
        else {
            troubleAlertMessage(message: "Please go to Settings to allow Gridy to access your photos.")
        }
    }
    
    
    //  Present Image Picker
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    var imageHolder = UIImage()
    
    // Safely unwrapping our image to a variable to be brought over to next view
    func processPicked(image: UIImage?) {
        if let newImage = image {
            imageHolder = newImage
           
        }
    }
    
    
    
    // Dismissing and assining UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // do after image is selected
        
        // dismissing our UIImagePickerController
        picker.dismiss(animated: true, completion: nil)
        
        // Type casting new selected image as UIImage
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        // Using processPicked to safely unwrap our selected image to our UIImageView
        processPicked(image: newImage)
        
        performSegue(withIdentifier: "HomeToFraming", sender: self)
        
    }
    
    // Present Trouble Alert Message Controller
    func troubleAlertMessage(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        
        
        // Present Next View Controller -> Giving us an issue of presenting view before imageHolder has added an image to selectedImageView
        present(alertController, animated: true)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToFraming" {
            let nextVC = segue.destination as! FramingVC
            
           // giving us an error because imageHolder is not presenting an image before the view is presented 
            nextVC.selectedImageView.image = imageHolder
            
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
