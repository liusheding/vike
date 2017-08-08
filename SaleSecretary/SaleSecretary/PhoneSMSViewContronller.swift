//
//  PhoneSMSViewContronller.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class PhoneSMSViewController : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var previewBtn: UIButton!
    
    
    let contentSection = 1
    
    let cellId = "phoneSMSCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SMSContentTextCell", bundle: nil), forCellReuseIdentifier: CommonTableCell.SMSContetID)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)

    }
    
}

extension PhoneSMSViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            return CommonTableCell.createCustomerCell(cellId)
        } else {
            return CommonTableCell.createSMSContentCell(tableView)
        }
        
    }
}


extension PhoneSMSViewController {
    
    // section foot 之间的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    // section 之间高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 5
        }
        
        return CGFloat(10)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 50
        }
        return 120
    }
    
}

