//
//  ViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 22/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import RealmSwift
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare



class ViewController: UIViewController {
    
    @IBOutlet weak var firstStartButton: UIButton!
    
    @IBOutlet weak var showHighScore: UILabel!
    

    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var hintLabel:
    UILabel!
   
    @IBOutlet weak var skipLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       firstStartButton.layer.cornerRadius = 15
        
       
        view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
    
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let userScore = realm.objects(UserScore.self).sorted(byKeyPath: "score",ascending: false).first
        let hightScore = "\(userScore?.score ?? 0)"
        showHighScore.text =  "BEST: \(hightScore.addComma)"
        hintLabel.text = UserDefaults.standard.value(forKey: Constants.hintSaveKey) as? String ?? ""
         skipLabel.text = UserDefaults.standard.value(forKey: Constants.skipSaveKey) as? String ?? ""
        navigationController?.navigationBar.isHidden = true
        
        Profile.loadCurrentProfile {[weak self](profile, error) in
            if (profile == nil) {
                self?.facebookButton.isHidden = false
                let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
                loginButton.delegate = self
                self?.facebookButton.addSubview(loginButton)
            }else{
                self?.facebookButton.isHidden = true
            }
        }
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.shareButton.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.8, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.shareButton.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }, completion: nil)
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
    
    @IBAction func shareHandler(_ sender: Any) {
  let url = URL(string: "https://apps.apple.com/th/app/lucky-or-lose/id1485140117?l=th")
  let activityViewController =
      UIActivityViewController(activityItems: [url],
                               applicationActivities: nil)

  present(activityViewController, animated: true) {
      // ...
  }

    }
    
    
}

extension ViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //
        print(result)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
    }
    
    
}
