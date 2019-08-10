//
//  ViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 22/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var firstStartButton: UIButton!
    
    @IBOutlet weak var showHighScore: UILabel!
   
    @IBOutlet weak var firstStartContainerButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       firstStartButton.layer.cornerRadius = 15
        
        firstStartContainerButton.layer.cornerRadius = 15
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let userScore = realm.objects(UserScore.self).sorted(byKeyPath: "score",ascending: false).first
        showHighScore.text = "BEST:\(userScore?.score ?? 0)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "playgameSegue" {
            if let vc = segue.destination as? GameplayCollectionViewController {
                vc.userScore = UserScore()
            }
        }
    }
    
}

