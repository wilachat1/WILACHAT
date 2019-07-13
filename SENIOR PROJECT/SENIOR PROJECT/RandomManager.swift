//
//  RandomManager.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 13/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class RandomManager: NSObject {
    let shared = RandomManager()
    var listChoice = [Bool]()
    var numOfCorrect: Int = 0
    var numOfChoice: Int = 0
    var correctPercentage: Double = 0//0-100
    
    override init() {
        numOfChoice = 10
        numOfCorrect = 10
        correctPercentage = Double(numOfChoice/numOfCorrect)
//        createRandomObject()
        
        print (listChoice)
    }
    
    func randomFromPercent(percent: Double) -> Bool {
        let chance:Double = 1/percent
        let decimal = round(100*(chance))/100
        let modNumber: UInt32 = UInt32(Int(decimal * 100))
        print("arc4random() % \(modNumber) == 0")
        return arc4random() % modNumber == 0
    }
    
    func createRandomObject(){
        for _ in 0..<numOfChoice {
            listChoice.append(false)
        }
        
        print (listChoice)
        var index:Int = 0
        var correctIndex:Int = 0
        while correctIndex < numOfCorrect{
            
            if randomFromPercent(percent: correctPercentage) && !listChoice[index] {
                listChoice[index] = true
                correctIndex += 1
            }
            
            index += 1
            if index >= numOfChoice {
                index = 0
            }
        }
    }

}
