//
//  CTManagerGroupController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/23.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ContactTableViewDelegate {
    func reloadTableViewData( )
}

class CTManagerGroupController: UIViewController  {

    let managerGroup = "managerGroupCell"
    let contactDb : CustomerDBOp = CustomerDBOp.defaultInstance()
    
    var group : [MemGroup] = []
    
    var contactsTableviewDelegate : ContactTableViewDelegate?
    
    var groupDelegate : GroupDataDelegate?
    
    @IBOutlet weak var localTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "分组管理"
        
        self.localTableView.dataSource = self
        self.localTableView.delegate = self
        self.localTableView.setEditing(true , animated: true)
        // init data
        self.group = MemGroup.toMemGroup(dbGroup: self.contactDb.getGroupInDb(userId: APP_USER_ID!, true))
        self.localTableView.register( UITableViewCell.self, forCellReuseIdentifier: self.managerGroup )
        self.localTableView.tableFooterView = UIView()
        self.groupDelegate = CTChangeGroupViewController.instance
    }
    
}

extension CTManagerGroupController : UITableViewDelegate , UITableViewDataSource{
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.group.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: managerGroup , for: indexPath)
        
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "icon_tj")
            cell.textLabel?.text = "添加分组"
            cell.imageView?.isUserInteractionEnabled = true
            let imgClick = UITapGestureRecognizer(target: self, action: #selector(addGroup))
            cell.imageView?.addGestureRecognizer(imgClick)
            let btn = UIButton.init(frame: CGRect(x: 0 , y: 0  , width: SCREEN_WIDTH , height: 44 ))
            btn.backgroundColor = UIColor.clear
            btn.addTarget(self, action: #selector(self.addGroup), for: .touchUpInside)
            cell.addSubview(btn)
        }else {
            cell.textLabel?.text = self.group[indexPath.row-1].group_name
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func addGroup()  {
        let alertController = UIAlertController(title: "添加分组", message: "请输入分组名（长度限制10个字）！",preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "添加", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let groupName = alertController.textFields!.first!
            
            let msg = ContactCommon.validateGroupName(newName: groupName.text!, group: self.group)
            if msg.characters.count > 0 {
                let uc = UIAlertController(title: "警告", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
                self.present( uc , animated: true, completion: nil)
                return
            }
            
            let request = NetworkUtils.postBackEnd("C_TXL_CUS_GROUP", body: ["name": groupName.text! , "userId": APP_USER_ID! ], handler: { (json) in
                let id = json["body"]["id"].stringValue
                self.contactDb.storeGroup(id: id , group_name: groupName.text! , userId: APP_USER_ID!)
                self.group = MemGroup.toMemGroup(dbGroup: self.contactDb.getGroup(userId: APP_USER_ID!))
                })
            request.response(completionHandler: {_ in
                self.localTableView.reloadData()
                if self.contactsTableviewDelegate != nil {
                    self.contactsTableviewDelegate?.reloadTableViewData()
                }
                if self.groupDelegate != nil {
                    self.groupDelegate?.reloadGroupData()
                }
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 1 {
            return true
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.addGroup()
        }
    }
    
    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
        
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
        
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let cell = self.group[indexPath.row - 1 ]
            
            let request = NetworkUtils.postBackEnd("D_TXL_CUS_GROUP", body: ["ids": cell.id , "userId" : APP_USER_ID! ], handler: { (json) in
                self.group.remove(at: indexPath.row - 1)
                self.localTableView.deleteRows(at: [indexPath], with: .fade)
                self.contactDb.deleteGroup(g: cell)
                self.contactDb.changeCustomerGroup(group: [cell], defaultGroup: self.group)
            })
            request.response(completionHandler: { _ in
                if self.contactsTableviewDelegate != nil {
                    self.contactsTableviewDelegate?.reloadTableViewData()
                }
                if self.groupDelegate != nil {
                    self.groupDelegate?.reloadGroupData()
                }
            })
        }
    }
    
}
