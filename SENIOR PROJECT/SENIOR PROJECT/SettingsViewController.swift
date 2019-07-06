//
//  SettingsViewController.swift
//  FoodTracker
//
//  Created by WILACHAT on 29/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var moreHintMoreSkipButton: UIButton!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    
    
    @IBOutlet weak var justForFunButton: UIButton!
    
    
    
    @IBOutlet weak var musicButton: UIButton!
    
    
    @IBOutlet weak var aboutUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
moreHintMoreSkipButton.layer.cornerRadius = 15
        
        leaderboardButton.layer.cornerRadius = 15
        
        justForFunButton.layer.cornerRadius = 15
        musicButton.layer.cornerRadius = 15
        aboutUsButton.layer.cornerRadius = 15

        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moreHintMoreSkipButton.dropShadow()
        
    aboutUsButton.dropShadow()
        leaderboardButton.dropShadow()
       musicButton.dropShadow()
     justForFunButton.dropShadow()
    }
    

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
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
