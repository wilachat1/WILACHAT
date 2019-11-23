//
//  Constants.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 7/9/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    static let collectionFactor: CGFloat = 0.4
    static let collectionItemSize: CGSize = CGSize(width: 100, height: 100)
    static let countdownTimer: Double = 3.0
    static let countdownFactor: Double = 0.01
    static let skipSaveKey: String = "SKIP_KEY"
    static let hintSaveKey: String = "HINT_KEY"
    static let scoreMultiplier: Int = 50
    static let levelStep: Array = [0,500,1250,2250,3500,4200,5600,6800,8150,9150,10150,11150,15000,20000,25000,30000,35000,40000,45000,50000,55000,60000,65000,70000,75000,80000,85000,90000,95000,100000]
    static let hintstep: Array = [1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
    static let skipstep: Array = [0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]

    static let plusAmount: Int = 20
    
    static let levelUpNotification: NSNotification.Name =  NSNotification.Name(rawValue: "levelupNotification")
    static let roundCountLimit: Int = 10
    static let roundCountKey: String = "ROUND_COUNT_KEY"
    
    
    
    
    struct Keys {
        static let fbid: String = "fbid"
        static let level: String = "level"
        static let playDate: String = "playDate"
        static let score: String = "score"
        static let userScore: String = "userScore"
        static let fbName: String = "fbName"

    }

}
