//
//  AddUserViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/29.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class AddUserViewController: UITableViewController {
    let icons = ["icon_sjh", "icon_xm", "icon_zw", "icon_mm"]
    let titles = ["手机号", "姓名", "职务", "密码"]
    let cellId = "addCell"
    var inputtext:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: AddUserCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(clickSaveBtn))
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            for str in self.inputtext{
                str.resignFirstResponder()
            }
        }
        sender.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 5))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "accountCell")
            cell.imageView?.image = UIImage(named: (self.icons[indexPath.row]))
            cell.textLabel?.text = self.titles[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddUserCell
            cell.imageView?.image = UIImage(named: (self.icons[indexPath.row]))
            cell.selectionStyle = .none
            cell.inputtext.placeholder = self.titles[indexPath.row]
            if indexPath.row == 0{
                cell.inputtext.keyboardType = .phonePad
            }
            self.inputtext.append(cell.inputtext)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            chooseRole()
        }
    }
    
    func showRole(_ message: String){
        let cell = self.tableView.cellForRow(at: [0,2])
        cell?.textLabel?.text = message
    }
    
    func clickSaveBtn(){
        if inputtext[0].text == ""{
            alert("手机号不能为空")
            return
        }
        
        if inputtext[1].text == ""{
            alert("姓名不能为空")
            return
        }
        
        let cell = self.tableView.cellForRow(at: [0,2])
        if cell?.textLabel?.text == "职务"{
            alert("职务身份不能为空")
            return
        }
        
        if inputtext[2].text == ""{
            alert("密码不能为空")
            return
        }
        
        print("=====Save======")
    }
    
    func alert(_ msg: String) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        self.present(uc, animated: true, completion: nil)
        return
    }
    
    func chooseRole() {
//        if AppUser.currentUser?.role?.rawValue == "客户"{
//            return
//        }
//        
        let alertController = UIAlertController(title: "", message: "选择账号申请人职务",preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
//        
//        var roles = [String]()
//        if AppUser.currentUser?.role?.rawValue == "业务员"{
//            roles = ["一级代理", "二级代理", "客户"]
//        }else if AppUser.currentUser?.role?.rawValue == "一级代理"{
//            roles = ["二级代理", "客户"]
//        } else if AppUser.currentUser?.role?.rawValue == "二级代理"{
//            roles = ["客户"]
//        }
        let roles = ["一级代理", "二级代理", "客户"]
        for role in roles{
            let roleAction = UIAlertAction(title: role, style: .destructive, handler: {_ in self.showRole(role)})
            alertController.addAction(roleAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

}
