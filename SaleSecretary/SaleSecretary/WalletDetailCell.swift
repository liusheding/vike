//
//  WalletDetailCell.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class WalletDetailCell: UITableViewCell {
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
