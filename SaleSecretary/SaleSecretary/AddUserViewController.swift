//
//  AddUserViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/29.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class AddUserViewController: UITableViewController {
    let titles = [0:["姓名", "手机", "性别", "称谓", "公司", "生日", "备注"],1:["分组"]]
    let mustcellId = "mustAddCell"
    let cellId = "addCell"
    var inputtext:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: MustAddCell.self), bundle: nil), forCellReuseIdentifier: mustcellId)
        tableView.register(UINib(nibName: String(describing: AddUserCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        
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
        if section == 0 {
            return 5
        } else {
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var vHeight = 10
        if section == 0{
            vHeight = 5
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: vHeight))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.titles[section]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 5{
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "addUserCell")
                cell.textLabel?.text = self.titles[0]?[5]
                cell.accessoryType = .disclosureIndicator
                return cell
            }else if indexPath.row == 0 || indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: mustcellId, for: indexPath) as! MustAddCell
                cell.title.text = self.titles[0]?[indexPath.row]
                cell.selectionStyle = .none
                self.inputtext.append(cell.inputtext)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddUserCell
                cell.title.text = self.titles[0]?[indexPath.row]
                cell.selectionStyle = .none
                self.inputtext.append(cell.inputtext)
                return cell
            }
        }else{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "addUserCell")
            cell.textLabel?.text = self.titles[indexPath.section]?[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func clickSaveBtn(){
        for (index, text) in inputtext.enumerated(){
            if index == 0 && text.text! == ""{
                alert("姓名不能为空")
                return
            }else if index == 1 && text.text! == ""{
                alert("手机号不能为空")
                return
            }
            print("\(text.text!)")
        }
        print("=====Save======")
    }
    
    func alert(_ msg: String) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        self.present(uc, animated: true, completion: nil)
        return
    }
}
