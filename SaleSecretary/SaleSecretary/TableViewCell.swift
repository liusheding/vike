//
//  TableViewCell.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    class func cellWithTableView(tableView:UITableView) -> TableViewCell {
        let cellID = "TableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCellStyle.subtitle , reuseIdentifier: cellID)
        }
        return cell as! TableViewCell
    }

    var customerData:Customer? {
        didSet {
            self.imageView?.image = UIImage(named: customerData!.icon!)
            self.textLabel?.text = customerData!.name!
//            self.textLabel?.textColor = customerData!.vip == true ? UIColor.redColor() : UIColor.blackColor()
            self.detailTextLabel?.text = customerData!.phone_number?[0]
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle , reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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




