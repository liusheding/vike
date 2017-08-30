//
//  CTManagerGroupController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/23.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

protocol ContactTableViewDelegate {
    func reloadTableViewData( )
}

class CTManagerGroupController: UIViewController {

    let managerGroup = "managerGroupCell"
    let contactDb : CustomerDBOp = CustomerDBOp.defaultInstance()
    var group : [MemGroup] = []
    
    var deleteGroup : [MemGroup] = []
    var addedGroup : [MemGroup]  = []
    
    var contactsTableviewDelegate : ContactTableViewDelegate?
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    @IBOutlet weak var localTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.localTableView.dataSource = self
        self.localTableView.delegate = self
        self.localTableView.setEditing(true , animated: true)
        // init data
        self.group = MemGroup.toMemGroup(dbGroup: self.contactDb.getGroupInDb(true))
        
        self.localTableView.register( UITableViewCell.self, forCellReuseIdentifier: self.managerGroup )
        self.localTableView.tableFooterView = UIView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelAction(_ sender: Any) {

        if self.addedGroup.count == 0 && self.deleteGroup.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }else {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "温馨提示：是否放弃修改？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "是的", style: .default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        
        if self.addedGroup.count > 0 {
            self.contactDb.storeGroupArray(gArray: self.addedGroup)
        }
        if self.deleteGroup.count > 0 {
            self.contactDb.deleteGroupArray(gArray: self.deleteGroup)
            self.contactDb.changeCustomerGroup(group: self.deleteGroup)
        }
        if self.contactsTableviewDelegate != nil {
           self.contactsTableviewDelegate?.reloadTableViewData()
        }
        
        self.dismiss(animated: true, completion: nil)
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
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "icon_tj")
            cell.textLabel?.text = "添加分组"
            cell.imageView?.isUserInteractionEnabled = true
            let imgClick = UITapGestureRecognizer(target: self, action: #selector(addGroup(_:)))
            cell.imageView?.addGestureRecognizer(imgClick)
        }else {
            cell.textLabel?.text = self.group[indexPath.row-1].group_name
        }
        
        return cell
    }
    
    func addGroup(_ sender : UIButton!)  {
        let alertController = UIAlertController(title: "添加分组", message: "请输入分组名（长度限制10个字）！",preferredStyle: .alert)
        
        
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            //            textField.placeholder = "用户名"
            //            textField.
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "添加", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let groupName = alertController.textFields!.first!
            var maxId : Int = 0
            for ga in self.group {
                if Int(ga.id) > maxId {
                    maxId = Int(ga.id)
                }
            }
            let tmpGp = MemGroup( id: maxId + 1 , gn: groupName.text!)
            self.addedGroup.append(tmpGp)
            self.group.append(tmpGp)
            self.localTableView.reloadData()
            
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
            self.deleteGroup.append(cell)
            self.group.remove(at: indexPath.row - 1)
            self.localTableView.deleteRows(at: [indexPath], with: .fade)
            var needRemove : Int = -1
            if self.addedGroup.count > 0 {
                for i in 0...self.addedGroup.count {
                    if self.addedGroup[i].group_name == self.group[indexPath.row - 1].group_name {
                        needRemove = i
                    }
                }
                if needRemove > 0 {
                    self.addedGroup.remove(at: needRemove)
                }
            }
        }
        
    }
    
}
