//
//  UserScore.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 10/8/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import RealmSwift

class UserScore:Object {
    @objc dynamic var fbid = ""
    @objc dynamic var level = 0
    @objc dynamic var score = 0
    @objc dynamic var playDate = Date()
}
