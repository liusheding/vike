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

class ContactTableViewController: UIViewController {

    let headIdentifier = "headView"
    let cellId = "PersonContactCell"
    let newCellId = "NewCell"
    var customer : [Customers] = []  // contacts information in local db
    var groupsInDb : [Group] = []
    // read contacts information from user's iphone contact
    lazy var contactDt : [Customer] =  { [unowned self] in
            print("loading contact")
            var cust : [Customer] = []
            CNContactStore().requestAccess(for: .contacts ) {
                (isRight , error) in
                if isRight {
                    cust = GetContactUtils.loadContactData()
                } else {
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
                }
            }
            return cust
        }()
    
//    var contactDt : [Customer] = []
    var ctMoreItemView : CustomerPopUpView!
    let contextDb = CustomerDBOp.defaultInstance()

    var contactsCells:[CustomerGroup] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK : about ... more bar item (float)
    @IBOutlet weak var ctMoreBar: UIBarButtonItem!
    
    @IBAction func ctFloatMoreBar(_ sender: Any) {
        self.ctMoreItemView.hide(!self.ctMoreItemView.isHidden)
        NSLog(" push ctFloatMoreBar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // add contacts  , after change loading strategy
//        self.contactDt = GetContactUtils.loadContactData()
        
        NSLog("ContactTableviewController init ! \(NSHomeDirectory())")
        // mark register tablecell
        self.tableView.register(UINib(nibName: String(describing: PersonContactCell.self ), bundle: nil), forCellReuseIdentifier: cellId)

        // init pop up view (float)
        self.ctMoreItemView = CustomerPopUpView()
        self.ctMoreItemView.delegate = self as? ActionFloatViewDelegate
        self.view.addSubview(self.ctMoreItemView)
        self.ctMoreItemView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        
        self.contactsCells =   generateData() // load customer data
    }
    
    // default read data from db , but  first time get from  phone's contacts
    func generateData() ->  [CustomerGroup] {
        self.groupsInDb = self.contextDb.getGroup()
        if self.groupsInDb.count == 0 { // first time ,  init create default group
            self.contextDb.storeGroup(id: 0, group_name: "默认")
        }
        self.customer = self.contextDb.getCustomers()
        var result : [CustomerGroup] = []
        
        if self.contactDt.count == 0 {
            self.contactDt = GetContactUtils.loadContactData()
        }
        
        // validate local costomer size , because the first time spcial
        if customer.count == 0 { // only first or delete all app customer's data
            for cd in self.contactDt {
                self.contextDb.insertCustomer(ctms: cd)
            }
            self.customer = self.contextDb.getCustomers()
        }else {
            
        }
        for gp in self.groupsInDb {
            result.append( CustomerGroup.init(customer: self.customer, group: gp ))
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.ctMoreItemView.hide(true)
    }
    
    // 构造数据 [ 0 : A , 1: B ] B:[ 0: a , 1: b ]
//    lazy var contactsCells:[CustomerGroup] =  {
//        var friendsModelArray = [CustomerGroup]()
//        friendsModelArray = CustomerGroup.dictModel()
//        return friendsModelArray
//    }()
    
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
            return 5
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
        NSLog("numberOfRowsInSection \(String(describing: group.name))")
    
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
//            cell.picButton.backgroundColor = UIColor.white
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonContactCell
            let group = self.contactsCells[ secNum ]
            let customer = group.friends?[ rowNo ]
            let userName = customer?.name
            let index = userName?.index( (userName?.startIndex)! , offsetBy:1)
            let cString = userName?.substring(to: index! )
            
            cell.name?.text = userName
            cell.phoneNumber?.text = customer?.phone_number?[0] // mutil
            cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
//            cell.picName.set
            
            cell.picName.setTitle(cString , for: .normal )
            cell.acception.backgroundColor = UIColor.white
            return cell
        }
//        return cell
    }
    
    func clickedGroupTitle(headerView: CustomerHeaderView) {
        let section = NSIndexSet.init(index: headerView.tag + 1) as IndexSet
        self.tableView.reloadSections(section, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboardLocal = UIStoryboard(name: "ContactStoryboard" , bundle: nil)
        if indexPath.section == 0 {
            let detailPage = storyboardLocal.instantiateViewController(withIdentifier: "newAddCustomer") as! CTChooseNewerController
            self.contactDt = GetContactUtils.loadContactData()
            tableView.deselectRow(at: indexPath, animated: false)
            detailPage.contactDt = self.contactDt
            detailPage.localDbContact = self.customer
            detailPage.groupsInDb = self.groupsInDb
            self.navigationController?.pushViewController(detailPage, animated: true)
        }else {
//            let selectedRow = tableView.cellForRow(at: indexPath)
            let cust: Customer = self.contactsCells[indexPath.section - 1].friends![indexPath.row]
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
        NSLog("-------section" + "\(section)" )
        
        headView.friendGroup = group
        return headView
        
    }
    
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        NSLog("floatViewTapItemIndex:\(type)")
        switch type {
            case .synContacts: // read contact from iphon contacts , and add newers to default group
                NSLog("press syn contact")
                if self.customer.count == 0 {
                    self.customer = self.contextDb.getCustomers()
                }
                var newCustomer : [Customer] = []
                for ct in self.contactDt {
                    if !ContactCommon.isContain(ctm: ct , target: self.customer){
                        newCustomer.append(ct)
                    }
                }
                if newCustomer.count > 0 {
                    self.contextDb.insertCustomerArray(ctms: newCustomer)
                }
                
                // information notice
                let alertController = UIAlertController(title: "同步通讯录成功!新增\(newCustomer.count)个用户", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                
                break
            case .managerGroup:
//                self.contextDb.storeGroup(id: 0, group_name: "默认")
//                self.contextDb.insertCustomer(ctms: Customer.init(birth: "1988-12-10", company: "指尖科技", nick_name: "paopao", phone_number: ["18910893322"], name: "hanpaopao"))
                break
            case .batchOperate :
                let g = self.contextDb.getGroup()
                for i in g {
                    print("dt : \(String(describing: i.group_name))")
                }
                break
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
     */
    
    // left slide 
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 {
            return .none
        }
        
        let changeGroup = UITableViewRowAction(style: .normal, title: "修改分组") { action, index in
            // add a view , choose group
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
    
    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("删除事件.....")
//        }
//    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
