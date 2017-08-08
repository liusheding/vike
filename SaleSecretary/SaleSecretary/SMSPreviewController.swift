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
    func sendMidify(_ str: String, position: SMSPosition) -> Void
}


class SMSPreviewController : UIViewController {
    

    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var msgs: [SMSMessage] = {
        let rp = Recipient(name: "刘德华", phone: "18519283902")
        let m = SMSMessage("我有过多次这样的奇遇，从天堂到地狱只在瞬息之间；每一朵可爱、温柔的浪花，都成了突然崛起、随即倾倒的高山。每一滴海水都变脸变色，刚刚还是那样美丽、蔚蓝；旋涡纠缠着旋涡，我被抛向高空又投进深海",
                           time: Date(),
                           recipent: rp,
                           inscribe: "刘社定同学")
        return [m]
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
    }
   
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion:  nil)
        
    }
    
    @IBOutlet weak var confirmAction: UIBarButtonItem!
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default , reuseIdentifier: "cell")
        let msg = msgs[0]
        let text = "\(msg.title)，\(msg.content!) \(msg.inscribe)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 5
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(NSForegroundColorAttributeName, value: APP_THEME_COLOR, range: NSMakeRange(0, msg.lengths[0]))
        let st = msg.lengths[0] + msg.lengths[1] + 2
        attr.addAttribute(NSForegroundColorAttributeName, value: APP_THEME_COLOR, range: NSMakeRange(st, msg.lengths[2]))
        cell.textLabel?.attributedText = attr
        
        func cick(str: String?, range: NSRange, int: Int) {
            print("点击了\(str!) 标签  {\(range.location) , \(range.length)} - \(int)")
            let pos: SMSPosition = int == 0 ? .TITLE : .INSCRIBE
            let alert = SMSPreviewController.alertWithTextField("短信修改", msg: "请输入修改后的内容", text: str!, position: pos ,delegate: self)
            self.present(alert, animated: true, completion: nil)
        }
        // cell.textLabel?.enabledTapEffect = false
        
        cell.textLabel?.yb_addAttributeTapAction(with: [msg.title, msg.inscribe], tapClicked: cick)
        return cell
    }
}

extension SMSPreviewController : SMSMessageModifyDelegate {
    
    func sendMidify(_ str: String, position: SMSPosition) {
        let msg = self.msgs[0]
        if position == .TITLE {
            msg.recipent.title = str
        } else {
            msg.inscribe = str
        }
        self.msgs = [msg]
        self.tableView.reloadData()
    }
    
}


extension SMSPreviewController  {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public static func alertWithTextField(_ title :String, msg: String, placeHolder : String = "输入框",
                                          text: String? = nil, position: SMSPosition,
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
                delegate?.sendMidify(content.text ?? "", position: position)
            }
            print("修改后的内容：\(content.text ?? "") ")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }
    
}







