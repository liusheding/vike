//
//  MessageDetailCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/7/27.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageDetailCell: UITableViewCell {
    
    @IBOutlet weak var cellcontent: UITextView!
    @IBOutlet weak var celltime: UILabel!
    @IBOutlet weak var celltitle: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    var mtype:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.imageview.image = UIImage(named: "bg_chat")
        self.imageview.superview?.sendSubview(toBack: self.imageview)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
