//
//  UserManageViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserManageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellId = "userDetailID"
    let headIdentifier = "UMheadView"
    lazy var contactsCells = [UserGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchBar.tintColor = APP_THEME_COLOR
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(clickAddBtn))
        
        self.tableView.register(UINib(nibName: String(describing: UserDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loading()
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["khjlTjm": AppUser.currentUser?.referralCode as Any, "pageSize": "1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_YHGL", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                // 构造数据
                self.contactsCells =  {
                    var friendsModelArray = [UserGroup]()
                    friendsModelArray = UserGroup.dictModel(jsondata: jsondata)
                    return friendsModelArray
                }()
                
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
                self.tableView.reloadData()
            })
        }
    }
    
    func clickAddBtn(){
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let walletVC = storyBoard.instantiateViewController(withIdentifier: "addUserID")
        self.navigationController?.pushViewController(walletVC, animated: true)
    }
    
}

extension UserManageViewController: UITableViewDelegate, UITableViewDataSource, UMHeaderViewDelegate {
    
    func clickedGroupTitle(headerView: UserManageHeaderView){
//        let section = NSIndexSet.init(index: headerView.tag) as IndexSet
//        self.tableView.reloadSections(section, with: .automatic)
        self.tableView.reloadData()
    }
    
    // 每次点击headerView时，改变group的isOpen参数，然后刷新tableview，显示或者隐藏好友信息
    func headerViewDidClickedNameView(headerView: UserManageHeaderView) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserDetailCell
        let secNum = indexPath.section
        let group = self.contactsCells[secNum]
        let customer = group.friends?[indexPath.row] as? User
        
        let userName = customer?.name
        var cString : String = ""
        if !(userName?.isEmpty)! {
            let index = userName?.index( (userName?.startIndex)! , offsetBy: 1)
            cString = (userName?.substring(to: index! ))!
        }
        
        cell.name?.text = userName
        cell.phone?.text = customer?.phone
        
        if customer?.status == "1"{ //锁定
            cell.name.textColor = UIColor.red
            cell.phone.textColor = UIColor.red
        }else{
            cell.name.textColor = UIColor.black
            cell.phone.textColor = UIColor.lightGray
        }

        
        cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
        cell.picName.setTitle(cString , for: .normal )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let group = self.contactsCells[indexPath.section]
        let customer = group.friends?[indexPath.row] as? User
        let phone = customer?.phone
        if phone! == ""{
            return
        }
        let urlString = "tel://\(phone!)"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in})
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // left slide
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let group = self.contactsCells[indexPath.section]
        let customer = group.friends?[indexPath.row] as? User
        var title = ""
        var status = ""
        var tips = ""
        if customer?.status == "1"{ //锁定
            title = "解冻账号"
            status = "0"
            tips = "解冻成功"
        }else{
            title = "冻结账号"
            status = "1"
            tips = "冻结成功"
        }
        
        let freeze = UITableViewRowAction(style: .normal, title: title) { action, index in
            let body = ["busi_scene":"USER_LOCK", "id":customer?.userid, "status":status]
            let request = NetworkUtils.postBackEnd("U_USER", body: body , handler: {[weak self] (val ) in
                let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
                hub.mode = MBProgressHUDMode.text
                hub.label.text = tips
                customer?.status = status
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                hub.hide(animated: true, afterDelay: 1)
            })
            request.response(completionHandler: {_ in
            })
            
        }
        freeze.backgroundColor = UIColor.red
        
        return [freeze]
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
