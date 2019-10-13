//
//  HighScoreNameViewCell.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 6/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class HighScoreNameViewCell: UITableViewCell {

    
    
    @IBOutlet weak var highScoreScoreLabel: UILabel!
  
    @IBOutlet weak var highScoreName: UILabel!
    
    @IBOutlet weak var highScoreRanking: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
  
    @IBOutlet weak var highScoreIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
