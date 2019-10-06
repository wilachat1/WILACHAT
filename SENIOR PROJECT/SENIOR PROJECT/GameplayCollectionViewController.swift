//
//  GameplayCollectionViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 13/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import AudioToolbox

private let reuseIdentifier = "gameItemsID"



class GameplayCollectionViewController: UIViewController {
    @IBOutlet weak var backGroungImage: UIImageView!
    var numberOfChoice:[Bool] = [Bool]()
    var countdown: Timer?
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
//@IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    var questionNumber:Int = 1
    var score:Int = 0
    var userScore: UserScore?
    override func viewDidLoad() {
     
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
 

        // Register cell classes
//       self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        prepareGamePlay()
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
    }
    
    var count:Double = Constants.countdownTimer
    
    @objc func update() {
        count -= Constants.countdownFactor
        if(count > 0) {
//            timeLabel.text = String.init(format: "%.1f", count)
        }else{
            countdown?.invalidate()
            countdown = nil
            performSegue(withIdentifier: "scoreIdentifier", sender: self)
        }
        if let layout = collectionView.collectionViewLayout as? CircleLayout {
            layout.factor = layout.factor - 0.001333333333
            layout.invalidateLayout()
        }
    }
    func countdownHandler() {
        count = Constants.countdownTimer
//       timeLabel.text = "\(count)"
        countdown?.invalidate()
        countdown = nil
        countdown = Timer.scheduledTimer(timeInterval: Constants.countdownFactor, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
   }
    
    private func rotateChoice(){
//        collectionView.layer.removeAllAnimations()
//        UIView.animate(withDuration: 5, delay: 0, options: .allowUserInteraction, animations: {
//            self.collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        }) { (finish) in
        
//        }
        
        
        
    }
    
    
    @IBAction func hintHandler(_ sender: UIButton) {
        guard userScore?.hint ?? 0 > 0 else {
            return
        }
        userScore?.hint -= 1
        if let hint = UserDefaults.standard.value(forKey: Constants.hintSaveKey) as? String {
            let newHint = "\((Int(hint) ?? 0) - 1)"
            UserDefaults.standard.set(newHint, forKey: Constants.hintSaveKey)
            UserDefaults.standard.synchronize()
            
            }
        
      
        let hintButtonTitle = "HINT(\(userScore?.hint ?? 0))"
        hintButton.setTitle(hintButtonTitle, for: .normal)
        countdown?.invalidate()
        sender.isEnabled = false
        hintDisplay()
    }
    
    func hintDisplay() {
        var index = 0
        guard !numberOfChoice.allSatisfy({ $0 == true}) else {
            hintButton.isEnabled = false
            return
            
        }
        while numberOfChoice[index]{
            index += 1
        }
        if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)){
            cell.contentView.alpha = 0.5
        }
    }
    
    @IBAction func skipHandler(_ sender: UIButton) {
        guard userScore?.skip ?? 0 > 0 else {
            return
        }
        userScore?.skip -= 1
        if let skip = UserDefaults.standard.value(forKey: Constants.skipSaveKey) as? String {
            let newSkip = "\((Int(skip) ?? 0) - 1)"
            UserDefaults.standard.set(newSkip, forKey: Constants.skipSaveKey)
            UserDefaults.standard.synchronize()
           
        }
        scoreCalculation()
        reloadGame()
    }
    
    
    
    func prepareGamePlay(){
        let randomChoice = Int(arc4random() % 7 + 2)
        let correctPercentage = Int(arc4random() % 60 + 10)
        numberOfChoice = RandomManager.shared.random(numberOfChoice:
            randomChoice, percentage: correctPercentage)
        collectionView.reloadData()
        countdownHandler()
    
        self.collectionView.transform = .identity
        rotateChoice()
        stateLabel.text = "LUCKY: \(RandomManager.shared.numOfCorrect) LOSE: \(numberOfChoice.count - RandomManager.shared.numOfCorrect)"
    }
    
    func reloadGame() {
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            self.backGroungImage.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
            self.collectionView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }) { (finished) in
            self.backGroungImage.transform = .identity
            self.collectionView.transform = .identity
            self.prepareGamePlay()
           self.questionNumber += 1
            self.scoreLabel.text = "\(self.score)".addComma
            self.questionNumberLabel.text = "LEVEL \(self.userScore?.level ?? 1)"
            self.skipButton.isEnabled = (self.userScore?.skip ?? 0) > 0
            self.hintButton.isEnabled = (self.userScore?.hint ?? 0) > 0
            if let layout = self.collectionView.collectionViewLayout as? CircleLayout {
                layout.factor = Constants.collectionFactor
                layout.invalidateLayout()
            }
        }
        

    }

  
    func scoreCalculation() {
        var level = 0
        for step in Constants.levelStep {
            if score < step {
                break
            }
            level += 1
        }
        score += level * Constants.scoreMultiplier
        score += Constants.scoreMultiplier
        
        
        userScore?.score = score
        userScore?.level = level
        print(score)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let skipButtonTitle = "SKIP(\(userScore?.skip ?? 0))"
        skipButton.setTitle(skipButtonTitle, for: .normal)
        let hintButtonTitle = "HINT(\(userScore?.hint ?? 0))"
        hintButton.setTitle(hintButtonTitle, for: .normal)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "scoreIdentifier"{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            if let vc = segue.destination as? ShowScoreViewController{
                vc.score = userScore
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
        
        cell.contentView.alpha = 1
        if numberOfChoice[indexPath.row] {
            cell.contentView.layer.borderColor = UIColor.white.cgColor
        }else{
            cell.contentView.layer.borderColor = UIColor.red.cgColor
        }
        

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
