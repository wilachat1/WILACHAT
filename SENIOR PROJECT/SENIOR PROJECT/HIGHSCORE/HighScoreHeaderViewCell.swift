//
//  HighScoreHeaderViewCell.swift
//  SENIOR PROJECT
//
//  Created by WILACHAT on 6/7/2562 BE.
//  Copyright © 2562 WILACHAT. All rights reserved.
//

import UIKit

class HighScoreHeaderViewCell: UITableViewCell {

    @IBOutlet weak var highScoreTitleLabel: UILabel!
    
    @IBOutlet weak var highScoreHeaderDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
