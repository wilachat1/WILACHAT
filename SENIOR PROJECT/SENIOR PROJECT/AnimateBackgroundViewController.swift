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
   
    let allColor = [
        ["#413B48","#93606E","#C47270","#DB9A7C",] ,
        ["#3c4245","#5f6769","#719192","#dfcdc3",] ,
        ["#ee4540","#c72c41","#801336","#2d132c",] ,
        ["#494949","#fffdf6","#ece8d9","#faf6e9"],
        ["#5c8d89","#74b49b","#a7d7c5","#f9f8eb"],
        ["#248ea9","#28c3d4","#aee7e8","#fafdcb"],
        ["#ee4540","#c72c41","#801336","#2d132c"],
        ["#142d4c","#385170","#9fd3c7","#ececec"],
        ["#ffd700","#115173","#053f5e","#022c43"],
        ["#fffa67","#ffcd60","#ff8162","#d34848"],
        ["#537791","#c1c0b9","#f7f6e7","#e7e6e1"],
    ]
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
               let factor = view.bounds.maxY / 5.0
               circle1WidthConstraints.constant = factor
        circle2WidthConstraints.constant = factor * 2.2
        circle3WidthConstraints.constant = factor * 3.5
        circle4WidthConstraints.constant = factor * 6
        view.layoutIfNeeded()
               let views = [circle1,circle2,circle3,circle4]
               views.forEach { (v) in
                  v?.layer.cornerRadius = (v?.bounds.width ?? 0) / 2
                   
               }
        NotificationCenter.default.addObserver(forName: Constants.levelUpNotification, object: nil, queue: .main) {  [weak self](noti) in
            var level = noti.userInfo?["level"] as? Int ?? 0
            level -= 1
           
        
            
        }
        
    }
    
    func animateCircle (level : Int, views: [UIView], factor: CGFloat){
        guard level < allColor.count else { return }
        circle1WidthConstraints.constant = factor * 6.0
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseOut,.beginFromCurrentState, .autoreverse], animations: { self.circle1.layoutIfNeeded()
            self.circle1.alpha = 0
        } , completion: { (fin) in
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut,.beginFromCurrentState], animations: { self.circle1.layoutIfNeeded()
            let currentColor = self.allColor[level]
            views.enumerated().forEach({ (index,view) in
                let color = currentColor[index]
                view.backgroundColor = UIColor(hex: color)
            })
            },  completion: { (finish) in
        })
    })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.circle1.alpha = 1
            self.circle1WidthConstraints.constant = factor
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut,.beginFromCurrentState,.autoreverse], animations: {self.circle1.layoutIfNeeded()
            })
        }
        
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

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = 1

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
