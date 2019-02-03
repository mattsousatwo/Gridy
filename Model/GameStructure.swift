//
//  GameStructure.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/18/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit


class GameStructure {
    
    func displayGameMode(to interpreter: Bool, label displayLabel: UILabel, value displayValue: UILabel) {
        // if interpreter is set to false - gameMode = moves
        if interpreter == false {
            displayLabel.text = "moves:"
            displayValue.text = "00"
        } else {
            // if interpreter is set to true - gameMode = time
            displayLabel.text = "time:"
            displayValue.text = "3:00"
        }
    }
    
} 
