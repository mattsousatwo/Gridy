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
    
    // image holder for image preview
    var imageHolder3 = UIImage()
    
    // imageView to hold Image
    let imageView = UIImageView()
    
    // View to hold preview Image
    let previewImageView = UIView()
    
    // tile size - W: 54, H: 54
    let tileSize = CGFloat(54)
    
    // Tile position container
    var initalTileLocations: [CGPoint] = []
    
// Outlets
    // Hint Button Outlet
    @IBOutlet weak var hintButton: UIImageView!
    
    // Game Mode Label - moves or time
    @IBOutlet weak var gameModeLabel: UILabel!
    
    // Game Value - Moves made counter || Timer Countdown
    @IBOutlet weak var modeValue: UILabel!
    
    // View Containing playfield grid 
    @IBOutlet weak var gridView: UIView!
    
    
    

    // new game button
    @IBAction func newGameButton(_ sender: Any) {
        print("New Game Button Pressed")
        
    // removing sliced images from slicedImagesArray
        slicing.removeImages(from: &imageArray)
        
        gameStructure.movesMade = 0 
    }
    
    // added slicedImages to this outlet collection
    @IBOutlet var initalTilesGrid: [UIView]!
    
    @IBOutlet weak var originalTilesCollection: UIView!
    
    
 
    // if user moves a tile, have that tile be scaled to the size of the square on the grid (UIView) [ 54 pts -> 87 pts ]

    
    // Hint Button
    @objc func showHint(_ sender: UITapGestureRecognizer) {
        // set game image to the preview imageView
        imageView.image = imageHolder3
        
        // add view
        self.view.addSubview(previewImageView)
        self.previewImageView.addSubview(imageView)
        // set frame
        self.previewImageView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width - 25, height: self.view.bounds.height - 50)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.previewImageView.bounds.width - 25, height: self.previewImageView.bounds.height - 25)
        // set background color
        self.previewImageView.backgroundColor = UIColor.black
        // center views
        self.imageView.center = self.previewImageView.center
        self.previewImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        
        self.view.bringSubviewToFront(self.previewImageView)
        
        // animate presentation in
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.previewImageView.center = self.view.center
        }) { (success) in }
        // animate presentation out
        UIView.animate(withDuration: 0.4, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.previewImageView.center = CGPoint(x: self.view.center.x + self.view.frame.width, y: self.view.center.y)
        }) { (success) in }
        
        
        
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
    
    
    
    func randomIntFrom(start: Int, to end: Int) -> Int {
        
        var lower = start
        var max = end
        
        if max < lower {
            swap(&max, &lower)
        }
        
       return Int(arc4random_uniform(UInt32(max - lower + 1))) + lower

    }
    
    
    
    
    
    
    var inputRange: [Int] = []
    var usedNumbers: [Int] = []
//    var counter: Int = 0
    
    // random numbers not working - repearing number - clause to fail doesn work 
    func randomPoint(from range: ClosedRange<Int>) -> Int {
    
    print(range)
        
       
        
        // appending number from range to inputRange array
        for number in range {
            inputRange.append(number)
        }
        
        var randomNumber = Int.random(in: inputRange.first!...inputRange.last!)
      
        
      
        // while previous number is equal to random number
            // append randomNumber to usedNumbers
            // randomize randomNumber
        for usedNumber in usedNumbers {
            while usedNumber == randomNumber {
                
                
                randomNumber = Int.random(in: inputRange.first!...(inputRange.last!))
            }
        }
        // set previous number to another randomNumber
       
        // if the amount of objects in usedNumbers is equal to the elements in initalTilesGrid (all the elements in initalTilesGrid have been cycled through)
            // remove all elements in usedNumbers
        if usedNumbers.count == range.count {
            print("\(usedNumbers.count) \(range.count)")
            usedNumbers.removeAll()
        }
        
//        if counter == 4 {
//            usedNumbers.removeAll()
//            print("used number count  = \(usedNumbers.count)")
//        }
//
        
        // return randomNumber
        print("return randomNumber:  \(randomNumber)")
        let chosenNumber = randomNumber
        // appending randomNumber as chosenNumber 
        usedNumbers.append(chosenNumber)
        
//        counter += 1
        
        return chosenNumber
    }
    
    
    
    
    
    
    // func to set the location of each Tile in the initalGridView
    func addInitalPositionsToContainer() {
        // tile location
        if initalTilesGrid.isEmpty == false {
            for subview in initalTilesGrid {
                
                let imagePosition = subview.frame.origin
                
                // view position + offset value
                let imageX = imagePosition.x + 6
                let imageY = imagePosition.y + 68
                
                let subviewPoint = CGPoint(x: imageX, y: imageY)
                
                print(subviewPoint)
               
                initalTileLocations.append(subviewPoint)
                
            }
            
            
            
        } else {
            print("initalTilesGrid has no subviews")
            }
            
    }
        
        
    
    
    
    
    
    
    func addTilesFromRange(from lowInt: Int, to maxInt: Int, with array: [UIImage] ) {
        
        let closedRange = lowInt...maxInt
        
        print(closedRange)
        
        for x in closedRange {
            print("adding tiles ")
            
            if let tilePosition = view.viewWithTag(x) {
        
                let image = array[x - lowInt]
                
                
                // tile frame as variable
//                let tileFrame = CGRect(x: slicing.getXViewPosition(from: tilePosition), y: slicing.getYViewPosition(from: tilePosition), width: tileSize, height: tileSize)
                
                
               // get random location for tile
                let randomLocation = randomPoint(from: closedRange)
                
                print("random location = \(randomLocation)")
                let tileLocation = initalTileLocations[randomLocation]
                print("tile location x: \(tileLocation.x), y: \(tileLocation.y)")
                
                let tileFrame = CGRect(x: tileLocation.x, y: tileLocation.y, width: tileSize, height: tileSize)
                
                
                // initalizing tile
                let tile = Tile(originalTileLocation: tileLocation, correctPosition: (x - 1), frame: tileFrame)
                
                tile.accessibilityLabel = String("\(x)")
                print("\n title.accessibilityLabel = \(tile.accessibilityLabel!)\n")
                
                
                
                // adding tile image
                tile.image = image
                
                tile.isUserInteractionEnabled = true
                self.view.addSubview(tile)
                self.view.bringSubviewToFront(tile)
                addGestures(view: tile)
                
                
                
            }
            
        }
    }
    
    
    
    
    
    func addGestures(view: UIImageView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDragger(_:)))
        print("addGestures(view: UIImageView)\n")
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        view.isUserInteractionEnabled = true
    }
    
// after 1st slice - y: 62
    // 1st slice location x: 15 (9), y: 76 (8)
// 2nd row bottom = y: (70 + 54 = ) 124
    // 65 + 65 = 130
    
// 3rd row top = 132
// 3rd row length (slice end point) = (183 + 54 = ) 237
// start: (x: 9, y: 132), end: (x: 183, y: 132)
    
    // slice = H: 54, W: 54
    // size of Slices Input Grid = W:362, H:195
    // location x: 6, y: 68
    
    // 195 / 3 = 65
    
    var initalPlayfieldTileLocations: [CGPoint] = []
    
    func setTileInitialLocation() {
        // creating our view to hold the slices
        let tileBayView = UIView()
        
        let columnAmount = 6
        let rowAmount = 2
        
        let viewHeight = 132
        let viewWidth = 362
        
        tileBayView.frame = CGRect(x: 9, y: 68, width: viewWidth, height: viewHeight)
        
        let tileHeight = viewHeight / rowAmount
        let tileWidth = viewWidth / columnAmount
        
        
        for column in 0..<columnAmount {
            for row in 0..<columnAmount {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: tileWidth, height: tileHeight), false, 0)
                
                // x = width
                // y = height
                
                let tileLocation = CGPoint.init(x: row * tileWidth, y: column * tileHeight)
                
                let tileLocationInSuperview = tileBayView.convert(tileLocation, to: tileBayView.superview)
                
                initalPlayfieldTileLocations.append(tileLocationInSuperview)
                
                // maybe just assign image to center of cell rather than offset each cell
                // also align each tile so that the center would be where the graphic represents.
                    // maybe produce multiple views to achieve such an effect
            }
            
        }
        
    }
    
    // Prateeks Methods
    
    // variable for gridView
    var gridLocations: [CGPoint] = []
    
    // variable to contain number for division of grid cells
    let gridSize: Int = 4
    
    // sets grid cells inside the targetView for images to be dropped down onto
    func getGridLocations() {
        
        // determine the height of tiles
        let height = (gridView.frame.height) / CGFloat (gridSize)
        let width = (gridView.frame.width) / CGFloat (gridSize)
        
        // iterate through the number of row/columns to create the title and add it to the array
        for y in 0..<gridSize {
            for x in 0..<gridSize {
                // create an image context the size of one tile
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
                
                // using the full size image to create a cropped image using the height and width variables and the iterated place in the gridx
                let location = CGPoint.init(x: CGFloat(x) * width, y: CGFloat(y) * height)
                let locationInSuperView = gridView.convert(location, to: gridView.superview)
                // add location to array of locations
                gridLocations.append(locationInSuperView)
            }
        }
    }
    
    
    
    // identifies if the tile is near a grid location and returns the grid poaition it is near or returns false if not
    func isTileNearGrid(finalPosition: CGPoint) -> (Bool, Int) {
        // iterate through grid locations to identify distance between tile and grid location
        for x in 0..<gridLocations.count {
            let gridPoint = gridLocations[x]
            // for gridPoint in gridLocations {
            // create from and to points
            
            var fromX = finalPosition.x
            var toX = gridPoint.x
            var fromY = finalPosition.y
            var toY = gridPoint.y
            
            // where final position is greater than gridpoint swap from and to points
            
            if finalPosition.x > gridPoint.x {
                fromX = gridPoint.x
                toX = finalPosition.x
            }
            if finalPosition.y > gridPoint.y {
                fromY = gridPoint.y
                toY = finalPosition.y
            }
            
            // calc distance from point to point and how close it needs to be to snap to grid
            let distance = (fromX - toX) * (fromX - toX) + (fromY - toY) * (fromY - toY)
            let halfTileSideSize = (gridView.frame.height / CGFloat(gridSize)) / 2.0
            
            if distance < (halfTileSideSize * halfTileSideSize) {
                // valid move update move counter
                return(true, x)
            }
        }
        
        // not close enough to snap to grid
        return(false, 99)
    }
    
    
    
    // prateeks
    @objc func viewDragger(_ gesture: UIPanGestureRecognizer) {
        print("dragging")
        
        // let draggableTile = view gesture was recognized in else exit
     //   guard let draggableTile = gesture.view else { return }
        let draggableTile = gesture.view as! Tile
        
        let translation = gesture.translation(in: draggableTile)
        
        if gesture.state == .began {
            
            initialImageViewOffset = draggableTile.frame.origin
    
        }
        
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - draggableTile.frame.origin.x, y: translation.y + initialImageViewOffset.y - draggableTile.frame.origin.y)
        
        draggableTile.transform = draggableTile.transform.translatedBy(x: position.x, y: position.y)
        
        
        if gesture.state == .ended {
            
            let positionInSuperview = gesture.view?.convert(position, to: gesture.view?.superview)
            
            // identify if tile is near grid
            let (nearTile, snapPosition) = isTileNearGrid(finalPosition: positionInSuperview!)
            //   let v = gesture.view as! UIImageView
            
            if nearTile {
                
                
                print("nearTile - snapPosition[\(snapPosition)]")
                UIView.animate(withDuration: 0.1, animations: {
                    // bringing tile to closest tile && scaling it to the size of the grid
                    draggableTile.frame = CGRect(origin: self.gridLocations[snapPosition], size: CGSize(width: 87.5, height: 87.5))
                    
                })
                print("snapped")
            
                print("tile correct position : \(draggableTile.correctPosition) \n dropped tile position \(snapPosition)\n")
                
              // if tile is in drop location
                // swap tiles
                
                if draggableTile.correctPosition == snapPosition {
                    print("\n CORRECT POSITION \n")
                }
                
          
//               let location = self.gridLocations[snapPosition]
//                let locationInSuperView = gridView.convert(location, to: gridView.superview)
//
//  trying to access a point in UIView to see if it is nil or not
                
                
                if timeMode == false {
                gameStructure.movesMade += 1
                print("Add Onto Moves: \(gameStructure.movesMade)")
                print(gameStructure.movesMade)
                }
                
            }
            
            if nearTile == false {
                UIView.animate(withDuration: 0.1 , animations: {
                    
                    // snaps view back to where it was last placed
                    // if put into grid will snap back to grid location
                    // NOT original loading point
                    draggableTile.frame.origin = self.initialImageViewOffset
                })
            }
            
            
            if String(snapPosition) == gesture.view?.accessibilityLabel {
                
                // correct grid space
                // update moves
                
                print("+1 moves ")
            }
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    

    
    
    // set gestures
    func configurePlayField() {
        print("configuring PlayField \n")
      
        addInitalPositionsToContainer()


        addTilesFromRange(from: 1, to: 4, with: imageArray[0])
        addTilesFromRange(from: 5, to: 8, with: imageArray[1])
        addTilesFromRange(from: 9, to: 12, with: imageArray[2])
        addTilesFromRange(from: 13, to: 16, with: imageArray[3])

//
//        inputSlicesRange(from: 1, to: 4, with: imageArray[0])
//        inputSlicesRange(from: 5, to: 8, with: imageArray[1])
//        inputSlicesRange(from: 9, to: 12, with: imageArray[2])
//        inputSlicesRange(from: 13, to: 16, with: imageArray[3])

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
       
        gameStructure.displayGameMode(with: timeMode, label: gameModeLabel, value: modeValue) 
        
        getGridLocations()
        
        gameStructure.checkCounter(displayLabel: modeValue, displayMode: timeMode)
        
        print("\(gridLocations.count)")
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
