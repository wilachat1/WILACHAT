//
//  HighScoreTableViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 6/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare

class Player {
    var name : String?
    var icon : String?
    var score : Int?
    var color : UIColor?
}

class HighScoreTableViewController: UITableViewController {
    let name = ["Waan","Earth","Mike","Tan","May"]
    
    internal let refresh = UIRefreshControl()
    
    
    
    
    
    var data = [Player]()

    var numberOfPlayer = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
        let fbRequestFriends: GraphRequest = GraphRequest(graphPath: "/{friend-list-id}", parameters: [AnyHashable : Any]() as! [String : Any])
        
        fbRequestFriends.start { (connection, result, error) in
            if error == nil && result != nil {
                print("Request Friends result : \(result!)")
            } else {
                print("Error \(error)")
            }
        }
        
        setup()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshDateData), for: .valueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    func setup(){
        numberOfPlayer = Int(arc4random() % 16) + 5
        data = [Player]()
        
        for _ in 0..<numberOfPlayer {
            let p = Player()
            let randomNameIndex = Int(arc4random() % 5)
            p.name = name[randomNameIndex]
            p.score = Int(arc4random() % 9901) + 100
            data.append(p)
            
        }
        data = data.sorted(by: { $0.score ?? 0 > $1.score ?? 0 })
        refresh.endRefreshing()
        tableView.reloadData()
    }
    
    @objc func refreshDateData(){
        setup()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreNameViewCell", for: indexPath) as? HighScoreNameViewCell else {
            return UITableViewCell()
        }
        let p = data[indexPath.row]
        cell.highScoreName.text = p.name
        cell.highScoreScoreLabel.text = p.score?.formattedWithSeparator
        cell.highScoreRanking.text = "\(indexPath.row + 1)"
        
    
        
        
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreHeaderViewCell") as? HighScoreHeaderViewCell else {
            return UITableViewCell().contentView
            }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let result = formatter.string(from: date)
        cell.highScoreHeaderDate.text = result 
        let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        loginButton.permissions = ["user_friends"]
        loginButton.delegate = self
        cell.contentView.addSubview(loginButton)
        
        
        
        return cell.contentView
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }

}

extension Int{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension HighScoreTableViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //
        print(result)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
    }
    
    
}
