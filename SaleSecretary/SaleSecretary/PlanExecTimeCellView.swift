//
//  PlanExecTimeCellView.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/3.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class PlanExecTimeCellView : UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    open var date:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.datePicker
        // self.imageView?.image = UIImage(named: "icon_zxsj")
    }
    
}
