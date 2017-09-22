//
//  CTAddUserViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/9/5.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTAddUserViewController: UITableViewController {

    let titles = [0:["姓名", "手机", "性别", "称谓", "公司", "生日", "备注"],1:["分组"]]
    let mustcellId = "mustAddCell"
    let cellId = "addCell"
    var inputtext:[UITextField] = []
    var groups : [Group] = []
    let contactDb = CustomerDBOp.defaultInstance()
    var groupName = ""
    var genderChoose = ""
    var birthDay = ""
    
    var tableDelegate : ContactTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        tableView.register(UINib(nibName: String(describing: MustAddCell.self), bundle: nil), forCellReuseIdentifier: mustcellId)
        tableView.register(UINib(nibName: String(describing: CTAddUserCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        self.groups = self.contactDb.getGroupInDb(userId: APP_USER_ID!)
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
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell.textLabel?.text = self.titles[0]?[5]
                cell.detailTextLabel?.textColor = UIColor.black
                cell.accessoryType = .disclosureIndicator
                return cell
            }else if indexPath.row == 0 || indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: mustcellId, for: indexPath) as! MustAddCell
                cell.inputtext.borderStyle = .none
                cell.title.text = self.titles[0]?[indexPath.row]
                cell.selectionStyle = .none
                self.inputtext.append(cell.inputtext)
                return cell
            }else if  indexPath.row == 0 || indexPath.row == 2{
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "addUserCell")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell.textLabel?.text = self.titles[0]?[indexPath.row]
                cell.accessoryType = .disclosureIndicator
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CTAddUserCell
                cell.inputtext.borderStyle = .none
                cell.title.text = self.titles[0]?[indexPath.row]
                cell.selectionStyle = .none
                self.inputtext.append(cell.inputtext)
                return cell
            }
        }else{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "addUserCell")
            cell.textLabel?.text = self.titles[indexPath.section]?[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
    }
    
    func chooseRole(title : String , data : [String] , index : IndexPath) {
        
        let alertController = UIAlertController(title: "", message: title ,preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for role in data{
            let roleAction = UIAlertAction(title: role, style: .destructive, handler: {_ in self.showRole(role , index: index)})
            alertController.addAction(roleAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showRole(_ message: String , index : IndexPath){
        let cell = self.tableView.cellForRow(at: index)
        if index.section == 0 {
            cell?.detailTextLabel?.text = message
            self.genderChoose = message
        }else {
            cell?.detailTextLabel?.text = message
            self.groupName = message
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 5{
            let shooseView = ChooseDateView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            shooseView.delegate = self
            shooseView.showInViewController(self)
            tableView.deselectRow(at: indexPath, animated: false)
        }else if indexPath.section == 0 && indexPath.row == 2 {
            self.chooseRole(title: "请选择性别", data: ["男", "女"] , index:  indexPath)
            tableView.deselectRow(at: indexPath, animated: false)
        }else if indexPath.section == 1 {
            var titles : [String] = []
            for t in self.groups {
                titles.append( t.group_name! )
            }
            tableView.deselectRow(at: indexPath, animated: false)
            self.chooseRole(title: "请选择分组", data: titles , index:  indexPath )
        }
    }
    
    func clickSaveBtn(){
        for (index, text) in inputtext.enumerated(){
            if index == 0 && text.text! == ""{
                alert("姓名不能为空！")
                return
            }else if index == 1 && text.text! == ""{
                alert("手机号不能为空！")
                return
            }
        }
        if self.groupName.characters.count == 0 {
            alert("请选择分组！")
            return
        }
        var gdId = ""
        for gd in self.groups {
            if self.groupName == gd.group_name {
                gdId = gd.id!
                break
            }
        }
        
        let cust = Customer.init(birth: self.birthDay , company: self.inputtext[3].text ?? "", nick_name: self.inputtext[2].text ?? "" , phone_number: [self.inputtext[1].text ?? ""], name: self.inputtext[0].text ?? "" , id: ""  ,is_solar: true , groupId: gdId , gender: self.genderChoose == "男" ? 1 : 0 , desc: self.inputtext[4].text ?? "" )
        let request = cust.save { (_) in  }
        
        request?.response(completionHandler: { _ in
            self.navigationController?.popViewController(animated: true)
            if self.tableDelegate != nil {
                self.tableDelegate?.reloadTableViewData()
            }
        })
        
    }
    
    func alert(_ msg: String) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        self.present(uc, animated: true, completion: nil)
        return
    }
}
extension CTAddUserViewController : ChooseDateDelegate {
    func didchose(date: String) {
        self.birthDay = date
        self.showRole(date , index: [0 , 5])
    }
}
