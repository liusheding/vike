//
//  SmsHistoryCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/13.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class SmsHistoryCell: UITableViewCell {
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
