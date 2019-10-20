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
    static let levelStep: Array = [0,500,1250,2250,3500,4200,5600,6800,8150,9150,10150,11150]
    static let hintstep: Array = [1,1,2,2,2,2,2,2,2,2,2,2]
    static let skipstep: Array = [0,0,0,1,0,1,0,1,0,1,0,1]

    static let plusAmount: Int = 5
    
    static let levelUpNotification: NSNotification.Name =  NSNotification.Name(rawValue: "levelupNotification")
    
    
    
    struct Keys {
        static let fbid: String = "fbid"
        static let level: String = "level"
        static let playDate: String = "playDate"
        static let score: String = "score"
        static let userScore: String = "userScore"
        static let fbName: String = "fbName"

    }

}
