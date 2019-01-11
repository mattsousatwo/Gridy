//
//  ImageEditorView.swift
//  Gridy
//
//  Created by Matthew Sousa on 12/31/18.
//  Copyright © 2018 Matthew Sousa. All rights reserved.
//

import UIKit

class ImageEditorView: UIViewController, UIGestureRecognizerDelegate {

    // image variable holder to store a picked Image from the previous window
    var imageHolder2 = UIImage()
    
    // UIImageView outlet
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // UIImage in top right corner - cancel editing and go to previous view
    @IBOutlet weak var cancelButton: UIImageView!
    
    
    
    
    // Start Button - Slice Image and go to next view
    @IBAction func startButton(_ sender: Any) {
        print("start button pressed")
        
    }
    
    
    // storing inital position of image in selectedImageView as a variable
    var initalImageViewOffset = CGPoint()
    
    // Allowing the image in selectedImageView to move
    // setting functionality for pan gesture recognizer in selectedImageView
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        print("moving")
        
        // storing the value of the user moving the selectedImageView as a CGPoint value
        let translation = sender.translation(in: selectedImageView)
        
        // if gesture recognizer touches began
        if sender.state == .began {
            
            initalImageViewOffset = selectedImageView.frame.origin
            
        }
        
        // adding user panning as a CGPoint Value
        let position = CGPoint(x: translation.x + initalImageViewOffset.x - selectedImageView.frame.origin.x, y: translation.y + initalImageViewOffset.y - selectedImageView.frame.origin.y)
        
        // declaring image to transform by user panning.x and user panning.y
        selectedImageView.transform = selectedImageView.transform.translatedBy(x: position.x, y: position.y )
        
    }
    
    
    // allowing the image in selectedImageView to rotate
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        print("rotating")
        
        // transforming selectedImageView by users rotation value
        selectedImageView.transform = selectedImageView.transform.rotated(by: sender.rotation)
        
        // reseting the rotation value to 0 ( default )
        // so that when the user decides to rotate again, we are only applying a the new rotation value
        sender.rotation = 0
    }
    
    // allowing scaling to image in selectedImageView
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        print("scaling")
        
        // scaling selectedImageView by users scaling value
        selectedImageView.transform = selectedImageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        // reseting scaling value to 1 ( default )
        // so that when the users decides to scale the image again, we are only applying the new scaling value
        sender.scale = 1
    }
    
    // simultanious gesture recognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // if gestureRecognizer is not applied to selectedImageView -> do not execute
        if gestureRecognizer.view != selectedImageView {
            return false
        }
        
        // if gestureRecognizer Pan or Tap Gesture -> do not execute
        if gestureRecognizer is UITapGestureRecognizer || otherGestureRecognizer is UITapGestureRecognizer || gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        
        // if gestureRecognizer is applied to selectedImageView then execute simultanious gestures
        return true
    }
    
    func configureImageEditorView() {
        
        // assigning selected || taken photo to the imageView
        selectedImageView.image = imageHolder2
        
    // ADDED - 1/9/19 ~ enable gestures on view
        selectedImageView.isUserInteractionEnabled = true 
        
        // pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        // adding pan gesture to selectedImageView
        selectedImageView.addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.delegate = self
        
        // rotate gesture recognizer
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        // add rotate gesture to selectedImageView
        selectedImageView.addGestureRecognizer(rotationGestureRecognizer)
        // setting gesture rescognizer delegate to self
        rotationGestureRecognizer.delegate = self
        
        // pinch gesture recognizer
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        // add pinch gesture to selectedImageView
        selectedImageView.addGestureRecognizer(pinchGestureRecognizer)
        // set pinch gesture delegate to self
        pinchGestureRecognizer.delegate = self
       
        // enable gestures in image
        cancelButton.isUserInteractionEnabled = true 
        
        // Tap Gesture Recognizer being set to cancelButton
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelEditing(_:)))
        // add tap gesture to cancel Button
        cancelButton.addGestureRecognizer(tapGestureRecognizer)
        // set tap gesture delegate to self
        tapGestureRecognizer.delegate = self 
 
        
    }
    
    // remove image from selectedImageView
    func removeSelectedImage() {
        selectedImageView.image = nil
    }
    
    // go to HomeViewController
    func goToHomeViewController() {
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // allowing scaling to image in selectedImageView
    @objc func cancelEditing(_ sender: UITapGestureRecognizer) {
        print("cancel Editing")
        
        removeSelectedImage()
        
        goToHomeViewController()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageEditorView()
        
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

