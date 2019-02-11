//
//  Tile.swift
//  Gridy
//
//  Created by Matthew Sousa on 2/8/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit



class Tile : UIImageView {
    
    var originalTileLocation: CGPoint
    
    // final position in grid 0 - 15
    // access using gridLocations array
    let correctPosition: Int
    
    
    
    init(originalTileLocation: CGPoint, correctPosition: Int, frame: CGRect) {
        self.originalTileLocation = originalTileLocation
        self.correctPosition = correctPosition
        
        super.init(frame: frame)
    }
    
    
    // required init by UIImageView
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
