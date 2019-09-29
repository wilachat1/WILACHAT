//
//  AnimateBackgroundViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 29/9/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class AnimateBackgroundViewController: UIViewController {

    @IBOutlet weak var circle1: UIView!
  
    @IBOutlet weak var circle1WidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var circle2: UIView!
    @IBOutlet weak var circle2WidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var circle3: UIView!
   @IBOutlet weak var circle3WidthConstraints: NSLayoutConstraint!
   
    @IBOutlet weak var circle4: UIView!
  @IBOutlet weak var circle4WidthConstraints: NSLayoutConstraint!
   
    @IBOutlet weak var circle5: UIView!
    @IBOutlet weak var circle5WidthConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let factor = view.bounds.maxY / 5.0
        circle1WidthConstraints.constant = factor
        circle2WidthConstraints.constant = factor * 2
        circle3WidthConstraints.constant = factor * 3
        circle4WidthConstraints.constant = factor * 4
        circle5WidthConstraints.constant = factor * 5
        view.layoutIfNeeded()
        let views = [circle1,circle2,circle3,circle4,circle5]
        views.forEach { (v) in
           v?.layer.cornerRadius = (v?.bounds.width ?? 0) / 2
            
        }
        let allColor = ["#413B48","#93606E","#C47270","#DB9A7C","#ECCC87"]
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
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
