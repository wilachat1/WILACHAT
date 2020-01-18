//
//  GameplayCollectionViewController.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 13/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit
import AudioToolbox
import GoogleMobileAds
import RealmSwift


private let reuseIdentifier = "gameItemsID"



class GameplayCollectionViewController: UIViewController {
    var bannerView: GADBannerView!

    @IBOutlet weak var backGroungImage: UIImageView!
    var numberOfChoice:[Bool] = [Bool]()
    var countdown: Timer?
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var levelupLabel: UILabel!
    @IBOutlet weak var achieveGoalLabel: UILabel!
    @IBOutlet weak var checkedGoalIcon: UIImageView!
    @IBOutlet weak var skipBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hintBottomConstraint: NSLayoutConstraint!
    
    
    
    //@IBOutlet weak var timeLabel: UILabel!
   
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    var questionNumber:Int = 1
    var score:Int = 0
    var userScore: UserScore?
    var bgController = AnimateBackgroundViewController()
    
    
    @IBOutlet weak var HintCountLabel: UILabel!
    @IBOutlet weak var SkipCountLabel: UILabel!
   
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
 

        // Register cell classes
        prepareGamePlay()
        navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(patternImage:UIImage(named: "bg") ?? UIImage())
   createBackground()
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        #if DEBUG
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
            bannerView.adUnitID = "ca-app-pub-5621209397277761/5702143779"
        #endif
        bannerView.delegate = self
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
    }
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.insertSubview(bannerView, belowSubview: hintButton)
       view.addConstraints(
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: bottomLayoutGuide,
                             attribute: .top,
                             multiplier: 1,
                             constant: 0),
          NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
      }
    
    func createBackground() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimateBackgroundViewController") as? AnimateBackgroundViewController else{
            return
        }
        bgController = vc
        addChild(bgController)
        view.insertSubview(bgController.view, at: 0)
        
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
        
      
       updateHintSkipButton()
        countdown?.invalidate()
        sender.isEnabled = false
     
            hintDisplay()
        
    }
    
    func hintDisplay() {
        let index = (userScore?.level ?? 1) - 1
        let hintNumber = Constants.hintstep[index]
        let result = numberOfChoice.enumerated().filter({ !$0.element}).map({$0.offset})
        let loopHint = hintNumber >= numberOfChoice.count ? numberOfChoice.count - 1 : hintNumber
        for (i,foundIndex) in result.enumerated(){
            if i >= loopHint {
                break
            }
            if let cell = collectionView.cellForItem(at: IndexPath(item:foundIndex, section: 0)) {
                cell.contentView.alpha = 0.5
            }
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
        updateHintSkipButton()
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
//            self.backGroungImage.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
            self.collectionView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }) { (finished) in
           
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
        let level = getCurrentLevel()

        score += level * Constants.scoreMultiplier
        score += Constants.scoreMultiplier
        
        
        userScore?.score = score
        userScore?.level = level
        print(score)
      
        checkedGoalIcon.isHidden = score < getCurrentGoal()
        if !checkedGoalIcon.isHidden {
            achieveGoalLabel.textColor = UIColor.init(hex: "#57B447")
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.8,
                           options: [],
                           animations: {
                self.checkedGoalIcon.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                self.achieveGoalLabel.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }, completion: nil)
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
    }
    
    func getCurrentLevel () -> Int {
        var level = 0
          for step in Constants.levelStep {
              if score < step {
                  break
              }
              level += 1
          }
        if level > 1 && level != userScore?.level {
            NotificationCenter.default.post(name: Constants.levelUpNotification, object: nil, userInfo: ["level":level])
        }
        return level
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(levelup(notification:)), name: Constants.levelUpNotification, object: nil)
        levelupLabel.alpha = 0
        updateHintSkipButton()
        
       
        let goal = "\(getCurrentGoal())"
        achieveGoalLabel.text =  "GOAL \(goal.addComma)"
    }
    
    func getCurrentGoal() -> Int{
        
        let realm = try! Realm()
        let userScore = realm.objects(UserScore.self).sorted(byKeyPath: "score",ascending: false).first
        let goalIndex = Constants.goalStep.firstIndex(where: { $0 > (userScore?.score ?? 0 )}) ?? 0
        return Constants.goalStep[goalIndex]
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Constants.levelUpNotification, object: nil)
    }
    
    @objc func levelup(notification: Notification){
        levelupLabel.transform = .identity
        levelupLabel.alpha = 1
    
        UIView.animate(withDuration: 0.3, animations: {
                        self.levelupLabel.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        
        }) { (finish) in
            self.levelupLabel.alpha = 0
        }
        plusSkipPoint()
        updateHintSkipButton()
    }

    
    func plusSkipPoint() {
        let index = (userScore?.level ?? 1) - 1
        let skipPoint = Constants.skipstep[index]
        userScore?.skip += skipPoint
    }
    
    func updateHintSkipButton() {
    let skipButtonTitle = "SKIP(\(userScore?.skip ?? 0))"
        SkipCountLabel.text = skipButtonTitle
    let hintButtonTitle = "HINT(\(userScore?.hint ?? 0))"
    HintCountLabel.text = hintButtonTitle 
  
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

extension GameplayCollectionViewController: GADBannerViewDelegate{
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
        skipBottomConstraint.constant = 50
        hintBottomConstraint.constant = 50
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
