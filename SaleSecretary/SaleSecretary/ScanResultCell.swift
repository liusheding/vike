//
//  ScanResultCell.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class ScanResultCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.borderStyle = .none
    }
    @IBAction func doExitEditing(_ sender: UITextField) {
        self.textField.resignFirstResponder()
    }
    
}
