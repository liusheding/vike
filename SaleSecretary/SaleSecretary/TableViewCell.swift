//
//  TableViewCell.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var picButton: UIButton!

    var customerData:Customer? {
        didSet {
            self.imageView?.image = UIImage(named: customerData!.name!)
            self.textLabel?.text = customerData!.name
//            self.textLabel?.textColor = customerData!.vip == true ? UIColor.redColor() : UIColor.blackColor()
            self.detailTextLabel?.text = customerData!.phone_number?[0]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




