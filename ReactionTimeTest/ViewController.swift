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
     * This interger identifies the current trial's number
     */
    var trialNumber = 0
    
    /**
     * This defines the start time
     */
    var startTime = TimeInterval()
    
    /**
     * This is the timer that will be used
     */
    var timer:Timer = Timer()
    
    /**
     * This is a UIImage of the color green
     */
    let green = #imageLiteral(resourceName: "green.png")
    
    /**
     * This is a UIImage of the color grey
     */
    let grey = #imageLiteral(resourceName: "grey.png")
    
    /**
     * This array of interger is used to store the randomly generated times for the color to change
     */
    var lotsOfRandomTimes:[Int] = []
    
    /**
     * This array of double is used to store the result times of each trial
     */
    var results:[Double] = []
    
    /**
     * This textview shows is used as an reflection of console output in the UI
     */
    @IBOutlet weak var textView: UITextView!
    
    /**
     * This is the button at the back
     */
    @IBOutlet weak var bigColorButton: UIButton!
    
    /**
     * This function handles the response when the bigColorButton is pressed
     *
     * @param sender UIButton the bigColorButton
     */
    @IBAction func bigColorButtonIsPressed(_ sender: UIButton) {
        
        // check if the button is currently flipped
        if sender.backgroundImage(for: UIControlState.normal)==grey {
            sender.setBackgroundImage(green, for: UIControlState.normal)
            results.append(NSDate.timeIntervalSinceReferenceDate-startTime-Double(lotsOfRandomTimes[trialNumber-1]))
            textView.text.append("\nTrial \(trialNumber): \(results.last!)")
            print("Trial \(trialNumber): \(results.last!)")
            
            if trialNumber == 5 {
                timer.invalidate()
                var average = 0.0
                for result in results {
                    average += result
                }
                average /= 5
                textView.text.append("\nAverage Time: \(average)sec")
            }
        }
        
        
        if (!timer.isValid && trialNumber == 0){
            
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
        guard trialNumber<5 else {
            timer.invalidate()
            return
        }
        if time.seconds == lotsOfRandomTimes[trialNumber] {
            bigColorButton.setBackgroundImage(grey, for: UIControlState.normal)
            print("Trigger")
            trialNumber += 1
        }
    }
    
    /**
     * This function overrided the viewDidLoad function
     *
     * This function generates 5 pairs of randomly generated times each 5~7 seconds away
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        lotsOfRandomTimes.append(Int(arc4random() % 2) + 5)
        for i in 0..<4 {
            lotsOfRandomTimes.append(Int(arc4random() % 2) + 5 + lotsOfRandomTimes[i])
        }

    }



}

