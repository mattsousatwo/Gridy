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
    
    // class for moves mode & timer
    let gameStructure = GameStructure()
   
    // images used for the tiles in the game
    var imageArray: [UIImage] = []
    
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
    
    // container for tiles
    var tileContainer: [Tile] = []
    
    
    
// Outlets
    // Hint Button Outlet
    @IBOutlet weak var hintButton: UIImageView!
    
    // Game Mode Label - moves or time
    @IBOutlet weak var gameModeLabel: UILabel!
    
    // Game Value - Moves made counter || Timer Countdown
    @IBOutlet weak var modeValue: UILabel!
    
    // View Containing playfield grid 
    @IBOutlet weak var gridView: UIView!
    
   // Image used to create background
    @IBOutlet weak var backgroundImage: UIImageView!

    // new game button
    @IBAction func newGameButton(_ sender: Any) {
        print("New Game Button Pressed")
        
    // removing sliced images from slicedImagesArray
        slicing.removeImages(from: &imageArray)
        
        // reset number of moves made
        gameStructure.movesMade = 0
    
        // stop gameClock
        gameStructure.timer?.invalidate()
        gameStructure.timer = nil
        // reset gameClock
        gameStructure.timeLeft = gameStructure.totalTime
        // reset number of moves
        gameStructure.hintCounter = 0
    }
    
    // added slicedImages to this outlet collection
    @IBOutlet var initalTilesGrid: [UIView]!
    
    @IBOutlet weak var originalTilesCollection: UIView!
    
    
 
    // if user moves a tile, have that tile be scaled to the size of the square on the grid (UIView) [ 54 pts -> 87 pts ]

    
    // Hint Button
    @objc func showHint(_ sender: UITapGestureRecognizer) {
        // add onto number of times hint has been pressed 
        gameStructure.hintCounter += 1
        
        // set game image to the preview imageView
        imageView.image = imageHolder3
        
        // add blur view
        let blur = UIVisualEffectView()
        blur.frame = self.view.frame
        blur.effect = UIBlurEffect(style: .regular)
        self.view.addSubview(blur)
        
        
        // add view
        self.view.addSubview(previewImageView)
        self.previewImageView.addSubview(imageView)
        // set frame
        self.previewImageView.frame = CGRect(x: 0.0, y: 0.0, width: imageHolder3.size.width + 25, height: imageHolder3.size.height + 25)
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: imageHolder3.size.width, height: imageHolder3.size.height)
        
        // set frame attributes
        self.previewImageView.layer.cornerRadius = 10
        self.imageView.layer.cornerRadius = 10
        // set background color
        self.previewImageView.backgroundColor = #colorLiteral(red: 0.1350251588, green: 0.2111370802, blue: 0.1540531392, alpha: 1)
        // center views
        self.imageView.center = self.previewImageView.center
        self.previewImageView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        
        self.view.bringSubviewToFront(self.previewImageView)
        
        // animate presentation in
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.previewImageView.center = self.view.center
        }) { (success) in }
        
        // animate presentation out
        UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseIn, animations: {
            
            // move previewImageView off screen
            self.previewImageView.center = CGPoint(x: self.view.center.x + (self.view.frame.width * 2), y: self.view.center.y)
            // remove blurView
            blur.effect = nil
            blur.isUserInteractionEnabled = false
        }, completion: { (success) in })
        
        
        
        
        print("Show Hint")
    }
    
   
// Functions
   
    // Check if all tiles are in correct positions
    func checkForCompletion() {
        
        // If all tiles in tile container are in correct tile position return true
        let allTilesCorrect = tileContainer.allSatisfy { $0.isInCorrectPosition == true }
        
        // If tiles are in correct position go to game over screen
        if allTilesCorrect == true {
            print("\n\n\nAll in Correct Positions!")
            
            // go to game over screen - with delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "goToGameOverVC", sender: self)
                })
            // remove ability to move tiles
            for tile in tileContainer {
                tile.isUserInteractionEnabled = false
            }
        }
        else {
        // else continue game
        print("\npuzzle is not complete\n")
        }
        
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
                
                // adding adjusted position to tileLocation container for shuffling
                slicing.tileLocations.append(subviewPoint)
                
                    // remove 17th value from initalTilesGrid == UIView location which contains all the tile subviews
                    slicing.tileLocations.removeAll(where: {($0).x == 12.0 && ($0).y == 136.0})
            }
            
        } else {
            print("initalTilesGrid has no subviews")
            }
            
    }
    
    // Add Game Tiles using a range for each array of smaller images of the game image
    func addTilesFromRange(from lowInt: Int, to maxInt: Int, with array: [UIImage] ) {
        
        // using closed range for image selection
        let closedRange = lowInt...maxInt
        
        print(closedRange)
        
        for x in closedRange {
            print("adding tiles ")
            
                // select image for tile
                let image = array[x - lowInt]
            
                // get a shuffled point from slicing.tileLocations
                let shuffledPoint = slicing.shuffledTileLocation()
                
                // tile frame
                let tileFrame = CGRect(x: shuffledPoint!.x, y: shuffledPoint!.y, width: tileSize, height: tileSize)
            
                // initalizing tile
                let tile = Tile(originalTileLocation: shuffledPoint!, correctPosition: (x - 1), frame: tileFrame)
                
                // add to container to then later be checked for gameCompletion
                tileContainer.append(tile)
                
                    // not in correct space by defualt
                    tile.isInCorrectPosition = false
            
                // adding tile image
                tile.image = image
            
                print("tile[\(x - 1)], x: \(shuffledPoint!.x), y: \(shuffledPoint!.y)")
            
                // add subview/gestures
                tile.isUserInteractionEnabled = true
                self.view.addSubview(tile)
                self.view.bringSubviewToFront(tile)
                addGestures(view: tile)
                
                
                
            
            
        }
    }
    
        // add pan gesture to tiles
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
    
    // container to store the position of each cell in the intial tile grid
    var initalPlayfieldTileLocations: [CGPoint] = []
    // container of empty positions from the inital grid
    var emptyTileCells: [CGPoint] = []
    // func to iterate through each tile in tileContainer and add thier position to a container
    func getIntialTileGridLocations() {
        for tile in tileContainer {
            let position = tile.frame.origin
            
            initalPlayfieldTileLocations.append(position)
        }
    }
    
    // function to recognize if tile is above inital tile locations bay
    func isNearTileBay(finalPosition: CGPoint) -> (Bool, Int) {
        
        
        // iterate through grid locations
        for x in 0..<initalPlayfieldTileLocations.count {
            let gridPoint = initalPlayfieldTileLocations[x]
        
        // for gridPoint in initalGridLocations
        // create from and to points
        var fromX = finalPosition.x
        var toX = gridPoint.x
        var fromY = finalPosition.y
        var toY = gridPoint.y
        
        // if final pos is greater than gridPoint then swap
            if finalPosition.x > gridPoint.x {
                fromX = gridPoint.x
                toX = finalPosition.x
            }
        
            if finalPosition.y > gridPoint.y {
                fromY = gridPoint.y
                toY = finalPosition.y
            }
        // calc distance from point to point
        let distance = (fromX - toX) * (fromX - toX) + (fromY - toY) * (fromY - toY)
        let halfTileSideSize = (54 / 2)
            
            
        // if tile is within half distance to drop location, snap to grid
            if Int(distance) < (halfTileSideSize * halfTileSideSize) {
                return (true, x)
            }
            
            
            
        }
        // 99 - index out of bounds
        return (false, 99 )
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
            let (nearDropLocation, snapPosition) = isTileNearGrid(finalPosition: positionInSuperview!)
            //   let v = gesture.view as! UIImageView
            
            if nearDropLocation {
                
                
                print("nearTile - snapPosition[\(snapPosition)]")
                UIView.animate(withDuration: 0.1, animations: {
                    // bringing tile to closest tile && scaling it to the size of the grid
                    draggableTile.frame = CGRect(origin: self.gridLocations[snapPosition], size: CGSize(width: 87.5, height: 87.5))
                    
                })
                print("snapped")
                print(":: original position = x: \(draggableTile.originalTileLocation!.x), y: \(draggableTile.originalTileLocation!.y)")
                
                // checking for game completion
                draggableTile.isInCorrectPosition = false
                
            
                print("tile correct position : \(draggableTile.correctPosition) \n dropped tile position \(snapPosition)\n")
                
                // :::::: if tile is in drop location ::::::::
                // swap tiles
                
                if draggableTile.correctPosition == snapPosition {
                    print("\n CORRECT POSITION \n")
                    
                    draggableTile.isInCorrectPosition = true
                    
                    // ::::: remove drop ability :::::
                   //gridLocations.remove(at: snapPosition)
                    
                    
                }
                
                checkForCompletion()
//               let location = self.gridLocations[snapPosition]
//                let locationInSuperView = gridView.convert(location, to: gridView.superview)
//
//  trying to access a point in UIView to see if it is nil or not
                
                
                if timeMode == false {
                gameStructure.movesMade += 1
                print("Add Onto Moves: \(gameStructure.movesMade)")
                print(gameStructure.movesMade)
                }
                
                
                gameStructure.checkCounter(displayLabel: modeValue, displayMode: timeMode)
                
            }
            
            if nearDropLocation == false  {
                
                
                
                print("Dropped Out of Bounds - back to original pos")
                UIView.animate(withDuration: 0.1 , animations: {
                    // changes view position and size - does not place tile in original location without second tile position declaration
                    draggableTile.frame = CGRect(origin: draggableTile.originalTileLocation!, size: CGSize(width: 54, height: 54))
                    draggableTile.frame.origin = draggableTile.originalTileLocation!
                })
            }
            
            
            if String(snapPosition) == gesture.view?.accessibilityLabel {
                
                // correct grid space
                // update moves
                print("+1 moves ")
            }
            
            // identify if tile is near original grid location
            let (nearOriginalGrid, snapToLocation) = isNearTileBay(finalPosition: positionInSuperview!)
            
            if nearOriginalGrid {
                print("dropped in inital grid")
                
                UIView.animate(withDuration: 0.1, animations: {
                    // bringing tile to closest tile && scaling it to the size of the grid
                    draggableTile.frame = CGRect(origin: self.initalPlayfieldTileLocations[snapToLocation], size: CGSize(width: 54, height: 54))
                })
            }
            
            if nearOriginalGrid == false {
                print("Not a Valid location")
            }
            
            
            
        }
        
    }
    
    
    

    
   
    
    
    
    
    
    
    

    
    
    // set gestures
    func configurePlayField() {
        print("configuring PlayField \n")
      
        
        addInitalPositionsToContainer()


        // add tiles to top container - use range for correct image placement
        addTilesFromRange(from: 1, to: 16, with: imageArray)
        
        
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
       
        // display game mode - Timer, Moves
        gameStructure.displayGameMode(with: timeMode, label: gameModeLabel, value: modeValue) 
        
        // get tile positions to add to top of grid
        getGridLocations()
        // get tile positions for top grid
        getIntialTileGridLocations()
        
        
        
        print("\(gridLocations.count)")
    }
    
    
    // send game data over to game over 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameOverVC" {
            let gameOverVC = segue.destination as! GameOverVC
            // sending gameImage to game over view controller 
            gameOverVC.gameImage = imageHolder3
            
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

}
