//
//  SMSAddViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SMSAddViewController : UIViewController {
    
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    
    var segmentedViews : [UIView]!
    
    
    @IBOutlet weak var shareView: UIView!
    
    
    @IBOutlet weak var templeteView: UIView!
    
    
    @IBOutlet weak var customerView: UIView!
    

    @IBOutlet weak var phoneView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedViews = [templeteView, customerView, phoneView]
        // self.addChildViewController(<#T##childController: UIViewController##UIViewController#>)
        showSelectedView(0)
        
    }
    
    
    @IBAction func onSegmChange(_ sender: UISegmentedControl) {
        
        let idx = sender.selectedSegmentIndex
        print("select \(idx) segment")
        if idx >= segmentedViews.count {
            print("unexcepted idx, please check code or storyboard")
            return
        }
        
        showSelectedView(idx)
        // print(self.navigationController?.viewControllers ?? "[]")
    }
    
    
    func showSelectedView(_ idx : Int) {
        for (i, e) in segmentedViews.enumerated() {
            if i == idx {
                // e.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
                e.isHidden = false
            } else {
                e.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}



class SMSTemplateViewController : UIViewController {
    
//    @IBOutlet weak var customerField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    // 预览按钮
    @IBOutlet weak var previewBtn: UIButton!
    // 客户数组
    fileprivate var customers: [Customer]?
    // 称谓cell
    var appellationCell: AppellationCellView!
    // 签名cell
    var inscribeView: InscribeViewCell!
    // 日期cell
    var dateCell: UITableViewCell!
    // 已选择客户label
    var alreadyChose: UILabel!
    // 短信模板内容
    var content: String?
    // 预计执行时间
    var executeDate: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setUpTextFields()
        setUpTableView()
        previewBtn.layer.cornerRadius = 5.0
        self.view.backgroundColor = APP_BACKGROUND_COLOR
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_: )), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_: )), name: Notification.Name.UIKeyboardWillHide, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(_:))))
    }
    
    func keyBoardWillShow(_ notification: Notification) {
        let info = notification.userInfo
        let rect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = rect.origin.y - SCREEN_HEIGHT
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            self.tableView.transform = CGAffineTransform(translationX: 0, y: y/2)
        })
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableView.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate var cellId : String  = "smsTmpleteCellId"
    
    fileprivate var cellIdforInscribe: String  = "cellIdforInscribe"
    
    fileprivate let planDatePickerId = "planDatePicker"
    
    
    lazy var datePicker : PlanExecTimeCellView = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.planDatePickerId) as! PlanExecTimeCellView
        cell.isHidden = true
        return cell
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        previewBtn.snp.makeConstraints({make in
//            make.top.equalTo(self.dateCell.snp.bottom).offset(8)
//        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // customerField.isHidden = true
    }
    
    @IBAction func previewContent(_ sender: UIButton) {
        if self.customers == nil || self.customers?.count == 0 { Utils.alert("您还没有选择短信收件人");return}
        if self.content == nil { Utils.alert("您还没有选择短信模板"); return }
        let isOn = self.appellationCell.switchControl.isOn
        let cw = self.appellationCell.textField.text
        if isOn && (cw?.isEmpty)! {Utils.alert("统一称谓情况下，必须有称谓名称");return}
        if self.executeDate == nil {Utils.alert("您还没有设置短信发送时间");return}
        let sched = createSchedule()
        let preVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "SMSPreviewController") as! SMSPreviewController
        preVC.schedule = sched
        self.navigationController?.pushViewController(preVC, animated: true)
        // present(, animated: true, completion: nil)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            appellationCell.textField.resignFirstResponder()
            inscribeView.inscribeText.resignFirstResponder()
            // checknum.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func createSchedule() -> MessageSchedule {
        let sched = MessageSchedule()
        sched.userId = APP_USER_ID
        sched.content = self.content
        let appellation = self.appellationCell.textField.text
        sched.cw = (appellation?.isEmpty)! ? nil: appellation
        sched.executeTime = self.executeDate
        sched.type = "0"
        let sign = self.inscribeView.inscribeText.text!
        sched.userSign = sign.isEmpty ? (AppUser.currentUser?.name)! : sign
        for c in self.customers! {
            let kh = MsgKH(customer: c)
            if let _cw = sched.cw {
                kh.cw = _cw
            }
            kh.qm = sched.userSign
            sched.addCustomer(kh: kh)
        }
        return sched
    }
    
}



extension SMSTemplateViewController : UITableViewDataSource, UITableViewDelegate, CustomerSelectDelegate {
   
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "AppellationCellView", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.register(UINib(nibName: "InscribeViewCell", bundle: nil), forCellReuseIdentifier: cellIdforInscribe)
        self.tableView.register(UINib(nibName: "PlanExecTimeCellView", bundle: nil), forCellReuseIdentifier: planDatePickerId)
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.sectionIndexColor = APP_BACKGROUND_COLOR
               // self.tableView.ti
        self.tableView.backgroundColor = APP_BACKGROUND_COLOR
        // self.tableView.sectionIndexBackgroundColor = APP_BACKGROUND_COLOR
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 90
        } else if section == 1 {
            return 120
        } else  {
            return 50
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 5
        }
        if section == 1 {
            return 1
        }
        return CGFloat(10)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return CommonTableCell.createCustomerCell(cellId)
        case 1:
            return createTemplateCell()
        case 2:
            self.appellationCell = createAppellationCell() as! AppellationCellView
            let switchControl = self.appellationCell.switchControl
            switchControl?.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            return self.appellationCell
        case 3:
            self.inscribeView = createInscribeCell() as! InscribeViewCell
            return self.inscribeView
        case 4:
            self.dateCell =  CommonTableCell.createPlanDateCell(cellId)
            
            return self.dateCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 18
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    private func createTemplateCell() -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_nr")
        cell.textLabel?.text = "短信模版内容"
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        // cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 5
        // btn.setImage(image, for: UIControlState.highlighted)
        // cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        // cell.accessoryView = UIImageView(image: image)
        // cell.accessoryType = UITableViewCellAccessoryType.detailButton
        // cell.accessoryView = CommonTableCell.createAccessoryButton()
        return cell
    }
    
    private func createInscribeCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdforInscribe) as! InscribeViewCell
        return cell
    }
    
    private func createAppellationCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as! AppellationCellView
        return cell
    }
    
    func switchChanged() {
        let isOn = self.appellationCell.switchControl.isOn
        self.appellationCell.textField.isHidden = !isOn
    }
    
    
    func selectedRecipients(rec: [Customer]) {
        // let idx = self.tableView.indexPathForSelectedRow
        self.customers = rec
        let cell = self.tableView.cellForRow(at: [0, 0])
        let names = rec.flatMap({$0.name}).joined(separator: "、")
        cell?.textLabel?.textColor = UIColor.darkText
        cell?.textLabel?.text = names
        self.alreadyChose.text = "已选择\(rec.count)/200人"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at:indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
            custSelectVC.delegate = self
            present(custSelectVC, animated: true) {}
        case 1:
            let templateVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "TemplateSelectorController") as! TemplateSelectorController
            templateVC.tableCanSelected = true
            templateVC.templateSelectorDelegate = self
            self.navigationController?.pushViewController(templateVC, animated: true)
        case 4:
            toggleDatePicker()
        default:
            return
        }
        
    }
    
    func toggleDatePicker() {
        let shooseView = ChooseDateView.init(frame: self.view.frame)
        shooseView.delegate = self
        // self.view.addSubview(shooseView)
        shooseView.showInView(self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.tableView.scrollsToTop = true
        // print("\(self.tableView.frame)")
        // print("\(self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))")
    }
    
}

extension SMSTemplateViewController : TemplateSelectorDelegate, ChooseDateDelegate {
    
    func didSelected(_ template: SMSTemplate) {
        // 短信内容cell
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        cell?.textLabel?.text = template.content
        cell?.textLabel?.textColor = UIColor.darkText
        self.content = template.content
    }
    
    func didchose(date: String) {
        let cell = self.tableView.cellForRow(at: [4, 0])
        cell?.detailTextLabel?.text = date
        self.executeDate = date
    }
    
}








