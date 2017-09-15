//
//  CTSegmentsViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class CTInfoViewController: UIViewController {

    let cellId = "InfoCellId"
    let infoPate = ["姓名" , "手机" , "公司" , "生日" , "备注" , "称谓" , "分组" , "删除"]
    let contactDb = CustomerDBOp.defaultInstance()
    var groups : [Group] = []
    
    var inputtext : [UITextField] = []
    var birthDay = ""
    var groupName = ""
    
    var reloadDelegate : ContactTableViewDelegate?
    
    var currentInfo : Customer?
    var changedInfo : Customer?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CTAddUserCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.groups = self.contactDb.getGroupInDb(userId: APP_USER_ID!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CTInfoViewController : UITableViewDelegate , UITableViewDataSource {
    
    // required
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let parentView = self.parent as! CTCustomerDetailInfoViewController
        self.currentInfo = parentView.userInfo
        return createCTInfoCell(indexPath: indexPath )
    }
    
    func createCTInfoCell(indexPath:IndexPath ) -> UITableViewCell{
        let dataCell = [ self.currentInfo?.name ?? "" , self.currentInfo?.phone_number?[0] ?? "" , self.currentInfo?.company ?? "" , self.currentInfo?.birthday ?? "" , self.currentInfo?.desc ?? ""] as [Any]
        switch indexPath.section {
        case 0:
            let i = indexPath.row
            
            if indexPath.row == 3 {
                let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
                cell.textLabel?.text = self.infoPate[i]
                cell.detailTextLabel?.text = dataCell[i] as? String
                cell.accessoryType = .disclosureIndicator
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId , for: indexPath) as! CTAddUserCell
                cell.title.text = self.infoPate[i]
                cell.inputtext.text = dataCell[i] as? String
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId , for: indexPath) as! CTAddUserCell
            cell.title.text = "称谓"
            cell.inputtext.text = self.currentInfo?.nick_name
            return cell
        case 2:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "分组"
            var group_name = ""
            for g in self.groups {
                if g.id == self.currentInfo?.group_id {
                    group_name = g.group_name!
                    break
                }
            }
            cell.detailTextLabel?.text = group_name
            return cell
        case 3:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "删除联系人"
            cell.textLabel?.textColor = UIColor.red
            return cell
        case 4:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            
            let btn = UIButton.init(frame: CGRect(x: 25 , y: 7  , width: SCREEN_WIDTH - 50 , height: 30 ))
            btn.titleLabel?.text = "保存"
            btn.titleLabel?.textColor = UIColor.white
            btn.backgroundColor = ContactCommon.THEME_COLOR
            
            btn.addTarget(self, action: #selector(self.saveCustomer), for: .touchUpInside)
            cell.addSubview(btn)
            
            return cell
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "指尖科技"
            return cell
        }
//        return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
    }
    
    func saveCustomer() {
        print("--------")
        let arr : [String] = ["name","phone" , "company" , "birthday" , "desc" ,"nickName" , "group"]
        var body : [String : String] = [:]
        
        for i in 0...6 {
            
            if i < 5 {
                if i == 3 {
                    let c = self.tableView.cellForRow(at: [0,3])
                    body[arr[i]] = c?.textLabel?.text
                }else {
                    let c = self.tableView.cellForRow(at: [0 , i])  as! CTAddUserCell
                    body[arr[i]] = c.title.text
                }
            }else if i == 5 {
                let c = self.tableView.cellForRow(at: [1,0]) as! CTAddUserCell
                body[arr[i]] = c.title.text
            }else if i == 6 {
                let c = self.tableView.cellForRow(at: [2,0])
                body[arr[i]] = c?.textLabel?.text
            }
        }
        let request = NetworkUtils.postBackEnd("", body: []) { (json) in
            
        }
    }

    
    func showRole(_ message: String , index : IndexPath){
        let cell = self.tableView.cellForRow(at: index)
        if index.section == 0 {
            cell?.detailTextLabel?.text = message
        }else {
            cell?.detailTextLabel?.text = message
            self.groupName = message
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                let shooseView = ChooseDataView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                shooseView.delegate = self
                shooseView.showInViewController(self)
            }
        }else if indexPath.section == 2 {
            var titles : [String] = []
            for t in self.groups {
                titles.append( t.group_name! )
            }
            self.chooseRole(title: "请选择分组", data: titles , index:  indexPath )
        }else if indexPath.section == 3 {
            let alertController = UIAlertController(title: "确认删除该用户", message: "",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = "加载中..."
                // 同步到服务器和本地数据库
                let request = NetworkUtils.postBackEnd("D_TXL_CUS_INFO", body: ["userId" : APP_USER_ID! , "sjhms" : (self.currentInfo?.phone_number?.count)!>0 ? self.currentInfo?.phone_number?[0] ?? "" : ""  ] ){
                    json in
                    self.contactDb.deleteCustomer(cust: self.currentInfo!)
                }
                request.response(completionHandler: { _ in
                    hud.hide(animated: true)
                    if self.reloadDelegate != nil {
                        self.reloadDelegate?.reloadTableViewData()
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 5
        }else {
            return 1
        }
    }
    // end of required 
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 5
    }
}

extension CTInfoViewController : ChooseDateDelegate {
    func didchose(date: String) {
        self.birthDay = date
        self.showRole(date , index: [0 , 3])
    }
}
