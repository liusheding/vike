//
//  ContactTableViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import MBProgressHUD
import SwiftyJSON
import Alamofire

class ContactTableViewController: UIViewController {
    
    let headIdentifier = "headView"
    let cellId = "PersonContactCell"
    let newCellId = "NewCell"
    let storyboardLocal = UIStoryboard(name: "ContactStoryboard" , bundle: nil)
    var customer : [Customers] = []  // contacts information in local db
    var groupsInDb : [Group] = []
    var isFirstTime : Bool = false
    
    var customerInServer : [Customer] = []
    var groupsInServer : [MemGroup] = []
    
    var arrContacts = [CNContact]()
    
    var contactStore = CNContactStore()
    // read contacts information from user's iphone contact
    var contactDt : [Customer] = []
    
    var ctMoreItemView : CustomerPopUpView!
    let contextDb = CustomerDBOp.defaultInstance()
    
    var changeGroupIndex : IndexPath = [-1,-1]
    
    var contactsCells:[CustomerGroup] = []
    
    @IBOutlet weak var searchBarLocal: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chooseGroup: UIView!
    
    var tableViewSel : Int = -1
    // MARK : about ... more bar item (float)
    @IBOutlet weak var ctMoreBar: UIBarButtonItem!
    
    @IBAction func ctFloatMoreBar(_ sender: Any) {
        self.ctMoreItemView.hide(!self.ctMoreItemView.isHidden)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NSLog("ContactTableviewController init ! \(NSHomeDirectory())")
        self.tableView.register(UINib(nibName: String(describing: PersonContactCell.self ), bundle: nil), forCellReuseIdentifier: cellId)
        
        //search bar information
        self.searchBarLocal.delegate = self
        self.searchBarLocal.setValue("取消", forKey: "_cancelButtonText")
        self.searchBarLocal.tintColor = APP_THEME_COLOR
        
        let imagesResouces = ["contacts_add_friend" ,"icon_tbtxl", "icon_fzgl", "icon_plcz"]
        let actionTitles = ["新增客户" ,"同步通讯录", "分组管理", "批量处理"]
        
        self.ctMoreItemView = CustomerPopUpView(titles: actionTitles, images: imagesResouces)
        self.ctMoreItemView.delegate = self as? ActionFloatViewDelegate
        self.view.addSubview(self.ctMoreItemView)
        self.ctMoreItemView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        self.chooseGroup.layer.cornerRadius = 10

        self.generateData()
    }
    
    func generateData()  {
        self.groupsInDb = self.contextDb.getGroup(userId: APP_USER_ID!)
        // get group from local db , if this count is 0 , then ,get from server
        if self.groupsInDb.count == 0 {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "加载中..."
            // get data from server , and insert to local db
            var request = NetworkUtils.postBackEnd("R_PAGED_QUERY_TXL_CUS_GROUP", body: ["userId" : APP_USER_ID! , "pageSize" : "1000" ] ){
                json in
                var gp : [MemGroup] = []
                let rsp = json["body"]
                for i in rsp["obj"].arrayValue {
                    gp.append(MemGroup.init(json: i))
                }
                self.contextDb.storeGroupArray(userId: APP_USER_ID! , gArray: gp)
            }
            
            request = NetworkUtils.postBackEnd("R_PAGED_QUERY_TXL_CUS_INFO", body: ["userId": APP_USER_ID! ,  "pageSize": "50000"] , handler: { (json) in
                
                let obj = json["body"]["obj"].arrayValue
                if obj.count > 0 {
                    var cust : [Customer] = []
                    for b in obj {
                        cust.append(Customer.init(json: b))
                    }
                    self.contextDb.insertCustomerArray(ctms: cust)
                }
            })
            
            request.response(completionHandler: { _ in
                self.contactsCells = self.contextDb.getContacts2Group(userId: APP_USER_ID! , true ) // load customer data
                hud.hide(animated: true)
                self.tableView.reloadData()
            })
        }else {
            self.contactsCells = self.contextDb.getContacts2Group(userId: APP_USER_ID! , true ) // load customer data
        }
        self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID! )
    }
    
    func createData( data : [Customer]) {
        self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID! , true)
        // validate local costomer size , because the first time spcial
        if self.customer.count == 0 { // only first or delete all app customer's data
            for cd in data {
                self.contextDb.insertCustomer(ctms: cd)
            }
            self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!, true)
            self.tableView.reloadData()
        }
        if self.contactsCells.count == 0 {
            
            print(" this is great world ")
            
        }
        self.contactsCells = []
        self.contactsCells = self.contextDb.getContacts2Group( userId: APP_USER_ID! , true )
    }
    
    func loadingData(){
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_TXL_CUS_GROUP" , body: ["userId": APP_USER_ID! , "pageSize" : ContactCommon.defaultRequestCount ] , handler: { [weak self] (json) in
            
            var gp : [MemGroup] = []
            let rsp = json["body"]
            for i in rsp["obj"].arrayValue {
                gp.append(MemGroup.init(json: i))
            }
            self?.groupsInServer = gp
            
            // generate customerGroup
            self?.contactsCells = ContactCommon.generateCustomerGroup(cust: (self?.customerInServer)!, grp: (self?.groupsInServer)!)
        })
        request.response(completionHandler: { _ in
            hud.hide(animated: true)
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.ctMoreItemView.hide(true)
        self.chooseGroup.isHidden = true
        
    }
    
    func pressCancel() {
        self.chooseGroup.isHidden = true
        self.chooseGroup.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        self.tableView.alpha = 1.0
        self.tableView.isUserInteractionEnabled = true
    }
    
}

extension ContactTableViewController : UITableViewDataSource, UITableViewDelegate , LSHeaderViewDelegate , ActionFloatViewDelegate {
    
    // 每次点击headerView时，改变group的isOpen参数，然后刷新tableview，显示或者隐藏好友信息
    func headerViewDidClickedNameView(headerView: CustomerHeaderView) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 44
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.contactsCells.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        let group = self.contactsCells[section - 1]
//        NSLog("numberOfRowsInSection \(String(describing: group.name))")
        
        if group.isOpen! {
            return (group.friends?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secNum = indexPath.section - 1
        let rowNo = indexPath.row
        
        if indexPath.section == 0 {
            let cell = UITableViewCell.init(style: UITableViewCellStyle.default , reuseIdentifier: self.newCellId)
            cell.textLabel?.text = "新的客户"
            cell.imageView?.image = UIImage(named: "pic_xkh")
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonContactCell
            let group = self.contactsCells[ secNum ]
            let customer = group.friends?[ rowNo ]
            let userName = customer?.name
            var cString : String = ""
            if !(userName?.isEmpty)! {
                let index = userName?.index( (userName?.startIndex)! , offsetBy: 1)
                cString = (userName?.substring(to: index! ))!
            }
            
            cell.name?.text = userName
            cell.phoneNumber?.text = customer?.phone_number?[0] // mutil
            cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
            
            cell.picName.setTitle(cString , for: .normal )
            cell.acception.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func updateContactCell(cust : [Customer] , currentSectionLoadingData : Int) {
        if currentSectionLoadingData < self.contactsCells.count{
            for ct in cust{
                self.contactsCells[currentSectionLoadingData].friends?.append(ct)
            }
        }
    }
    
    func clickedGroupTitle(headerView: CustomerHeaderView) {
        let section = NSIndexSet.init(index: headerView.tag + 1) as IndexSet
        
        self.tableView.reloadSections(section, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "newAddCustomer") as! CTChooseNewerController
            tableView.deselectRow(at: indexPath, animated: false)
            detailPage.tableDelegate = self
            detailPage.contactDt = self.contactDt
            detailPage.groupsInDb = self.groupsInDb
            
            self.navigationController?.pushViewController(detailPage, animated: true)
        }else {
            let cust = self.contactsCells[indexPath.section - 1].friends![indexPath.row]
            let detail = storyboardLocal.instantiateViewController(withIdentifier: "customerDetail") as! CTCustomerDetailInfoViewController
            detail.userInfo = cust
            
            self.navigationController?.pushViewController( detail , animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)  // 取消 返回后选中的状态
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let headView = CustomerHeaderView.init(reuseIdentifier: headIdentifier)
        let group = self.contactsCells[section - 1]
        
        headView.delegate = self as? LSHeaderViewDelegate
        
        headView.tag = section - 1
        
        headView.friendGroup = group
        return headView
    }
    
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        NSLog("floatViewTapItemIndex:\(type)")
        switch type {
        case .addNewCustomer:
            
            let detailPage = self.storyboardLocal.instantiateViewController(withIdentifier: "AddNewUser") as! CTAddUserViewController
            self.navigationController?.pushViewController(detailPage, animated: true )
            break
            
        case .synContacts: // read contact from iphon contacts , and add newers to default group
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "同步通讯录中..."
            
            self.requestAccessToContacts { [unowned self](success) in
                if success {
                    GetContactUtils.simpleWay2GetContactData2({ (success, tmpContact) in
                        if success {
                            var info : String = "{"
                            for key in 0..<tmpContact.count {
                                let x = tmpContact[key]
                                let pn = (x.phone_number?.count)! > 0 ? x.phone_number?[0] : " "
                                let y = "\"" + x.name! + "\":"  + "\"" + pn! + "\","
                                info += (y)
                            }
                            info.remove(at: info.index(before: info.endIndex ))
                            let body : [String:String] = [ "busi_scene" : ContactCommon.addUserBatch ,"userId" : APP_USER_ID!, "pldrkh" : info + "}" ]
                            // batch insert
                            let request = NetworkUtils.postBackEnd("C_TXL_CUS_INFO", body: body, handler: nil )
                            
                            request.response(completionHandler: { _ in
                                hud.hide(animated: true)
                                self.tableView.reloadData()
                            })
                            
                        }else {
                            print("something wrong!!")
                        }
                    })
                }
            }
            
            if self.customer.count == 0 {
                self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!)
            }
            var newCustomer : [Customer] = []
            for ct in self.contactDt {
                let result = self.contextDb.queryByIdentifer(id: (ct.phone_number?.count)!>0 ? (ct.phone_number?[0])! : "" )
                if result.count == 0 {
                    newCustomer.append(ct)
                }
            }
            if newCustomer.count > 0 {
                self.contextDb.insertCustomerArray(ctms: newCustomer)
                self.contactsCells = self.contextDb.getContacts2Group(userId : APP_USER_ID! ,  true)
                self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!)
            }
            
            // information notice
            let alertController = UIAlertController(title: "同步通讯录成功!新增\(newCustomer.count)个用户", message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            
            self.contactsCells = self.contextDb.getContacts2Group(userId: APP_USER_ID! , true)
            self.tableView.reloadData()
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            break
        case .managerGroup:  // 对分组进行增删改
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "managerGroup") as! CTManagerGroupController
            detailPage.contactsTableviewDelegate = self
            self.present(detailPage, animated: true, completion: nil)
            break
        case .batchOperate :
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "batchProcess") as! BatchProcessViewController
            self.navigationController?.pushViewController(detailPage, animated: true)
            break
        }
    }
    
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                let alertController = UIAlertController(title: "『销小秘』想访问您的通讯录", message: "销小秘需要访问通讯录，才能为您提供更好的服务体验！", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "设置", style: .default, handler: {
                    action in
                    let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)! as URL
                    if UIApplication.shared.canOpenURL(settingUrl )
                    {
                        UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)                        }
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    // left slide
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 {
            return .none
        }
        
        let changeGroup = UITableViewRowAction(style: .normal, title: "修改分组") { action, index in
            // add a view , choose group
            self.changeGroupIndex = indexPath
            self.chooseGroup.isHidden = false
            self.chooseGroup.isUserInteractionEnabled = true
            
            self.tableView.backgroundColor = UIColor.gray
            self.view.backgroundColor = UIColor.gray
            self.tableView.alpha = 0.6
            self.tableView.isUserInteractionEnabled = false
        }
        
        changeGroup.backgroundColor = UIColor.lightGray
        
        // self.customer  , local db , contactsCells
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            let cust: Customer = self.contactsCells[indexPath.section - 1].friends![indexPath.row]
            self.contactsCells[indexPath.section - 1].friends?.remove(at: indexPath.row)
            let indexTag = ContactCommon.findIndexInArray(ctm: cust, target: self.customer)
            if indexTag > -1 {
                self.customer.remove(at: indexTag )
            }
            self.contextDb.deleteCustomer(cust: cust)
            self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, changeGroup]
    }
    
}
extension ContactTableViewController: UISearchBarDelegate {
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 搜索内容置空
        searchBar.text = ""
        self.tableView.reloadData()
    }
}

extension ContactTableViewController : ContactTableViewDelegate {
    
    func reloadTableViewData( ){
        self.contactsCells = self.contextDb.getContacts2Group( userId: APP_USER_ID! , true)
        self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!)
        self.groupsInDb  = self.contextDb.getGroupInDb(userId: APP_USER_ID!)
        self.tableView.reloadData()
    }
    
}
