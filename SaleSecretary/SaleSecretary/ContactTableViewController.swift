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
    
    var contactsCells:[CustomerGroup] = [] {
        
        didSet {
            if self.contactsCells.count == 0 {return}
            // 清空
            self.searchDelegator.origin = []
            for g in self.contactsCells {
                if let f = g.friends {
                    self.searchDelegator.origin += f
                }
            }
        }
        
    }
    
    @IBOutlet weak var searchBarLocal: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chooseGroup: UIView!
    
    static var instance: ContactTableViewController!
    
    var tableViewSel : Int = -1
    // MARK : about ... more bar item (float)
    @IBOutlet weak var ctMoreBar: UIBarButtonItem!
    
    @IBAction func ctFloatMoreBar(_ sender: Any) {
        self.ctMoreItemView.hide(!self.ctMoreItemView.isHidden)
    }
    // 搜索字段
    let searchDelegator: ContactSearchDelegator = ContactSearchDelegator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints({make in
            make.bottom.equalToSuperview().offset(-44)
        })
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        NSLog("ContactTableviewController init ! \(NSHomeDirectory())")
        self.tableView.register(UINib(nibName: String(describing: PersonContactCell.self ), bundle: nil), forCellReuseIdentifier: cellId)
        
        //search bar information
        self.searchBarLocal.delegate = self
        self.searchBarLocal.setValue("取消", forKey: "_cancelButtonText")
        self.searchBarLocal.tintColor = APP_THEME_COLOR
        
        let imagesResouces = ["icon_xjzxjh" ,"icon_tbtxl", "icon_fzgl", "icon_plcz"]
        let actionTitles = ["新增客户" ,"同步通讯录", "分组管理", "批量处理"]
        
        self.ctMoreItemView = CustomerPopUpView(titles: actionTitles, images: imagesResouces)
        self.ctMoreItemView.delegate = self as? ActionFloatViewDelegate
        self.view.addSubview(self.ctMoreItemView)
        self.ctMoreItemView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        self.chooseGroup.layer.cornerRadius = 10

        self.generateData()
        
        // 搜索
        self.searchDisplayController?.searchResultsDelegate = self.searchDelegator
        self.searchDisplayController?.searchResultsDataSource = self.searchDelegator
        self.searchDisplayController?.searchResultsTableView.register(UINib(nibName: String(describing: PersonContactCell.self ), bundle: nil), forCellReuseIdentifier: "customerSearchCellId")
        self.searchDisplayController?.delegate = self.searchDelegator
        
        ContactTableViewController.instance = self
        self.searchDelegator.parent = self
    }
    
    func generateData()  {
        self.groupsInDb = self.contextDb.getGroup(userId: APP_USER_ID!)
        // get group from local db , if this count is 0 , then ,get from server
        if self.groupsInDb.count == 0 {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "第一次同步数据中..."
            // get data from server , and insert to local db
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_TXL_CUS_GROUP", body: ["userId" : APP_USER_ID! , "pageSize" : "1000" ] ){
                json in
                var gp : [MemGroup] = []
                let rsp = json["body"]
                for i in rsp["obj"].arrayValue {
                    gp.append(MemGroup.init(json: i))
                }
                // sort 默认分组第一个
                if gp[0].group_name != ContactCommon.groupDefault as String {
                    var tmp : MemGroup?
                    var tmpTag  = -1
                    for i in 0..<gp.count {
                        if gp[i].group_name == ContactCommon.groupDefault as String {
                            tmp = gp[i]
                            tmpTag = i
                            break
                        }
                    }
                    if tmpTag > 0 {
                        gp[tmpTag] = gp[0]
                        gp[0] = tmp!
                    }
                }
                self.contextDb.storeGroupArray(userId: APP_USER_ID! , gArray: gp)
                
                let rt = NetworkUtils.postBackEnd("R_PAGED_QUERY_TXL_CUS_INFO", body: ["userId": APP_USER_ID! ,  "pageSize": "50000"] , handler: { (json) in
                    
                    let obj = json["body"]["obj"].arrayValue
                    if obj.count > 0 {
                        var cust : [Customer] = []
                        for b in obj {
                            cust.append(Customer.init(json: b))
                        }
                        self.contextDb.insertCustomerArray(ctms: cust, groupId: "")
                    }
                })
                rt.response(completionHandler: {_ in
                    self.contactsCells = self.contextDb.getContacts2Group(userId: APP_USER_ID! , true ) // load customer data
                    hud.hide(animated: true)
                    self.tableView.reloadData()
                })
            }
            request.response(completionHandler: { _ in
                
            })
        }else {
            self.contactsCells = self.contextDb.getContacts2Group(userId: APP_USER_ID! , true ) // load customer data
        }
        self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID! )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseGroupMainPage"{
            let vc = segue.destination as! CTChangeGroupViewController
            vc.groupArr =  MemGroup.toMemGroup(dbGroup: self.contextDb.getGroupInDb(userId: APP_USER_ID! , true))
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.searchDisplayController?.isActive = false
    }
    
    func pressCancel() {
        self.chooseGroup.isHidden = true
        self.chooseGroup.isUserInteractionEnabled = false
        self.searchBarLocal.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isUserInteractionEnabled  = true
        self.ctMoreBar.isEnabled = true
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
            return 5
        }else {
            return 50
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
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
            
            self.navigationController?.pushViewController(detailPage, animated: true)
        }else {
            let cust = self.contactsCells[indexPath.section - 1].friends![indexPath.row]
            let detail = storyboardLocal.instantiateViewController(withIdentifier: "customerDetail") as! CTCustomerDetailInfoViewController
            detail.userInfo = cust
            detail.contactViewController = self
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
    
    func synLimited(cust : [Customer] , start : Int , juhua : MBProgressHUD ) {
        var terminal = false
        var maxIndex = ContactCommon.maxSyncNum
        if  ( cust.count - start ) <= ContactCommon.maxSyncNum {
            terminal = true
            maxIndex = (cust.count - start)
        }
        
        var info : String = "{"
        for key in 0..<maxIndex {
            let x = cust[start + key]
            let pn = (x.phone_number?.count)! > 0 ? x.phone_number?[0] : " "
            let y = "\"" + x.name! + "\":"  + "\"" + pn! + "\","
            info += (y)
        }
        
        info.remove(at: info.index(before: info.endIndex ))
        let body : [String:String] = [ "busi_scene" : ContactCommon.addUserBatch ,"userId" : APP_USER_ID!, "pldrkh" : info + "}" ]
        // batch insert
        let request = NetworkUtils.postBackEnd("C_TXL_CUS_INFO", body: body ){
            json in
        }
        request.response { (_) in
            if terminal {
                juhua.hide(animated: true)
                self.tableView.reloadData()
                // information notice
                let alertController = UIAlertController(title: "同步通讯录成功!新增\(cust.count)个用户", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                let defaultId  = ContactCommon.getDefaultId(groups:  self.contextDb.getGroupInDb(userId: APP_USER_ID!) )
                self.contextDb.insertCustomerArray(ctms: cust , groupId: defaultId )
                self.contactsCells = self.contextDb.getContacts2Group(userId : APP_USER_ID! ,  true)
                self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!)

                self.tableView.reloadData()
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }else {
                self.synLimited(cust: cust , start: start + ContactCommon.maxSyncNum , juhua: juhua )
            }
        }
    }
    
    func synContact2Server(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "同步通讯录中..."
        
        self.requestAccessToContacts { [unowned self](success) in
            if success {
                GetContactUtils.simpleWay2GetContactData2({ (success, tmpContact) in
                    if success {
                        if self.customer.count == 0 {
                            self.customer = self.contextDb.getCustomerInDb(userId: APP_USER_ID!)
                        }
                        var newCustomer : [Customer] = []
                        for ct in tmpContact {
                            let result = self.contextDb.queryByIdentifer(id: (ct.phone_number?.count)!>0 ? (ct.phone_number?[0])! : "" )
                            if result.count == 0 {
                                newCustomer.append(ct)
                            }
                        }
                        if newCustomer.count > 0 {
                            self.synLimited(cust: newCustomer , start: 0 , juhua: hud)
                            
                        }else {
                            hud.hide(animated: true)
                        }
                    }else {
                        print("something wrong!!")
                    }
                })
            }
        }
    }
    
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        NSLog("floatViewTapItemIndex:\(type)")
        switch type {
        case .addNewCustomer:
            let detailPage = self.storyboardLocal.instantiateViewController(withIdentifier: "AddNewUser") as! CTAddUserViewController
            detailPage.tableDelegate = self
            self.navigationController?.pushViewController(detailPage, animated: true )
            break
            
        case .synContacts: // read contact from iphon contacts , and add newers to default group
            let alertController = UIAlertController(title: "同步通讯录", message: "会将您手机通讯录数据同步到云端！",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "添加", style: .default, handler: {
                action in
                self.synContact2Server()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        case .managerGroup:  // 对分组进行增删改
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "managerGroup") as! CTManagerGroupController
            detailPage.contactsTableviewDelegate = self
            self.navigationController?.pushViewController(detailPage, animated: true)
            break
        case .batchOperate :
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "batchProcess") as! BatchProcessViewController
            self.navigationController?.pushViewController(detailPage, animated: true)
//            self.contactPressTest()
            break
        }
    }
    
    func contactPressTest() {
        var arrContact : [Customer] = []
        let cust = Customer.init(name: "abhtest1", phoneNum: ["177898"])
        for i in 0..<5000 {
            var x = ""
            for _ in 0..<( 5 - String(i).characters.count ) {
                x.append("0")
            }
            x.append("\(i)")
            let str = cust.phone_number![0]+x
            
            arrContact.append(Customer.init(name: cust.name! + "\(i)" , phoneNum: [ str ] ))
            x = ""
        }
        
        GetContactUtils.writeData(cust: arrContact)
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
//            self.view.isUserInteractionEnabled = false
            self.searchBarLocal.isUserInteractionEnabled = false
            self.tabBarController?.tabBar.isUserInteractionEnabled  = false
            self.ctMoreBar.isEnabled = false
        }
        
        changeGroup.backgroundColor = UIColor.lightGray
        
        // self.customer  , local db , contactsCells
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            let cust: Customer = self.contactsCells[indexPath.section - 1].friends![indexPath.row]
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "加载中..."
            
            let request = NetworkUtils.postBackEnd("D_TXL_CUS_INFO", body: ["userId" : APP_USER_ID! , "sjhms" : (cust.phone_number?.count)! > 0 ? cust.phone_number?[0] ?? "" : "" ], handler: { (json) in
                self.contactsCells[indexPath.section - 1].friends?.remove(at: indexPath.row)
                let indexTag = ContactCommon.findIndexInArray(ctm: cust, target: self.customer)
                if indexTag > -1 {
                    self.customer.remove(at: indexTag )
                }
                self.contextDb.deleteCustomer(cust: cust , tag: "phone")
                self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            })
            request.response(completionHandler: { (_) in
                hud.hide(animated: true)
            })
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
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.reloadData()
    }
    
}

class ContactSearchDelegator: NSObject, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate {
    
    let storyboardLocal = UIStoryboard(name: "ContactStoryboard" , bundle: nil)
    
    var parent: ContactTableViewController!
    
    var origin: [Customer] = []
    
    var customers: [Customer] = []
    
    public override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerSearchCellId", for: indexPath) as! PersonContactCell
        let row = indexPath.row
        let customer = self.customers[row]
        let userName = customer.name
        var cString : String = ""
        if !(userName?.isEmpty)! {
            let index = userName?.index( (userName?.startIndex)! , offsetBy: 1)
            cString = (userName?.substring(to: index! ))!
        }
        
        cell.name?.text = userName
        cell.phoneNumber?.text = customer.phone_number?[0] // mutil
        cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
        
        cell.picName.setTitle(cString , for: .normal )
        cell.acception.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cust = self.customers[indexPath.row]
        let detail = storyboardLocal.instantiateViewController(withIdentifier: "customerDetail") as! CTCustomerDetailInfoViewController
        detail.userInfo = cust
        detail.contactViewController = parent
        parent.navigationController?.pushViewController( detail , animated: true)
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        if self.origin.count == 0 { return false }
        if searchString == nil { return false }
        let str = searchString!
        var result: [Customer] = []
        if Utils.inputOnlyNumbers(str: str) {
            if str.characters.count <= 1 {return false}
            for u in self.origin {
                if u.phone_number == nil || u.phone_number!.count == 0 { continue}
                let phone = u.phone_number![0]
                if (phone.contains(str)) {
                    result.append(u)
                }
            }
        } else {
            for u in self.origin {
                if (u.name?.contains(str))! {
                    result.append(u)
                }
            }
        }
        self.customers = result
        return true
    }
    
    
}
