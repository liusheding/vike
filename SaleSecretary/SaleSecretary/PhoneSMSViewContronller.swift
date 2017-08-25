//
//  PhoneSMSViewContronller.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MessageUI


class PhoneSMSViewController : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var previewBtn: UIButton!
    
    
    let contentSection = 1
    
    let cellId = "phoneSMSCellId"
    
    fileprivate var customers:[Customer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SMSContentTextCell", bundle: nil), forCellReuseIdentifier: CommonTableCell.SMSContetID)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)

    }
    
    var messageVC: MFMessageComposeViewController?
    
    @IBAction func confirmAction(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            self.messageVC = MFMessageComposeViewController()
            let contentCell = self.tableView.cellForRow(at: [1,0]) as! SMSContentTextCell
            self.messageVC?.body =  contentCell.textView.text
            self.messageVC?.recipients = self.customers?.flatMap({cust in return cust.phone_number![0]})
            self.messageVC?.messageComposeDelegate = self
            self.present(messageVC!, animated: true, completion: nil)
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        if section == 0 {
            let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
            custSelectVC.delegate = self
            present(custSelectVC, animated: true) {}
        }
    }
}

extension PhoneSMSViewController: CustomerSelectDelegate, MFMessageComposeViewControllerDelegate {
    
    func selectedRecipients(rec: [Customer]) {
        
        // let idx = self.tableView.indexPathForSelectedRow
        self.customers = rec
        let cell = self.tableView.cellForRow(at: [0, 0])
        let names = rec.flatMap({$0.name}).joined(separator: "、")
        cell?.textLabel?.textColor = UIColor.darkText
        cell?.textLabel?.text = names
        
        return
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.messageVC?.dismiss(animated: true, completion: nil)
    }
}

