//
//  UserDetailCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell {
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picName: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
