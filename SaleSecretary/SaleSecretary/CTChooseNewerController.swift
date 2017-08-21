//
//  CTChooseNewerController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/9.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
//contact frame
//import AddressBook  ios 9 below
//import AddressBookUI
import Contacts

class CTChooseNewerController: UIViewController {
    
    let store = CNContactStore()
    var contactDt : [Customer] = [] // phone contacts data
    var localDbContact : [Customers] = []
    var groupsInDb : [Group] = []
    var newCustomer : [Customer ] = []
    
//    lazy var contactDt : [Customer] =  { [unowned self] in
//        print("loading contact")
//        var cust : [Customer] = []
//        self.store.requestAccess(for: .contacts ) {
//            (isRight , error) in
//            if isRight {
//                self.loadContactData()
//            } else {
//                print("no right")
//            }
//        }
//        return cust
//    }()
    
    let cellId = "contactsCell"
    
    @IBOutlet weak var chooseAlertView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chooseAlertView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "新的客户"
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        self.tableView.register(UINib(nibName: String(describing: PersonContactCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        // init contacts data
        findNewCustomer()
    }
    
    func findNewCustomer(){
        for cd in self.contactDt {
            if !ContactCommon.isContain(ctm: cd , target: self.localDbContact ){
               self.newCustomer.append(cd)
            }
        }
        NSLog("new customer's page , find \(self.newCustomer.count) new person")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseGroupView(_ sender: UIButton!) {
        self.chooseAlertView.isHidden = false
        self.chooseAlertView.isUserInteractionEnabled = true
//        self.chooseAlertView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.lightGray
        self.tableView.alpha = 0.6
        self.tableView.isUserInteractionEnabled = false
    }
    
    func pressCancel() {
        self.chooseAlertView.isHidden = true
        self.chooseAlertView.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.clear
        self.tableView.alpha = 1.0
        self.tableView.isUserInteractionEnabled = true
    }

    // for user add new customer to app db , and choose the group
    func chooseGroup(_ sender: UIButton!) {
        let alertController = UIAlertController(title: "选择分组", message: "为新朋友选择分组！", preferredStyle: .alert)
        let localViewController = AddCustomerViewController()
        localViewController.groupArr = self.groupsInDb
        alertController.addChildViewController(localViewController)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

extension CTChooseNewerController : UITableViewDelegate , UITableViewDataSource  {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactDt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! PersonContactCell
        var tmpCustomer : Customer
        var flag = false
        if indexPath.row >= self.newCustomer.count {
            tmpCustomer = self.contactDt[indexPath.row - newCustomer.count]
        }else {
            tmpCustomer = self.newCustomer[indexPath.row]
            flag = true
        }
        
        let userName = tmpCustomer.name
        let index = userName?.index( (userName?.startIndex)! , offsetBy:1)
        let cString = userName?.substring(to: index! )
        
        cell.picName.setTitle( cString , for: .normal )
        cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
        cell.name.text = userName
        if flag {
            cell.acception.setTitle( "添加" , for: .normal )
            cell.acception.setTitleColor(UIColor.white , for: .normal )
            cell.acception.addTarget( self , action: #selector(self.chooseGroupView(_:)) , for: UIControlEvents.touchDown)
        }else {
            cell.acception.setTitle( "已添加" , for: .normal )
            cell.acception.setTitleColor(UIColor.gray, for:.normal )
            cell.acception.backgroundColor = UIColor.white
        }
        if (tmpCustomer.phone_number?.count)! > 0{
            cell.phoneNumber?.text = tmpCustomer.phone_number?[0]
        }else {
            cell.phoneNumber?.text = ""
        }
        
        return cell
    }
}
