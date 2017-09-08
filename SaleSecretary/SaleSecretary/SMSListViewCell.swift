//
//  SMSListViewCell.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Foundation


class SMSListViewCell : UITableViewCell {
    
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var createLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
