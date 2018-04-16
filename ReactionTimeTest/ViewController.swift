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
    
    var duringTest = false
    
    var count = 0
    
    @IBOutlet weak var textView: UITextView!
    
    /**
     * This defines the start time
     */
    var startTime = TimeInterval()
    
    /**
     * This is the timer that will be used
     */
    var timer:Timer = Timer()
    
    let green = #imageLiteral(resourceName: "green.png")
    let grey = #imageLiteral(resourceName: "grey.png")
    
    var lotsOfRandomTimes:[Int] = []
    var results:[Double] = []
    
    var commonError = 0.0
    
    
    @IBOutlet weak var bigColorButton: UIButton!
    
    @IBAction func bigColorButtonIsPressed(_ sender: UIButton) {
        
        if duringTest {
            duringTest = false
            results.append(NSDate.timeIntervalSinceReferenceDate-startTime-Double(lotsOfRandomTimes[count]))
            textView.text.append("\nTrial \(count+1): \(results.last!)")
            print("Trial \(count+1): \(results.last!)")
            
            count += 1
            
            if count >= 5 {
                timer.invalidate()
                var average = 0.0
                for result in results {
                    average += result
                }
                average /= 5
                textView.text.append("\nAverage Time: \(average)sec")
            }
            
        }
        
        flip()
        
        if (!timer.isValid){
            
            //run update Time repeativelly
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            //run Time Alert check repeativelly
            let bSelector: Selector = #selector(ViewController.timeAlert)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: bSelector, userInfo: nil, repeats: true)
            
            // define start time
            startTime = NSDate.timeIntervalSinceReferenceDate
            
            
        }
    }
    
    func flip(){
        //print("fliped")
        if bigColorButton.backgroundImage(for: UIControlState.normal) == green {
            bigColorButton.setBackgroundImage(grey, for: UIControlState.normal)
        } else {
            bigColorButton.setBackgroundImage(green, for: UIControlState.normal)
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
    
    @objc func timeAlert() {
        guard count<5 else {
            timer.invalidate()
            return
        }
        if time.seconds == lotsOfRandomTimes[count] {
            duringTest = true
            flip()
            //print("\(count):\(lotsOfRandomTimes[count])")
            //print("\(NSDate.timeIntervalSinceReferenceDate-startTime)")
        }
    }
    
    override func viewDidLoad() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        commonError = currentTime - startTime
        print(commonError)
        super.viewDidLoad()
        lotsOfRandomTimes.append(Int(arc4random() % 5) + 5)
        for i in 0..<4 {
            lotsOfRandomTimes.append(Int(arc4random() % 5) + 5 + lotsOfRandomTimes[i])
        }
        print(lotsOfRandomTimes)
    }



}

