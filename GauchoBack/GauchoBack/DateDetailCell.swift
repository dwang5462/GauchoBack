//
//  DateDetailCell.swift
//  GauchoBack
//
//  Created by Carson Holoien on 5/26/16.
//  Copyright © 2016 CS48 Group2. All rights reserved.
//

import UIKit

class DateDetailCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateDetail: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
