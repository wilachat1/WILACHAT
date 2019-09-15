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
    
//    @IBOutlet weak var showHighScore: UILabel!
   

    
    @IBOutlet weak var hintLabel:
    UILabel!
   
    @IBOutlet weak var skipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       firstStartButton.layer.cornerRadius = 15
        
       
        view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
    
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let userScore = realm.objects(UserScore.self).sorted(byKeyPath: "score",ascending: false).first
//        showHighScore.text = "BEST:\(userScore?.score ?? 0)"
        hintLabel.text = UserDefaults.standard.value(forKey: Constants.hintSaveKey) as? String ?? ""
         skipLabel.text = UserDefaults.standard.value(forKey: Constants.skipSaveKey) as? String ?? ""
        navigationController?.navigationBar.isHidden = true 
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "playgameSegue" {
            if let vc = segue.destination as? GameplayCollectionViewController {
              let userScore = UserScore()
                userScore.skip = 0
                userScore.hint = 0
                if let skip = UserDefaults.standard.value(forKey: Constants.skipSaveKey) as? String {
                    let skipNumbeer = Int(skip) ?? 0
                    userScore.skip = skipNumbeer >= 5 ? 5 : skipNumbeer
                }
                if let hint = UserDefaults.standard.value(forKey: Constants.hintSaveKey) as? String {
                    let hintNumbeer = Int(hint) ?? 0
                    userScore.hint = hintNumbeer
                }
                vc.userScore = userScore
                
            }
        }
    }
    
}

