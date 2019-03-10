//
//  ImageEditorView.swift
//  Gridy
//
//  Created by Matthew Sousa on 12/31/18.
//  Copyright © 2018 Matthew Sousa. All rights reserved.
//

import UIKit

class ImageEditorView: UIViewController, UIGestureRecognizerDelegate {

    // slicing class 
    var slice = Slicing()
    
    // selecting game mode
    var timerMode: Bool = false 
    
    // image variable holder to store a picked Image from the previous window
    var imageHolder2 = UIImage()
    
    // imageArra to store sliced Images 
    var imageArray: [[UIImage]] = []
    
    // variable to store image to go to next view for hint button
    var gameImage = UIImage()
    
    // background image / grid
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // UIImageView outlet
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // UIImage in top right corner - cancel editing and go to previous view
    @IBOutlet weak var cancelButton: UIImageView!
    
    // UILabel to describe the view
    @IBOutlet weak var directionsString: UILabel!
    
    // startButton refrencing outlet
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    
    
    func hideButtons(_ booleanValue: Bool) {
        if booleanValue == true {
            backgroundImage.isHidden = true
            cancelButton.isHidden = true
            directionsString.isHidden = true
            startButtonOutlet.isHidden = true
        }
        else {
            backgroundImage.isHidden = false
            cancelButton.isHidden = false
            directionsString.isHidden = false
            startButtonOutlet.isHidden = false 
            
        }
        
        
    }
   
    

    
    // Start Button - Slice Image and go to next view
    @IBAction func startButton(_ sender: Any) {
        print("start button pressed")
        
       
        hideButtons(true)
        
        // take snapshot is offcentered 
        let screenshot = slice.takeSnapshot(from: selectedImageView)
        
      //   slice.takeScreenshot()
      //   let screenshot = slice.screenshotImage
        
        if let image = screenshot {
        gameImage = image
    
        }
        
        hideButtons(false)
        
        // slice image and assign images to imageArray
    //*** Will need to change this to new screenshot image instead of imageView as parameter [selectedImageView.image!]
        imageArray = slice.sliceImage(for: gameImage, row: 4, column: 4)
        
        
        
        
        chooseGameMode()
        
        
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
        
        // do not allow user interaction with backgtoundImage / grid
        backgroundImage.isUserInteractionEnabled = false
        
        // assigning selected || taken photo to the imageView
       selectedImageView.image = imageHolder2
        
    // ADDED - 1/9/19 ~ enable gestures on view
        selectedImageView.isUserInteractionEnabled = true 
        
        // pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        // adding pan gesture to selectedImageView
        selectedImageView.addGestureRecognizer(panGestureRecognizer)
        // set pan gesture delegate to self
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
    func removeCurrentImage() {
        print("removeCurrentImage \n")
        selectedImageView.image = nil
    }
    
    
    
    // go to HomeViewController
    func goToHomeViewController() {
        print("goToHomeViewController \n")
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // go to PlayFieldViewController
    func goToPlayFieldViewController() {
        print("goToPlayFieldViewController \n")
        self.performSegue(withIdentifier: "ImageEditorToPlayfield", sender: self)
    }
    
    // allowing scaling to image in selectedImageView
    @objc func cancelEditing(_ sender: UITapGestureRecognizer) {
        print("cancel Editing")
        
        // remove current image from selectedImageView
        removeCurrentImage()
        
        // go back to HomeViewController
        goToHomeViewController()
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add guestures, upload passed image to ImageView, enable/disable userInteraction
        configureImageEditorView()
        
       
    }
    
    func goToTimerMode() {
        // setting game mode to true (time)
        timerMode = true
        print("timed mode set")
        goToPlayFieldViewController()
    }
    
    
    func goToMovesMode() {
        // setting game mode to false (moves)
        timerMode = false
        print("moves mode set")
        goToPlayFieldViewController()
    }
    
    // add this func to alert controller displayable conditions     (button)
    func chooseGameMode() {
        let alertController = UIAlertController(title: "Choose Game Mode", message: nil, preferredStyle: .actionSheet)
        
        // Create UIAlertAction to add to Controller
        // for each UIAlertAction we need a title, style, and a handler, which we can use as a closure after the fisrt two parameters that will be executed after the action is called
        let customAction = UIAlertAction(title: "Moves", style: .default) { (action) in self.goToMovesMode()
        }
        
        let timerAction = UIAlertAction(title: "Timer", style: .default) { (action) in self.goToTimerMode()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in print("Cancel Action")
        }
        
        // Add Action to Controller
        alertController.addAction(customAction)
        
        alertController.addAction(timerAction)
        
        alertController.addAction(cancelAction)
        
        // Present View Controller
        present(alertController, animated: true) {
            // Code to be run after view is displayed
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageEditorToPlayfield" {
            let nextVC = segue.destination as! PlayFieldViewController
            
            nextVC.imageArray = imageArray
            nextVC.timeMode = timerMode
          //  nextVC.imageHolder3 = imageHolder2
            
           nextVC.imageHolder3 = gameImage
        }
    }
    
        
    
}
    



