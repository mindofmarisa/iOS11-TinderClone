//
//  MatchTableViewCell.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/27/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendButtonpressed(_ sender: UIButton) {
    }
}
