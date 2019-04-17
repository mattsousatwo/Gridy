//
//  GameStructure.swift
//  Gridy
//
//  Created by Matthew Sousa on 1/18/19.
//  Copyright © 2019 Matthew Sousa. All rights reserved.
//

import UIKit


class GameStructure {
    
    let playfield = PlayFieldViewController()
    
    // number of moves user has made
    var movesMade: Int = 0

    // display number of moves or countdown timer
    func displayGameMode(with interpreter: Bool, label displayLabel: UILabel, value displayValue: UILabel) {
        // if interpreter is set to false - gameMode = moves
        if interpreter == false {
            displayLabel.text = "moves:"
            displayValue.text = "\(movesMade)"
            
            // add timer
            
        } else {
            // if interpreter is set to true - gameMode = time
            displayLabel.text = "time:"
            displayValue.text = clock
            
            // countdown timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownTimer), userInfo: displayValue, repeats: true)
        }
    }
    
    // func to convert moves counter label to an Int for comparison 
    func stringToInt(string: String) -> Int {
        let convert: Int? = Int(string)
        return convert!
        }
    
    
    // update Moves counter while view is running
    func checkCounter(displayLabel: UILabel, displayMode: Bool) {
        if displayMode == false {
            // string to compare current value to displayed value
            let comparisonString = stringToInt(string: displayLabel.text!)
            if movesMade != comparisonString {
                displayLabel.text = "\(movesMade)"
            }
            
        }
    }
    
    
    
    // :: Timer ::
    
    var timer: Timer?
    // time - 180 sec - 3 mins (as a constant so timeLeft can be reset to totalTime later)
    let totalTime = 180
    // timeValue in seconds to be decremented
    lazy var timeLeft = totalTime
    // score
    var score = 1000
    // number of times hint was pressed
    var hintCounter = 0
    
 
    
    
    // func to display clock in MM:SS format
    func timeString(interval: Int) -> String {
        let minutes = interval / 60
        let seconds = interval % 60
        
        return String.init(format: "%02i:%02i", minutes, seconds)
    }
    
    // string to display time
    lazy var clock = timeString(interval: timeLeft)
    
    // func that fires each second to countdown the timer
    @objc func countdownTimer() {
        timeLeft -= 1
        score -= 2
        
        clock = timeString(interval: timeLeft)
        
        // checking for UILabel from userInfo to display time
        guard let timeDisplayLabel = timer?.userInfo as? UILabel else {
            // UILabel not there
            print("-- countdownTimer userInfo not recognized")
            return
        }
        timeDisplayLabel.text = clock
        print(clock)
        
        // if timeLeft reaches 0 stop timer 
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            
            // go to gameOver screen -> {
            
                // might need to add self.view in userInfo for viewController transition
            playfield.performSegue(withIdentifier: "unwindFromGameOverVC", sender: self)
            
            
            // }
        }
        
        
    }
    
    
    // return final score 
    func getScore() -> Int {
        let finalScore = (score - (hintCounter * 2))
        return finalScore
    }
    
}
