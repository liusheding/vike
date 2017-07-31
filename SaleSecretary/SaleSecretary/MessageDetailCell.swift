//
//  MessageDetailCell.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/7/27.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageDetailCell: UITableViewCell {
    
    @IBOutlet weak var celltime: UILabel!
    @IBOutlet weak var celltitle: UILabel!
    @IBOutlet weak var cellcontent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
