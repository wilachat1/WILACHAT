//
//  ShowScoreViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 27/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FBSDKCoreKit

class ShowScoreViewController: UIViewController {
  
    @IBOutlet weak var
    levelLabel:
    UILabel!
  
    @IBOutlet weak var yourScoreIs: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
   
    
    @IBOutlet weak var playAgainLabel: UIButton!
    
    
    @IBOutlet weak var goHomeLabel: UIButton!
    
    
    var score: UserScore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        try! realm.write {
            realm.add(score!)
        }
             view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
         
        
        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score?.score ?? 0)".addComma
        levelLabel.text = "\(score?.level ?? 1)"
        updateUserScore()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "playAgainSegue" {
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
    func updateUserScore() {
        Profile.loadCurrentProfile { [weak self](profile, error) in
            let db = Firestore.firestore()
                 
                  var ref: DocumentReference? = nil
                  ref = db.collection(Constants.Keys.userScore).addDocument(data: [
                      Constants.Keys.fbid: profile?.userID ?? "-",
                      Constants.Keys.level: self?.score?.level ?? 0,
                     Constants.Keys.playDate: Date(),
                     Constants.Keys.score: self?.score?.score ?? 0
                  ]) { err in
                      if let err = err {
                          print("Error adding document: \(err)")
                      } else {
                          print("Document added with ID: \(ref!.documentID)")
                      }
                  }

              }
              
        }

    

}
