//
//  CTChooseGroupController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTChooseGroupController: UITableViewController {

    let cellId = "reuseIdentifier"
    var selectedCustomer : [Customer] = []
    
    let contextDb : CustomerDBOp = CustomerDBOp.defaultInstance()
    
    var selectedGroup : Int = -1
    var reloadViewDelegate : ContactTableViewDelegate?
    var group : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.group = self.contextDb.getGroupInDb(userId: APP_USER_ID!)
        self.navigationSetting()
        self.tableSetting()
        reloadViewDelegate = ContactTableViewController.instance
    }
    
    func tableSetting()  {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register( UITableViewCell.self , forCellReuseIdentifier: self.cellId)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func navigationSetting()  {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(confirm))
    }

    func confirm() {
        
        if self.selectedGroup < 0 {
            let uc = UIAlertController(title: "警告", message: "请选择分组！", preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            self.present(uc, animated: true, completion: nil)
            return
        }
        
        var phoneArr : [String] = []
        for  sc in self.selectedCustomer {
            phoneArr.append( (sc.phone_number?.count)! > 0 ? (sc.phone_number?[0])! : "" )
        }
        
        let request = NetworkUtils.postBackEnd("U_TXL_CUS_GROUP", body: ["id" : self.group[self.selectedGroup].id ?? "" , "xzkh": phoneArr.joined(separator: ContactCommon.separatorDefault) ]) { (json) in
            self.contextDb.batchChangeCustomerGroup(cust: self.selectedCustomer , group: self.group[self.selectedGroup ] )
        }
        request.response { (_) in
            if self.reloadViewDelegate != nil{
                self.reloadViewDelegate?.reloadTableViewData()
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.group.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath)
        cell.textLabel?.text = self.group[indexPath.row].group_name
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedGroup == indexPath.row {
            return
        }else {
            self.selectedGroup = indexPath.row
            self.changeImg( id: indexPath.row )
        }
    }
    
    func changeImg(id : Int) {
        for d in 0...self.group.count {
            let cell = self.tableView.cellForRow(at: [0 , d])
            if d == id {
                cell?.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
            }else {
                cell?.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
            }
        }
    }
}
