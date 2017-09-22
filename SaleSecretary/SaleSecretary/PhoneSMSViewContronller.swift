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
    
    var alreadyChose: UILabel!
    
    var contentCell: SMSContentTextCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SMSContentTextCell", bundle: nil), forCellReuseIdentifier: CommonTableCell.SMSContetID)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_: )), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_: )), name: Notification.Name.UIKeyboardWillHide, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(_:))))
    }
    
    var messageVC: MFMessageComposeViewController?
    
    
    func keyBoardWillShow(_ notification: Notification) {
        let info = notification.userInfo
        let rect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = rect.origin.y - SCREEN_HEIGHT
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            self.parent?.view.transform = CGAffineTransform(translationX: 0, y: y/3)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: y/3)
        })
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.parent?.view.transform = CGAffineTransform.identity
            self.tableView.transform = CGAffineTransform.identity
        }
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            contentCell.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
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
            self.contentCell = CommonTableCell.createSMSContentCell(tableView) as! SMSContentTextCell
            self.contentCell.placeHolder.text = "短信内容"
            return self.contentCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 18
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            self.alreadyChose = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 15))
            self.alreadyChose.text = "已选择0/200人"
            self.alreadyChose.textAlignment = .right
            self.alreadyChose.backgroundColor = APP_BACKGROUND_COLOR
            self.alreadyChose.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            self.alreadyChose.textColor = UIColor.lightGray
            return self.alreadyChose
        } else {
            return UIView()
        }
    }
}


extension PhoneSMSViewController {
    
    
    // section 之间高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        if section == 1 {
            return 1
        }
        return CGFloat(10)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 90
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
        self.alreadyChose.text = "已选择\(rec.count)/200人"
        return
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.messageVC?.dismiss(animated: true, completion: nil)
    }
}

