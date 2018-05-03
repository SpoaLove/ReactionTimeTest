//
//  ViewController.swift
//  ReactionTimeTest
//
//  Created by Tengoku no Spoa on 2018/4/16.
//  Copyright © 2018年 Tengoku no Spoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /**
     * This tuple stands for time
     */
    var time: (minutes: UInt8, seconds: UInt8, fraction: UInt8) = (0,0,0)

    /**
     * This interger identifies the current trial's count
     */
    var trialCount = 0
    /**
     * This interger identifies the current game's count
     */
    var gameCount = 0
    
    /**
     * This defines the start time
     */
    var startTime = TimeInterval()
    
    /**
     * This is the timer that will be used
     */
    var timer:Timer = Timer()
    

    /**
     * This UIImage defines the starting color
     */
    let startGreen = #imageLiteral(resourceName: "startGreen.png")
    
    /**
     * This is an array of UIImage which defines the colors used in the game
     */
    let colors = [
        #imageLiteral(resourceName: "red.png"), // red
        #imageLiteral(resourceName: "orange.png"), // orange
        #imageLiteral(resourceName: "yellow.png"), // yellow
        #imageLiteral(resourceName: "yelloishGreen.png"), // yellowish green
        #imageLiteral(resourceName: "greenHue.png")  // green hue
    ]
    
    
    /**
     * This array of interger is used to store the randomly generated times for the color to change
     */
    var lotsOfRandomTimes:[Int] = []
    
    /**
     * This array of double is used to store the result times of each trial
     */
    var results:[Double] = []
    
    /**
     * This array of double is used to store the averaes result times of each game
     */
    var averages:[Double] = []
    
    /**
     * This textview shows is used as an reflection of console output in the UI
     */
    @IBOutlet weak var textView: UITextView!
    
    /**
     * This is the button at the back
     */
    @IBOutlet weak var bigColorButton: UIButton!
    
    /**
     * This UILabel is used to display the current trial time and the final average time
     */
    @IBOutlet weak var resultLabel: UILabel!

    /**
     * This function handles the response when the bigColorButton is pressed
     *
     * @param sender UIButton the bigColorButton
     */
    @IBAction func bigColorButtonIsPressed(_ sender: UIButton) {
        
        guard gameCount < 5 else {
            return
        }
        
        // check if the button is currently flipped
        if sender.backgroundImage(for: UIControlState.normal) == colors[gameCount] {
            
            sender.setBackgroundImage(#imageLiteral(resourceName: "startGreen.png"), for: UIControlState.normal)
            
            results.append(NSDate.timeIntervalSinceReferenceDate-startTime-Double(lotsOfRandomTimes[trialCount-1]))
            resultLabel.text = "Trial \(trialCount): \(results.last!.roundToThreeDecimalPlaces())sec"
            print("Trial \(trialCount): \(results.last!)sec")
            textView.text.append("Trial \(trialCount): \(results.last!)sec\n")
            
            if trialCount % 5 == 0 {
                
                var average = 0.0
                for result in results {
                    average += result
                }
                average /= 5
                averages.append(average)
                
                textView.text.append("Game \(gameCount+1), Average Time: \(average)sec\n")
                print("Game \(gameCount+1), Average Time: \(average)sec\n")
                results = []
                gameCount += 1
                
            } else if trialCount % 5 == 1 {
                textView.text.removeAll()
                textView.text.append("Trial \(trialCount): \(results.last!)sec\n")
            }

            
            
            if trialCount == 25 {
                
                textView.text.removeAll()
                
                var averageAverage = 0.0
                var index = 1
                for average in averages {
                    textView.text.append("Game \(index), Average Time: \(average)sec\n")
                    averageAverage += average
                    index += 1
                }
                averageAverage /= 5
                
                resultLabel.text = "Average: \(averageAverage.roundToThreeDecimalPlaces())sec"
                textView.text.append("Total Average Time: \(averageAverage)sec\n")
                print("Total Average Time: \(averageAverage)sec")
                
                timer.invalidate()
            }
            
        }
        
        
        if (!timer.isValid && trialCount == 0){
            
            resultLabel.text = "Trial 1:"
            
            // run update Time repeativelly
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            // check if the color will be flipped
            let bSelector: Selector = #selector(ViewController.flipColor)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: bSelector, userInfo: nil, repeats: true)
            
            // define start time
            startTime = NSDate.timeIntervalSinceReferenceDate
            
            
        }
    }

    
    /**
     * This function refreshes the time
     */
    @objc func updateTime() {
        
        if timer.isValid {
            let currentTime = NSDate.timeIntervalSinceReferenceDate
            var elapsedTime: TimeInterval = currentTime - startTime
            time.minutes = UInt8(elapsedTime / 60.0)
            elapsedTime -= (TimeInterval(time.minutes) * 60)
            time.seconds = UInt8(elapsedTime)
            elapsedTime -= TimeInterval(time.seconds)
            time.fraction = UInt8(elapsedTime * 100)
        }
    }
    
    /**
     * This function flips the color of the button at the randomly generated time
     */
    @objc func flipColor() {
        
        guard trialCount<26 else {
            timer.invalidate()
            return
        }
        
        let elapsedTime = time.minutes*60 + time.seconds
        
        if elapsedTime == lotsOfRandomTimes[trialCount] {
            bigColorButton.setBackgroundImage(colors[gameCount], for: UIControlState.normal)
            trialCount += 1
        }
    }
    
    /**
     * This function overrided the viewDidLoad function
     *
     * This function generates 25 pairs of randomly generated times each 5~7 seconds away
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lotsOfRandomTimes.append(Int(arc4random() % 2) + 5)
        for i in 0..<26 {
            lotsOfRandomTimes.append(Int(arc4random() % 2) + 5 + lotsOfRandomTimes[i])
        }

    }

}



extension Double {
    
    func roundToThreeDecimalPlaces() -> Double {
        let divisor = pow(10.0, Double(3))
        return (self * divisor).rounded() / divisor
    }
    
}



