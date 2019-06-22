//
//  ViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 22/6/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var loginInsert: UIButton!
    
    @IBOutlet weak var forgotPasswordInput: UIButton!
    
    @IBOutlet weak var backInput: UIButton!
    let a = "Wilachat"
    let b = "Weesakul"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginHandler(_ sender: Any) {
        let username = usernameInput.text ?? "User"
        let password = passwordInput.text ?? "Pass"
         print("\(username)::\(password)")
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let username =
//        let password =
        return checkUsernameAndPassword(username: usernameInput.text ?? "User", password: passwordInput.text ?? "Pass")
//        return passed
    }
    func checkUsernameAndPassword (username: String, password: String) -> Bool {
        //do something
        if username == a && password == b {
            return true
        }
        
        return false
        
    }
    
}

