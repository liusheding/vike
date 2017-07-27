//
//  MessageListCell.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {
    @IBOutlet weak var cellimage: UIImageView!
    @IBOutlet weak var cellname: UILabel!
    @IBOutlet weak var cellphone: UILabel!
    @IBOutlet weak var celltime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
