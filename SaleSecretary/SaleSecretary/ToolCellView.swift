//
//  ToolCellView.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ToolCellView: UITableViewCell {
    
    
    
    @IBOutlet weak var toolImage: UIImageView!
    
    
    @IBOutlet weak var toolLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
