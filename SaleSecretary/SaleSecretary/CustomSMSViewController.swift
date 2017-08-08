//
//  CustomSMSViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/4.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class CustomSMSViewController : UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previewBtn: UIButton!
    
    fileprivate var cellId : String = "CustomSMSViewCellId"
    
    fileprivate let planDatePickerId = "planDatePicker"
    
    lazy var datePicker : PlanExecTimeCellView = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.planDatePickerId) as! PlanExecTimeCellView
        return cell
    }()
    
    fileprivate var isDatePickerHidden:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PlanExecTimeCellView", bundle: nil), forCellReuseIdentifier: planDatePickerId)
        self.tableView.register(UINib(nibName: "SMSContentTextCell", bundle: nil), forCellReuseIdentifier: CommonTableCell.SMSContetID)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
    }
}


extension CustomSMSViewController : UITableViewDelegate, UITableViewDataSource {
    
    // 行高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 1 || ( section == 2 && indexPath.row == 1)  {
            return 120
        } else {
            return 50
        }
    }
    
    // section 之间高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 5
        }
        
        return CGFloat(10)
    }
    
//    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
//        // if section == 3 && self.datePicker
//        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && !self.isDatePickerHidden {
            return 2
        }
        return 1
    }
    
    // 加载内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            return CommonTableCell.createCustomerCell(cellId)
        case 1:
            return CommonTableCell.createSMSContentCell(tableView)
        case 2:
            if self.isDatePickerHidden {
                return CommonTableCell.createPlanDateCell(cellId)
            } else {
                if indexPath.row == 0 {
                    return CommonTableCell.createPlanDateCell(cellId)
                } else {
                    return self.isDatePickerHidden ? tableView.cellForRow(at: indexPath)! : self.datePicker
                }
            }
        default:
            return tableView.cellForRow(at: indexPath)!

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        switch section {
        case 2:
            if indexPath.row == 0 {
                self.isDatePickerHidden = !self.isDatePickerHidden
                // self.tableView.reloadRows(at: [[2, 1]], with: UITableViewRowAnimation.none)
                self.tableView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.fade)
            }
        default:
            return
        }
    }
    
    
    
}
