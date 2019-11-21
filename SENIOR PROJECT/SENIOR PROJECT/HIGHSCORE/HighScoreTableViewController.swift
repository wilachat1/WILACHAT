//
//  HighScoreTableViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 6/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import SDWebImage
import FBSDKCoreKit

struct Player: Hashable {
    var name : String?
    var imageURL : String?
    var score : Int?
    var level : Int?
    var fbid : String?
    
    var hashValue: Int { return name.hashValue }

    init(dict:[String:Any]) {
        let name = dict[Constants.Keys.fbName]
        let score = dict[Constants.Keys.score]
        let level = dict[Constants.Keys.level]
        self.name = name as! String
        self.score = score as! Int
        self.level = level as! Int
        self.fbid = dict[Constants.Keys.fbid] as! String
        self.imageURL = "https://graph.facebook.com/\(self.fbid ?? "")/picture?type=large"
        
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
}

class HighScoreTableViewController: UITableViewController {
    let name = ["Waan","Earth","Mike","Tan","Peem"]
    
    internal let refresh = UIRefreshControl()
    
    @IBOutlet weak var backButton: UIButton!
    var currentFBID : String? {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    var data = [Player]()

    var numberOfPlayer = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
        Profile.loadCurrentProfile {[weak self](profile, error) in
            self?.currentFBID = profile?.userID
        }
        
//        setup()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshDateData), for: .valueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        MBProgressHUD.showAdded(to: view, animated: true)
        loadAllUserScore()
    }
    
    @IBAction func backHandler(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    
    }
    
    func loadAllUserScore() {
        let db = Firestore.firestore()
               db.collection(Constants.Keys.userScore).getDocuments() {
                
              [weak self]  (querySnapshot, err) in
                MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                self?.refreshControl?.endRefreshing()
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    self?.data = [Player]()
                       for document in querySnapshot!.documents {
                           print("\(document.documentID) => \(document.data())")
                           let player = Player(dict: document.data())
                        if player.name?.isEmpty ?? true {
                            continue
                        }
                        self?.data.append(player)
                    
                   }
                    self?.data = self?.data.sorted(by: { $0.score ?? 0 > $1.score ?? 0 }) ?? []
                    let dataSet = Set(self?.data ?? [])
                    self?.data = Array(dataSet)
                    self?.data = self?.data.sorted(by: { $0.score ?? 0 > $1.score ?? 0 }) ?? []
                    self?.tableView.reloadData()
                    
                   }
               }
    }
    
    
    
    
    @objc func refreshDateData(){
        loadAllUserScore()

        
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
        let p = data[indexPath.row]
        let cellID = p.fbid == currentFBID ? "HighScoreNameViewCellMe" : "HighScoreNameViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? HighScoreNameViewCell else {
            return UITableViewCell()
        }
        cell.highScoreName.text = p.name
        cell.highScoreScoreLabel.text = p.score?.formattedWithSeparator
        cell.highScoreRanking.text = "\(indexPath.row + 1)"
        
        cell.levelLabel.text = "LEVEL: \(p.level ?? 1)"
        cell.highScoreIconImage?.sd_setImage(with: URL(string: p.imageURL ?? ""), completed: nil)
        
        
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 130
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

