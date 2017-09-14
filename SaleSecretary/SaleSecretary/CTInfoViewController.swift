//
//  CTSegmentsViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class CTInfoViewController: UIViewController {

    let cellId = "InfoCellId"
    let infoPate = ["姓名" , "手机" , "公司" , "生日" , "备注" , "称谓" , "分组" , "删除"]
    let contactDb = CustomerDBOp.defaultInstance()
    var groups : [Group] = []
    
    var birthDay = ""
    var groupName = ""
    
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
        return createCTInfoCell(indexPath: indexPath, data: parentView)
    }
    
    func createCTInfoCell(indexPath:IndexPath , data : CTCustomerDetailInfoViewController ) -> UITableViewCell{
        let dataCell = [data.userInfo.name ?? "" , data.userInfo.phone_number?[0] ?? "" , data.userInfo.company , data.userInfo.birthday , data.userInfo.desc] as [Any]
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
            cell.inputtext.text = data.userInfo.nick_name
            return cell
        case 2:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "分组"
            var group_name = ""
            for g in self.groups {
                if g.id == data.userInfo.group_id {
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
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "指尖科技"
            return cell
        }
        return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
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
        return 4
    }
}

extension CTInfoViewController : ChooseDateDelegate {
    func didchose(date: String) {
        self.birthDay = date
        self.showRole(date , index: [0 , 5])
    }
}
