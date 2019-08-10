//
//  GameplayCollectionViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 13/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit


private let reuseIdentifier = "gameItemsID"



class GameplayCollectionViewController: UIViewController {
    var numberOfChoice:[Bool] = [Bool]()
    var countdown: Timer?
    @IBOutlet weak var pauseButton: UIButton!
   
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    override func viewDidLoad() {
     
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        prepareGamePlay()
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    var count:Double = 1.5
    
    @objc func update() {
        count -= 0.1
        if(count > 0) {
            timeLabel.text = String.init(format: "%.1f", count)
        }else{
            countdown?.invalidate()
            countdown = nil
            performSegue(withIdentifier: "scoreIdentifier", sender: self)
        }
    }
    func countdownHandler() {
        count = 1.5
        timeLabel.text = "\(count)"
        countdown?.invalidate()
        countdown = nil
        countdown = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func prepareGamePlay(){
        let randomChoice = Int(arc4random() % 7 + 2)
        let correctPercentage = Int(arc4random() % 60 + 10)
        numberOfChoice = RandomManager.shared.random(numberOfChoice:
            randomChoice, percentage: correctPercentage)
        collectionView.reloadData()
        countdownHandler()
    }
    
    func reloadGame() {
        prepareGamePlay()
        questionNumber += 1
        scoreLabel.text = "\(score)".addComma
        questionNumberLabel.text = "\(questionNumber)"
    
    }
    var questionNumber:Int = 1
    var score:Int = 0
  
    func scoreCalculation() {
        score += questionNumber * numberOfChoice.count * 100
        print(score)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 3.0, animations: {
//            self.alphaWidthConts.constant = self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }) { (_) in
//      
//        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "scoreIdentifier"{
            if let vc = segue.destination as? ShowScoreViewController{
                vc.score = score
            }
        }
    }
    

}

extension GameplayCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numberOfChoice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        
        // Configure the cell
        cell.contentView.layer.cornerRadius = 10//cell.contentView.bounds.height/2
        cell.contentView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
//        if numberOfChoice[indexPath.row] {
//            cell.contentView.backgroundColor = UIColor.blue
//     }
//        let red = CGFloat(arc4random() % 256)/255.0
//        let green = CGFloat(arc4random() % 256)/255.0
//        let blue = CGFloat(arc4random() % 256)/255.0
//        cell.contentView.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if numberOfChoice[indexPath.row] {
            scoreCalculation()
            reloadGame()
        }else{
            countdown?.invalidate()
            countdown = nil
            performSegue(withIdentifier: "scoreIdentifier", sender: self)
        }
        
    }
}

extension GameplayCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
    }
}

extension String {
    var addComma: String {
        let formater = NumberFormatter()
        let number = formater.number(from: self) ?? 0
        formater.groupingSeparator = ","
        formater.usesGroupingSeparator = true
        formater.numberStyle = .decimal
        return formater.string(from: number) ?? self
    }
}
