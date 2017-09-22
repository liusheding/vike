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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CTAddUserCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.birthDay = (self.currentInfo?.birthday)!
        
        self.groups = self.contactDb.getGroupInDb(userId: APP_USER_ID!)
        
        // Do any additional setup after loading the view.
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
        
        self.reloadDelegate = ContactTableViewController.instance
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //键盘的显示
    func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo
        let rect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = rect.origin.y - UIScreen.main.bounds.size.height
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            self.parent?.view.transform = CGAffineTransform(translationX: 0, y: y/3)
        })
    }
    
    //键盘的隐藏
    func keyboardWillHide(_ notification: Notification){
        let info = notification.userInfo
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.parent?.view.transform = CGAffineTransform.identity
        }
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
        // Dispose of any resources that can be recreated.
    }
    
}

extension CTInfoViewController : UITableViewDelegate , UITableViewDataSource {
    
    // required
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
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
                cell.inputtext.borderStyle = .none
                if indexPath.row == 1{
                    cell.inputtext.keyboardType = .phonePad
                    cell.inputtext.delegate = self as? UITextFieldDelegate
                }else if indexPath.row ==  3{
                    cell.inputtext.isSecureTextEntry = true
                }
                self.inputtext.append(cell.inputtext)
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId , for: indexPath) as! CTAddUserCell
            cell.title.text = "称谓"
            cell.inputtext.text = self.currentInfo?.nick_name
            cell.inputtext.borderStyle = .none
            self.inputtext.append(cell.inputtext)
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
            let btn = UIButton.init(frame: CGRect(x: 25 , y: 0  , width: SCREEN_WIDTH - 50 , height: 50 ))
            btn.setTitle("保存", for: .normal)
            btn.titleLabel?.textColor = UIColor.white
            btn.backgroundColor = ContactCommon.THEME_COLOR
            btn.layer.cornerRadius = 10
            cell.selectionStyle = .none
            
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
        var gdId = ""
        for gd in self.groups {
            if self.groupName == gd.group_name {
                gdId = gd.id!
                break
            }
        }
        
        if self.currentInfo?.id == nil || (self.currentInfo?.id.characters.count)! == 0 {
            
            Utils.showLoadingHUB(view: self.view , completion: { ( _) in
                let request = NetworkUtils.postBackEnd("R_BASE_TXL_CUS_INFO" , body: ["userId" : APP_USER_ID! , "cellphoneNumber": (self.currentInfo?.phone_number?.count)!>0 ? self.currentInfo?.phone_number?[0] ?? "" : "" ]) { [weak self](json) in
                    let id = json["body"]["id"].stringValue
                    self?.currentInfo?.id  = id
                }
                request.response { (_) in
                    let changedCust : Customer = Customer.init(birth: self.birthDay , company: self.inputtext[2].text! , nick_name: self.inputtext[4].text! , phone_number: [self.inputtext[1].text! ] , name: self.inputtext[0].text! , id: (self.currentInfo?.id)! , is_solar: false , groupId: gdId , gender: (self.currentInfo?.gender)! , desc: self.inputtext[3].text! )
                    
                    let request = changedCust.update(cust: changedCust) { (_) in  }
                    request?.response { (_) in
                        if self.reloadDelegate != nil {
                            self.reloadDelegate?.reloadTableViewData()
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }else {
            let changedCust : Customer = Customer.init(birth: self.birthDay , company: self.inputtext[2].text! , nick_name: self.inputtext[4].text! , phone_number: [self.inputtext[1].text! ] , name: self.inputtext[0].text! , id: (self.currentInfo?.id)! , is_solar: false , groupId: gdId , gender: (self.currentInfo?.gender)! , desc: self.inputtext[3].text! )
            
            Utils.showLoadingHUB(view: self.view , msg: "正在保存...") { (_) in
                let request = changedCust.update(cust: changedCust) { (_) in
                    
                }
                request?.response { (_) in
                    if self.reloadDelegate != nil {
                        self.reloadDelegate?.reloadTableViewData()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
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
        self.tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                let shooseView = ChooseDataView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                shooseView.delegate = self
                shooseView.showInViewController(self)
                self.tableView.deselectRow(at: indexPath, animated: false)
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
                    self.contactDb.deleteCustomer(cust: self.currentInfo! , tag: "phone")
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 50
        }else {
            return 40
        }
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
