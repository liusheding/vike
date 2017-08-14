//
//  UserManageViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class UserManageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellId = "userDetailID"
    let headIdentifier = "UMheadView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchBar.tintColor = APP_THEME_COLOR
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 构造数据 [ 0 : A , 1: B ] B:[ 0: a , 1: b ]
    lazy var contactsCells:[UserGroup] =  {
        var friendsModelArray = [UserGroup]()
        friendsModelArray = UserGroup.dictModel()
        return friendsModelArray
    }()
}

extension UserManageViewController: UITableViewDelegate, UITableViewDataSource, UMHeaderViewDelegate {
    
    func clickedGroupTitle(headerView: UserManageHeaderView){
        let section = NSIndexSet.init(index: headerView.tag) as IndexSet
        self.tableView.reloadSections(section, with: .automatic)
    }
    
    // 每次点击headerView时，改变group的isOpen参数，然后刷新tableview，显示或者隐藏好友信息
    func headerViewDidClickedNameView(headerView: UserManageHeaderView) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactsCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = self.contactsCells[section]
        if group.isOpen! {
            return (group.friends?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UserManageHeaderView.init(reuseIdentifier: headIdentifier)
        let group = self.contactsCells[section]
        
        headView.delegate = self as UMHeaderViewDelegate
        headView.tag = section
        headView.friendGroup = group
        return headView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let secNum = indexPath.section
        let group = self.contactsCells[secNum]
        let customer = group.friends?[indexPath.row] as? User
        
        cell.textLabel?.text = customer?.name
        cell.detailTextLabel?.text = customer?.phone
        cell.imageView?.image = UIImage(named: "pic_xkh")
        
//        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell.accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let callButton = UIButton(frame:CGRect(x: 18,y:15,width: 18,height: 18))
        callButton.setBackgroundImage(UIImage(named:"icon_bh"), for: .normal)
        callButton.addTarget(self, action: #selector(clickCallBtn), for: .touchUpInside)
        cell.accessoryView?.addSubview(callButton)
        return cell
    }
    
    func clickCallBtn(_ sender:UIButton){
        print("1111111111")
    }
    
}

extension UserManageViewController: UISearchBarDelegate {
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
