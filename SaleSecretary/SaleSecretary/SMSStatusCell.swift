//
//  SMSStatusCell.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/9/19.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit

class SMSStatusCell: UITableViewCell {
    
    @IBOutlet weak var smsImage: UIImageView!
    
    @IBOutlet weak var textContent: UILabel!
    
    @IBOutlet weak var smsStatus: UILabel!
    
    @IBOutlet weak var totalSMS: UILabel!
    
    @IBOutlet weak var createTime: UILabel!
    
    @IBOutlet weak var executeDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
