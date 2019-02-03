//
//  PlayFieldViewController.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/11/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit

class PlayFieldViewController: UIViewController, UIGestureRecognizerDelegate {

// variables
    // slicing class
    let slicing = Slicing()
    
    let gameStructure = GameStructure()
   
    var imageArray: [[UIImage]] = []
    
    // choosing game mode - false (moves), true (timed)
    var timeMode: Bool = false 
    
    // variable to store the initial point an image was set to
    var initialImageViewOffset = CGPoint()
    
// Outlets
    // Hint Button Outlet
    @IBOutlet weak var hintButton: UIImageView!
    
    // Game Mode Label - moves or time
    @IBOutlet weak var gameModeLabel: UILabel!
    
    // Game Value - Moves made counter || Timer Countdown
    @IBOutlet weak var modeValue: UILabel!
    
    
    
    

    // new game button
    @IBAction func newGameButton(_ sender: Any) {
        print("New Game Button Pressed")
        
    // removing sliced images from slicedImagesArray
        slicing.removeImages(from: &imageArray)
    }
    
    // added slicedImages to this outlet collection
    @IBOutlet var slicedTiles: [UIView]!
    
    
 
    // if user moves a tile, have that tile be scaled to the size of the square on the grid (UIView) [ 54 pts -> 87 pts ]
    
    
   
    // Hint Button
    @objc func showHint(_ sender: UITapGestureRecognizer) {
        print("Show Hint")
    }
    
    
    
    
// Functions
  
    
    
    // array to take in a range (of views) and an array of [UIImages] and then draw an image from the array to the selected views in range + ADD UIGESTURE
    func inputSlicesRange(from lowInt: Int,to maxInt: Int , with array: [UIImage]) {
        
        for x in lowInt...maxInt {
            print("adding image for viewWithTag(\(x))")
            
            if let slice = view.viewWithTag(x) {
                
                //  let image = array[x - lowInt]
                let image = array[x - lowInt]
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: slicing.getXViewPosition(from: slice), y: slicing.getYViewPosition(from: slice), width: 54, height: 54)
                self.view.addSubview(imageView)
                self.view.bringSubviewToFront(imageView)
                addGestures(view: imageView)
                
            }
            
        }
        
    }
    
    
    func addGestures(view: UIImageView) {
        //        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(draggableView(_:)))
        print("addGestures(view: UIImageView)\n")
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        view.isUserInteractionEnabled = true
    }
    
    
    @objc func draggableView(_ gesture: UIPanGestureRecognizer) {
        print("dragging")
        
        // let draggableTile = view gesture was recognized in else exit
        guard let draggableTile = gesture.view else { return }
        
        let translation = gesture.translation(in: draggableTile)
        
        if gesture.state == .began {
            
            initialImageViewOffset = draggableTile.frame.origin
            
            // scale image
            UIView.animate(withDuration: 0.1, animations: {draggableTile.transform.scaledBy(x: 83.5, y: 83.5)})
        
        }
        
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - draggableTile.frame.origin.x, y: translation.y + initialImageViewOffset.y - draggableTile.frame.origin.y)
        
        draggableTile.transform = draggableTile.transform.translatedBy(x: position.x, y: position.y)
        
        
        // add tile to view
        if gesture.state == .ended {
            
            let targetView = view.viewWithTag(17)!

            if draggableTile.frame.intersects(targetView.frame) {
                
            
                let backgroundImage: UIImageView = UIImageView(frame: draggableTile.bounds)
                backgroundImage.clipsToBounds = true
                backgroundImage.contentMode = .scaleAspectFit
                targetView.addSubview(draggableTile)
                
                
                
              //  targetView.addSubview(draggableTile)
                print("adding subview/n")
                    
            
            }
            
        }
        
    }
    
    

    
    
    // set gestures
    func configurePlayField() {
        print("configuring PlayField \n")
      
    
        inputSlicesRange(from: 1, to: 4, with: imageArray[0])
        inputSlicesRange(from: 5, to: 8, with: imageArray[1])
        inputSlicesRange(from: 9, to: 12, with: imageArray[2])
        inputSlicesRange(from: 13, to: 16, with: imageArray[3])
        
        // finally got the data to pass 
        print("   print imageArray.count - \(imageArray.count)")
        
        print("   print imageArray[0].count - \(imageArray[0].count) \n")
        
        // presenting Image to UIImageView of slicedArrays
//        slice.createNewImage(with: slice.slicedImageArray, from: playFieldImage)
        
        
        // Tap Gesture Recognizer being set for hintButton
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showHint(_:)))
        // add tap gesture to hint  button
        hintButton.addGestureRecognizer(tapGestureRecognizer)
        // set tap gesture delegate to self
        tapGestureRecognizer.delegate = self
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePlayField()
       
        gameStructure.displayGameMode(to: timeMode, label: gameModeLabel, value: modeValue)
        
        
        
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
