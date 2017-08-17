//
//  PersonContactCell.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class PersonContactCell: UITableViewCell {

    @IBOutlet weak var picName: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var acception: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
