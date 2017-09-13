//
//  TrailMsgCell.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/9/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TrailMsgCell: UITableViewCell {

    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
