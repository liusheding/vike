//
//  MineInfoCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MineInfoCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var invitecode: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
