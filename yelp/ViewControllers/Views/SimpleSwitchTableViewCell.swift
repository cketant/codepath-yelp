//
//  SimpleSwitchTableViewCell.swift
//  yelp
//
//  Created by christopher ketant on 10/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SimpleSwitchTableViewCell: UITableViewCell {
    @IBOutlet var filterSwitch: UISwitch!
    @IBOutlet var switchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
