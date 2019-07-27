//
//  ShowScoreViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 27/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class ShowScoreViewController: UIViewController {
    @IBOutlet weak var yourScoreIs: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
   
    
    @IBOutlet weak var playAgainLabel: UIButton!
    
    
    @IBOutlet weak var goHomeLabel: UIButton!
    
    
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score ?? 0)".addComma
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
