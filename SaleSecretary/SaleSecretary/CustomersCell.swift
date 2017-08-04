//
//  CustomersCell.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
//import Kingfisher
//import IBAnimatable

class CustomersCell: UITableViewCell {

    @IBOutlet weak var itemIcon: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemNumbers: UILabel!
    
    @IBOutlet weak var details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
