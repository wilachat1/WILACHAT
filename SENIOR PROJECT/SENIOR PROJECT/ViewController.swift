//
//  ViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 22/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstStartButton: UIButton!
    
    @IBOutlet weak var firstStartContainerButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       firstStartButton.layer.cornerRadius = 15
        
        firstStartContainerButton.layer.cornerRadius = 15
    }

    
}

