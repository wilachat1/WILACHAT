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
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var alphaWidthConts: NSLayoutConstraint!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBOutlet weak var hintButton: UIButton!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphaWidthConts.constant = 0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3.0, animations: {
            self.alphaWidthConts.constant = self.view.bounds.width
            self.view.layoutIfNeeded()
        }) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameplayCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        
        // Configure the cell
        cell.contentView.layer.cornerRadius = 10//cell.contentView.bounds.height/2
        cell.contentView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
//        let red = CGFloat(arc4random() % 256)/255.0
//        let green = CGFloat(arc4random() % 256)/255.0
//        let blue = CGFloat(arc4random() % 256)/255.0
//        cell.contentView.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension GameplayCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
    }
}
