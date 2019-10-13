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

struct Player {
    var name : String?
    var imageURL : String?
    var score : Int?
    var level : Int?
    

    init(dict:[String:Any]) {
        let name = dict[Constants.Keys.fbName]
        let score = dict[Constants.Keys.score]
        let level = dict[Constants.Keys.level]
        self.name = name as! String
        self.score = score as! Int
        self.level = level as! Int
    
        
    }
}

class HighScoreTableViewController: UITableViewController {
    let name = ["Waan","Earth","Mike","Tan","Peem"]
    
    internal let refresh = UIRefreshControl()
    
    @IBOutlet weak var backButton: UIButton!
    
    
    
    
    var data = [Player]()

    var numberOfPlayer = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
//        let fbRequestFriends: GraphRequest = GraphRequest(graphPath: "/{friend-list-id}", parameters: [AnyHashable : Any]() as! [String : Any])
        
//        fbRequestFriends.start { (connection, result, error) in
//            if error == nil && result != nil {
//                print("Request Friends result : \(result!)")
//            } else {
//                print("Error \(error)")
//            }
//        }
        
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
        
        let db = Firestore.firestore()
        db.collection(Constants.Keys.userScore).getDocuments() { (querySnapshot, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.data = [Player]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let player = Player(dict: document.data())
                    self.data.append(player)
             
            }
              self.data = self.data.sorted(by: { $0.score ?? 0 > $1.score ?? 0 })
                self.tableView.reloadData()
            }
        }

    }
//    func setup(input:[Any]){
//        numberOfPlayer = input.count
//        data = [Player]()
//
//        for index in 0..<numberOfPlayer {
//            let p = Player()
//            p.name = input[index][Constants.Keys.fbName]
//            p.score = Int(arc4random() % 9901) + 100
//            data.append(p)
//
//        }
//        refresh.endRefreshing()
//        tableView.reloadData()
//    }
    
    @IBAction func backHandler(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    
    }
    
    
    
    
    @objc func refreshDateData(){
//        setup()
        
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
        
        cell.levelLabel.text = "LEVEL: \(p.level ?? 1)"
    
        
        
        // Configure the cell...

        return cell
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

