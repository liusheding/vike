//
//  AddUserCell.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/29.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class AddUserCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inputtext: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        inputtext.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
