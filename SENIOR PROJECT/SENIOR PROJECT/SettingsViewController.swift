//
//  SettingsViewController.swift
//  FoodTracker
//
//  Created by WILACHAT on 29/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

enum BuyingType: String {
    case hint = "HINT_KEY"
    case skip = "SKIP_KEY"
}

class SettingsViewController: UIViewController {

  
    
    
    @IBOutlet weak var justForFunButton: UIButton!
    
    
    @IBOutlet weak var getMoreHintButton: UIButton!
    
    @IBAction func backHandler(_ sender: Any) { navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var getMoreSkipButton: UIButton!
    @IBOutlet weak var musicOnButton: UIButton!
    
    
    @IBOutlet weak var aboutUsButton: UIButton!
    
    var currentBuyingType: BuyingType = .hint
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
             view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
         
        }
    func loadAds(){ MBProgressHUD.showAdded(to:view, animated: true)
               GADRewardBasedVideoAd.sharedInstance().delegate = self
               #if DEBUG
           GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
               withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
               #endif
             
        
    }
        
    
    
    @IBAction func buyHintHandler(_ sender: Any) { loadAds()
        currentBuyingType = .hint
    }
    
    @IBAction func buySkipHandler(_ sender: UIButton) {
    loadAds()
        currentBuyingType = .skip
    }
    
  
    func updateSaveValue(type: BuyingType) {
        let amountLeft = UserDefaults.standard.value(forKey: type.rawValue) as! String
        var totalAmount = Int(amountLeft) ?? 0
        totalAmount += Constants.plusAmount
        UserDefaults.standard.setValue("\(totalAmount)", forKey: type.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    
    
    
        
        
        // Do any additional setup after loading the view.


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {

   func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
       self.layer.shadowRadius = 8
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

    }
}

extension SettingsViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didRewardUserWith reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        updateSaveValue(type: currentBuyingType)
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
      print("Reward based video ad is received.")
        MBProgressHUD.hide(for: view, animated: true)
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
              }
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Opened reward based video ad.")
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad started playing.")
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad has completed.")
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad is closed.")
    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad will leave application.")
        MBProgressHUD.hide(for: view, animated: true)
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didFailToLoadWithError error: Error) {
        MBProgressHUD.hide(for: view, animated: true)
      print("Reward based video ad failed to load.")
    }
}
