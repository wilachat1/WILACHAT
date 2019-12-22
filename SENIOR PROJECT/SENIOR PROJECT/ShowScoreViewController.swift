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
import GoogleMobileAds
import MBProgressHUD

class ShowScoreViewController: UIViewController {
  
    @IBOutlet weak var
    levelLabel:
    UILabel!
  
    @IBOutlet weak var yourScoreIs: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
   
    
    @IBOutlet weak var playAgainLabel: UIButton!
    
    
    @IBOutlet weak var goHomeLabel: UIButton!
    
    
    var score: UserScore?
    var interstitial: GADInterstitial!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       roundCountToShowAds()
        
    }

    
    func roundCountToShowAds(){
        if let countStr = UserDefaults.standard.value(forKey: Constants.roundCountKey) as? String {
                   let count =  countLimit(Int(countStr) ?? 1 )
                   UserDefaults.standard.set("\(count)", forKey: Constants.roundCountKey)
                   UserDefaults.standard.synchronize()
                   
                   
               }else {
                   UserDefaults.standard.set("1", forKey: Constants.roundCountKey)
                   UserDefaults.standard.synchronize()
               }
    }

    func countLimit(_ count: Int) ->Int{
        var input = count
        if input < Constants.roundCountLimit {
            input += 1
            
        }else{
            input = 0
            showAds()
        }
        return input
    }
    
    func showAds() {
        MBProgressHUD.showAdded(to: view, animated: true)
        playAgainLabel.isEnabled = false
        goHomeLabel.isEnabled = false
        #if DEBUG
             interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        #else
       interstitial  = GADInterstitial(adUnitID: AdsId)
        #endif
        interstitial.delegate = self
               let request = GADRequest()
               interstitial.load(request)
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
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
                     Constants.Keys.score: self?.score?.score ?? 0,
                     Constants.Keys.fbName: profile?.name ?? ""
                    
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

extension ShowScoreViewController: GADInterstitialDelegate{
    /// Tells the delegate an ad request succeeded.
   func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    MBProgressHUD.hide(for: view, animated: true)
    print("interstitialDidReceiveAd")
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
     MBProgressHUD.hide(for: view, animated: true)

        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    MBProgressHUD.hide(for: view, animated: true)

        print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
     MBProgressHUD.hide(for: view, animated: true)

        print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    MBProgressHUD.hide(for: view, animated: true)

        print("interstitialDidDismissScreen")
        playAgainLabel.isEnabled = true
        goHomeLabel.isEnabled = true 
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    MBProgressHUD.hide(for: view, animated: true)

        print("interstitialWillLeaveApplication")
    }
}
