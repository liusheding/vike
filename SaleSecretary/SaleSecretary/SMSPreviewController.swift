//
//  SMSPreviewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit
import YBAttributeTextTapAction

enum SMSPosition {
    case TITLE
    case CONTENT
    case INSCRIBE
}

protocol SMSMessageModifyDelegate {
    func sendMidify(_ str: String, position: SMSPosition, indexPath: IndexPath) -> Void
}

let MSG_CW = "【称谓】"
let MSG_QM = "【签名】"


class SMSPreviewController : UIViewController {
    

    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var schedule: MessageSchedule!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.backgroundColor = APP_BACKGROUND_COLOR
    }
   
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion:  nil)
        
    }
    
    @IBOutlet weak var confirmAction: UIBarButtonItem!
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        
        Utils.showLoadingHUB(view: self.view, msg: "保存中..." ,completion: {
            hub in
            let _ = self.schedule.save() {
                json in
                hub.hide(animated: true)
                let vc = self.navigationController?.viewControllers
                self.navigationController?.popToViewController((vc?[(vc?.count)! - 3])!, animated: true)
            }
        })
        
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "previewToList" {
            return true
        }
        return super.shouldPerformSegue(withIdentifier: identifier, sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
    }
    
}

extension SMSPreviewController : UITableViewDataSource, UITableViewDelegate {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schedule.customers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default , reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 5
        let content = schedule.content
        let kh = schedule.customers[indexPath.section]
        let cw = self.schedule.cw ?? kh.cw
        let text = content?.replacingOccurrences(of: MSG_CW, with: cw!).replacingOccurrences(of: MSG_QM, with: kh.qm!)
        let nsText = NSString.init(string: text!)
        // 如果使用的统一称谓
        let qmRange = nsText.range(of: kh.qm!)
        cell.textLabel?.text = nsText as String
        let attr = NSMutableAttributedString(string: text!)
        if schedule.containsCW! {
            let cwRange = nsText.range(of: cw!)
            if self.schedule.cw == nil {
                attr.addAttribute(NSForegroundColorAttributeName, value: APP_THEME_COLOR, range: cwRange)
            }
        }
        attr.addAttribute(NSForegroundColorAttributeName, value: APP_THEME_COLOR, range: qmRange)
        cell.textLabel?.attributedText = attr
        
        func cick(str: String?, range: NSRange, int: Int) {
            print("点击了\(str!) 标签  {\(range.location) , \(range.length)} - \(int)")
            let pos: SMSPosition = int == 0 ? .TITLE : .INSCRIBE
            let alert = SMSPreviewController.alertWithTextField("短信修改", msg: "请输入修改后的内容", text: str!, position: pos, indexPath: indexPath ,delegate: self)
            self.present(alert, animated: true, completion: nil)
        }
        // cell.textLabel?.enabledTapEffect = false
        if self.schedule.cw == nil && self.schedule.containsCW! {
            cell.textLabel?.yb_addAttributeTapAction(with: [cw!, kh.qm!], tapClicked: cick)
        } else {
            cell.textLabel?.yb_addAttributeTapAction(with: [kh.qm!], tapClicked: cick)
        }
        return cell
    }
}

extension SMSPreviewController : SMSMessageModifyDelegate {
    
    func sendMidify(_ str: String, position: SMSPosition, indexPath: IndexPath) {
        let msg = self.schedule.customers[indexPath.section]
        if position == .TITLE {
            msg.cw = str
        } else {
            msg.qm = str
        }
        self.tableView.reloadData()
    }
    
}


extension SMSPreviewController  {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public static func alertWithTextField(_ title :String, msg: String, placeHolder : String = "输入框",
                                          text: String? = nil, position: SMSPosition,
                                          indexPath: IndexPath,
                                          delegate: SMSMessageModifyDelegate?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg , preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = placeHolder
            if text != nil {
                textField.text = text
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let content = alertController.textFields!.first!
            if delegate != nil {
                delegate?.sendMidify(content.text ?? "", position: position, indexPath: indexPath)
            }
            print("修改后的内容：\(content.text ?? "") ")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }
    
}







