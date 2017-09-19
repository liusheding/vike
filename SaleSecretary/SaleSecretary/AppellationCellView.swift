//
//  AppellationCellView.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/3.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class AppellationCellView : UITableViewCell {
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var switchControl: UISwitch!
    
    @IBOutlet weak var noAppellationLabel: UILabel!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func doneEditing(_ sender: UITextField) {
        self.textField.resignFirstResponder()
    }
}
