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
    ["#032a33","#255965","#4c6f7b","#f1d18a"] ,
    //        ["#ee4540","#c72c41","#801336","#2d132c",] ,
        ["#003B73","#0074B7","#60A3D9","#BFD7ED"],
        //["#494949","#fffdf6","#ece8d9","#faf6e9"],
        ["#5c8d89","#74b49b","#a7d7c5","#f9f8eb"],
        ["#248ea9","#28c3d4","#aee7e8","#fafdcb"],
["#FAFAF0","#F36870","#FFF593","#74B2D0"],
        //        ["#ee4540","#c72c41","#801336","#2d132c"],
        ["#ebebeb","#fec100","#528078","#3e615b"],
        //        ["#142d4c","#385170","#9fd3c7","#ececec"],
        ["#ffd700","#115173","#053f5e","#022c43"],
        ["#fffa67","#ffcd60","#ff8162","#d34848"],
        ["#537791","#c1c0b9","#f7f6e7","#e7e6e1"],
       ["#9d0b0b","#da2d2d","#eb8242","#f6da63"],
            ["#9d0b0b","#da2d2d","#eb8242","#f6da63"],
             ["#432F70","#713770","#B34270","#E95670"],
                ["#A5A7CF","#FAFAFC","#2D1674","#5A58A2"],
                   ["#FF8882","#543855","#E88D72","#FFCBA4"],
                      ["#365852","#E7D6C0","#F1BDA4","#D9DCCD"],
                         ["#A06AB4","#FFD743","#07BB9C","#D773A2"],
                            ["#D3E9E7","#F3B9DF","#01B9CC","#F1E488"],
                               ["#FEEDCF","#C6D8D5","#F9C7E4","#F7E3D9"],
                                  ["#FDA649","#F4E683","#B83C70","#4DB3E4"],
                                     ["#2D2A4A","#2D2A4A","#F4F5F8","#A51931"],
                                        ["#444965","#F8CD4F","#E8EBF0","#F83940"],
                                           ["#E2EAEE","#FEC6C5","#FADCAF","#BDF0D6"],
                                              ["#FEEDCF","#FAFAFC","#E95670","#F7E3D9"],
                                                 ["#013A20","#478C5C","#BACC81","#CDD193"],
                                                    ["#055816","#8BCA67","#EBE99E","#F9D976"],
                                                       ["#000000","#FF4A3B","#FFF797","#E34234"],
                                                          ["#000000","#FF4A3B","#FFF797","#E34234"],
                                                             ["#000000","#FF4A3B","#FFF797","#E34234"]
                                                             
//        ["#537791","#c1c0b9","#f7f6e7","#e7e6e1"]
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
            let circles = [self?.circle1,self?.circle2,self?.circle3,self?.circle4]
//            self?.animateCircle(level: level, views: circles as! [UIView], factor: factor)
            let color = self?.allColor[level] ?? []
            for (view,hex) in zip(circles,color) {
                view?.backgroundColor = UIColor(hex: hex)
            }
        
            
        }
        
    }
    
    func animateCircle (level : Int, views: [UIView], factor: CGFloat){
        guard level < allColor.count else { return }
        circle1WidthConstraints.constant = factor * 6.0
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseOut,.beginFromCurrentState], animations: {
            self.circle1.transform = CGAffineTransform.init(scaleX: 6, y: 6)
        } , completion: { (fin) in
            
    })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut,.beginFromCurrentState], animations: {
                self.circle1.transform = .identity
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
                var hexNumber: UInt32 = 0

                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    a = 1

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
