//
//  CommonSMSTableCell.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/4.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SnapKit
struct CommonTableCell {
    
    static let SMSContetID = "smsContentTextCell"
    
    // MARK
    static func createAccessoryButton() -> UIButton {
        let btn = UIButton(type : UIButtonType.custom)
        btn.frame = CGRect(x:0, y:0, width: 32, height:32)
        let image = UIImage(named: "icon_tj")
        btn.setImage(image, for: UIControlState.normal)
        return btn
    }

    static func createCustomerCell(_ cellId : String) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_kh")
        cell.textLabel?.text = "选择客户"
        
        // cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.textColor = UIColor.lightGray
        // cell.accessoryView = UIImageView(image: UIImage(named: "icon_tj"))
        // cell.addConstraint(NSLayoutConstraint)
        // cell.accessoryView = CommonTableCell.createAccessoryButton()
        return cell
    }
    
    static func createSMSContentCell(_ tableView: UITableView) -> UITableViewCell {
        // let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableCell.SMSContetID) as! SMSContentTextCell
        // let txt = UITextView(frame: CGRect(x: 0, y: 0, width:cell.frame.width, height:cell.frame.height))
        // txt.isEditable = true
        // txt.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        // txt.returnKeyType = UIReturnKeyType.done
        // cell.imageView?.image = UIImage(named: "icon_nr")
        // cell.addSubview(txt)
        return cell
    }
    
    
    static func createPlanDateCell(_ cellId: String) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_zxsj")
        cell.textLabel?.text = "短信发送时间"
        cell.detailTextLabel?.text = "选择时间"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
        
    }
}


