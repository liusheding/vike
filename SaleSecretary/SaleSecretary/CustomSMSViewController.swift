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
    
    // 客户数组
    fileprivate var customers: [Customer]?
    
    // 选择客户cell
    var customerCell: UITableViewCell!
    // 内容cell
    var contentCell: SMSContentTextCell!
    // 日期cell
    var dateCell: UITableViewCell!
    // 
    var alreadyChose: UILabel!
    
    var executeDate: String!
    
    var totalWords: UILabel!
    
    lazy var datePicker : PlanExecTimeCellView = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.planDatePickerId) as! PlanExecTimeCellView
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PlanExecTimeCellView", bundle: nil), forCellReuseIdentifier: planDatePickerId)
        self.tableView.register(UINib(nibName: "SMSContentTextCell", bundle: nil), forCellReuseIdentifier: CommonTableCell.SMSContetID)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.tableFooterView?.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.sectionIndexColor = APP_BACKGROUND_COLOR
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_: )), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_: )), name: Notification.Name.UIKeyboardWillHide, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(_:))))
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            contentCell.textView.resignFirstResponder()
            // checknum.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
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
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.customers == nil || self.customers?.count == 0 { Utils.alert("您还没有选择短信收件人");return}
        if self.contentCell.textView.text.isEmpty  { Utils.alert("您还没有填写短信内容"); return }
        if self.executeDate == nil {Utils.alert("您还没有设置短信发送时间");return}
        let sched = self.createSchedule()
        Utils.showLoadingHUB(view: self.view, msg: "保存中", completion: {
            hub in
            let _ = sched.save() {
                json in
                hub.hide(animated: true)
                let vc = self.navigationController?.viewControllers
                self.navigationController?.popToViewController((vc?[(vc?.count)! - 2])!, animated: true)
            }
        })

    }
    
    func createSchedule() -> MessageSchedule {
        let sched = MessageSchedule()
        sched.userId = APP_USER_ID
        sched.content = self.contentCell.textView.text
        sched.executeTime = self.executeDate
        sched.type = "1"
        for c in self.customers! {
            let kh = MsgKH(customer: c)
            kh.sjhm = kh.sjhm.replacingOccurrences(of: "+86", with: "").trimmingCharacters(in: .whitespaces)
            sched.addCustomer(kh: kh)
        }
        return sched
    }
    
    
}


extension CustomSMSViewController : UITableViewDelegate, UITableViewDataSource {
    
    // 行高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        if section == 0 {
            return 90
        } else if section == 1  {
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
        if section == 1 || section == 2{
            return 1
        }
        return CGFloat(10)
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
        } else if section == 1 {
            self.totalWords = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 15))
            self.totalWords.text = "0字"
            self.totalWords.textAlignment = .right
            self.totalWords.backgroundColor = APP_BACKGROUND_COLOR
            self.totalWords.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            self.totalWords.textColor = UIColor.lightGray
            return self.totalWords
        } else {
            return UIView()
        }
    }
    
//    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
//        // if section == 3 && self.datePicker
//        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 加载内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            self.customerCell = CommonTableCell.createCustomerCell(cellId)
            return self.customerCell
        case 1:
            self.contentCell =  CommonTableCell.createSMSContentCell(tableView) as! SMSContentTextCell
            self.contentCell.delegte = self
            return self.contentCell
        case 2:
            self.dateCell = CommonTableCell.createPlanDateCell(cellId)
            return self.dateCell
        default:
            return tableView.cellForRow(at: indexPath)!

        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 18
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        switch section {
        case 0:
            let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
            custSelectVC.delegate = self
            present(custSelectVC, animated: true) {}
        case 2:
            toggleDatePicker()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func toggleDatePicker() {
        let shooseView = ChooseDateView.init(frame: self.view.frame)
        shooseView.delegate = self
        // self.view.addSubview(shooseView)
        shooseView.showInView(self.view)
    }
    
}

extension CustomSMSViewController: CustomerSelectDelegate, ChooseDateDelegate, SMSContentChangeDelegate {
    
    func selectedRecipients(rec: [Customer]) {
        self.customers = rec
        let cell = self.tableView.cellForRow(at: [0, 0])
        let names = rec.flatMap({$0.name}).joined(separator: "、")
        cell?.textLabel?.textColor = UIColor.darkText
        cell?.textLabel?.text = names
        self.alreadyChose.text = "已选择\(rec.count)/200人"
    }
    
    func didchose(date: String) {
        let cell = self.tableView.cellForRow(at: [2, 0])
        cell?.detailTextLabel?.text = date
        self.executeDate = date
    }
    
    func textChanged(_ text: String!) {
        self.totalWords.text = "\(text.characters.count)字"
    }
    
}


