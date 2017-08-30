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
    var tableViewSel : Int = -1
    var contactDt : [Customer] = [] // phone contacts data
    var localDbContact : [Customers] = []
    var groupsInDb : [Group] = []
    var newCustomer : [Customer ] = []
    var alreadyAdded : [Customer] = []
    
    let contextDb  = CustomerDBOp.defaultInstance()
    
    var tableDelegate : ContactTableViewDelegate?
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
    
    // throw query in db
    func findNewCustomer(){
        print("++++++++++++++++\(Date.init())")
        for cd in self.contactDt {
            if !self.contextDb.queryByIdentifer(id: cd.id){
               self.newCustomer.append(cd)
            }else{
                self.alreadyAdded.append(cd)
            }
        }
        print("end --- ++++++++++++++++\(Date.init())")
        NSLog("new customer's page , find \(self.newCustomer.count) new person")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseGroupView(_ sender: UIButton!) {
        self.tableViewSel = sender.tag
        self.chooseAlertView.isHidden = false
        self.chooseAlertView.isUserInteractionEnabled = true
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
        NSLog(" log \(self.contactDt.count)")
        return contactDt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! PersonContactCell
        var tmpCustomer : Customer
        var flag = false
        if indexPath.row >= self.newCustomer.count {
            tmpCustomer = self.alreadyAdded[indexPath.row - newCustomer.count]
        }else {
            tmpCustomer = self.newCustomer[indexPath.row]
            flag = true
        }
        let userName = tmpCustomer.name
        var cString : String = ""
        if !(userName?.isEmpty)! {
            let index = userName?.index( (userName?.startIndex)! , offsetBy: 1)
            cString = (userName?.substring(to: index! ))!
        }
        
        cell.picName.setTitle( cString , for: .normal )
        cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
        cell.name.text = userName
        if flag {
            cell.acception.setTitle( "添加" , for: .normal )
            cell.acception.setTitle("已添加", for: .disabled)
            cell.acception.setTitleColor(UIColor.white , for: .normal )
            cell.acception.setTitleColor(UIColor.gray , for: .disabled )
            cell.acception.backgroundColor = ContactCommon.THEME_COLOR
            cell.acception.addTarget( self , action: #selector(self.chooseGroupView(_:)) , for: UIControlEvents.touchDown)
        }else {
            cell.selectionStyle = .none
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
    
    func  changeButtonStatus() {
        let cell = self.tableView.cellForRow(at: [0,self.tableViewSel]) as! PersonContactCell
        cell.acception.isEnabled = false
        cell.acception.backgroundColor = UIColor.white
        
    }
}
