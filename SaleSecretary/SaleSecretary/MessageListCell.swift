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
    @IBOutlet weak var unreadnum: UILabel!
    var mtype:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unreadnum.layer.masksToBounds = true
        self.unreadnum.layer.cornerRadius = self.unreadnum.bounds.height / 2.0
    }
    
    func setCellContnet(_ num: Int) {
        self.unreadnum.text = num > 99 ? "99+" : String(num)
        self.unreadnum.isHidden = (num == 0)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
