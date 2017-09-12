//
//  QRCodeAddViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/9/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON


class QRCodeAddViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    fileprivate let cid = "QRAddTableViewCell"
    
    fileprivate let labels = ["姓名*", "职称", "手机*", "公司*", "公司号码" ,"地点", "邮箱"]
    
    var cells: [ScanResultCell?] = Array.init(repeating: nil, count: 7)
//    {
//        var _c:[ScanResultCell] = []
//        for l in labels {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cid) as! ScanResultCell
//            cell.label.text = l
//            _c.append(cell)
//        }
//        return _c
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "ScanResultCell", bundle: nil), forCellReuseIdentifier: cid)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44.0
        tableView.sectionHeaderHeight = 10.0
        tableView.delegate = self
        tableView.dataSource = self
        //let item: UIBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        // self.navigationItem.leftBarButtonItem = item
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(_:))))
        // self.tableView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(_:))))
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        var str: [String] = []
        for c in self.cells {
            str.append((c?.textField.text)!)
        }
        if str[0].isEmpty || str[2].isEmpty || str[3].isEmpty {
            Utils.alert("为了您的名片体验更佳，姓名、手机、公司不能为空哦～")
            return
        }
        let code = QRCode()
        code.userId = APP_USER_ID
        code.name = str[0]
        code.cellphoneNumber = str[2]
        code.company = str[3]
        code.position = str[1]
        code.companyTel = str[4]
        code.companyAddress = str[5]
        code.email = str[6]
        Utils.showLoadingHUB(view: self.view, msg: "保存中...", completion: {
            hub in
            let re = code.save() {
                json in
                // hub.hide(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
            re.response(completionHandler: {
                _ in
                hub.hide(animated: true)
            })
            
        })
        
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            for c in self.cells {
                // c.textField.becomeFirstResponder()
                c?.textField.resignFirstResponder()
            }
        }
        sender.cancelsTouchesInView = false
    }
    
}

extension QRCodeAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cid) as! ScanResultCell
        let text = NSString.init(string: self.labels[indexPath.row])
        if text.contains("*") {
            let attr = NSMutableAttributedString.init(string: text as String)
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: text.range(of: "*"))
            cell.label.attributedText = attr
        } else {
            cell.label.text = text as String
        }
        
        if row == 0 {
            cell.textField.text = AppUser.currentUser?.name
        } else if row == 2 {
            cell.textField.text = AppUser.currentUser?.cellphoneNumber
        }
        // cell.label.text = self.labels[indexPath.row]
        self.cells[indexPath.row] = cell
        return self.cells[indexPath.row]!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}
