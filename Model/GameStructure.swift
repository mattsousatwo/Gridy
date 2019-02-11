//
//  GameStructure.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/18/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit


class GameStructure {
    
    // number of moves user has made
    var movesMade: Int = 0

    
    func displayGameMode(with interpreter: Bool, label displayLabel: UILabel, value displayValue: UILabel) {
        // if interpreter is set to false - gameMode = moves
        if interpreter == false {
            displayLabel.text = "moves:"
            displayValue.text = "\(movesMade)"
        } else {
            // if interpreter is set to true - gameMode = time
            displayLabel.text = "time:"
            displayValue.text = "3:00"
        }
    }
    
    // func to convert moves counter label to an Int for comparison 
    func stringToInt(string: String) -> Int {
        let convert: Int? = Int(string)
        return convert!
        }
    
    
    // update Moves counter while view is running
    // Not Functioning
    func checkCounter(displayLabel: UILabel, displayMode: Bool) {
        if displayMode == false {
            
            let comparisonString = stringToInt(string: displayLabel.text!)
            if movesMade != comparisonString {
                displayLabel.text = "\(movesMade)"
            }
            
        }
    }
    
    
    
    
    
} 
