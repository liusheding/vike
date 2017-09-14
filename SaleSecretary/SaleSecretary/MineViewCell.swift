//
//  MineViewCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MineViewCell: UITableViewCell {
    @IBOutlet weak var mineName: UILabel!
    @IBOutlet weak var mineinfo: UILabel!
    @IBOutlet weak var mineImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        mineinfo.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
