//
//  SettingsViewController.swift
//  FoodTracker
//
//  Created by WILACHAT on 29/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  
    
    
    @IBOutlet weak var justForFunButton: UIButton!
    
    
    @IBOutlet weak var getMoreHintButton: UIButton!
    
    @IBAction func backHandler(_ sender: Any) { navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var getMoreSkipButton: UIButton!
    @IBOutlet weak var musicOnButton: UIButton!
    
    
    @IBOutlet weak var aboutUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
             view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
         
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

