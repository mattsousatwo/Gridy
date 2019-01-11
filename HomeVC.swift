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
        processPicked(image: randomImage())
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        displayMediaLibrary(source: .camera)
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        displayMediaLibrary(source: .photoLibrary)
    }
    
    
    // Pick Random Local Image
    
    // Gloabal array of images
    var localImages = [UIImage].init()
    
    // collect local images
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["Gridy-Boats", "Gridy-Car", "Gridy-Crocodile", "Gridy-Park", "Gridy-TShirts"]
        
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
    
    //  func for view configuration - treat as after view did load
    func configure() {
        collectLocalImageSet()
    }
    
    // randomize image selection
    func randomImage() -> UIImage? {
        
        let currentImage = imageHolder
        
        if localImages.count > 0 {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                if newImage != currentImage {
                    print("local images full - return image")
                    return newImage
                }
            }
        }
        print("randomImage() -> return nil")
        troubleAlertMessage(message: "There are no local images to be randomized")
        return nil
    }
    
  
    
    
    // Display Camera || Photo Library 
    func displayMediaLibrary(source: UIImagePickerController.SourceType) {
        let sourceType = source
        
        let permissionMessage = [
            "photos" : "Gridy does not have access to use your photos. Please go to Settings>Gridy>Photos on your device to allow Gridy to use your photo library.",
            "camera" : "Gridy does not have access to use your camera. Please go to Settings>Gridy>Camera on your device to allow Gridy to use your Camera."]
        
        switch sourceType {
        case .photoLibrary:
            
            // checking if our source type is avalible
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                // access the current permission status of photo library
                let status = PHPhotoLibrary.authorizationStatus()
                
                switch status {
                // .notDetermined - user never asked to use Photo Library befrore
                case .notDetermined:
                    // then request photo library acess permission
                    PHPhotoLibrary.requestAuthorization({ (newStatus) in
                        if newStatus == .authorized {
                            // if accepted display imagePicker
                            self.presentImagePicker(sourceType: sourceType)
                        } else {
                            // else display message
                            self.troubleAlertMessage(message: permissionMessage["photos"])
                        }
                    })
                case .authorized:
                    self.presentImagePicker(sourceType: sourceType)
                    
                case .denied, .restricted: // case no or never, display message
                    self.troubleAlertMessage(message: permissionMessage["photos"])
                }
                
            }
                
            else { // else if UIImagePickerController photo Library source type is not avalible then print message alert controller
                troubleAlertMessage(message: permissionMessage["photos"])
            }
            
        case .camera:
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                
                
                switch status {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                        if granted {
                            self.presentImagePicker(sourceType: sourceType)
                        } else {
                            self.troubleAlertMessage(message: permissionMessage["camera"])
                        }
                    })
                case .authorized:
                    self.presentImagePicker(sourceType: sourceType)
                case .denied, .restricted:
                    self.troubleAlertMessage(message: permissionMessage["camera"])
                }
            }
            else {
                troubleAlertMessage(message: permissionMessage["camera"])
            }
            
        case .savedPhotosAlbum:
            break
        }
    }
    
    
    //  Present Image Picker
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Temporary Image storage
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
        
        // Present next view Controller 
        performSegue(withIdentifier: "HomeToImageEditor", sender: self)
        
    }
    
    // Present Trouble Alert Message Controller
    func troubleAlertMessage(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    
    
// information we need to send to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! ImageEditorView
        
        if segue.identifier == "RandomToImageEditor" {
        // sending our selected image to a variable in the nextVC to be assigned to the nextVCs UIImageView
       nextVC.imageHolder2 = randomImage()!
            
        }
        
        if segue.identifier == "HomeToImageEditor" {
        
            nextVC.imageHolder2 = imageHolder
        
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    
    }
    
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
    }

    

}
