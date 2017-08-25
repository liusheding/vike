//
//  SetViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let titles = ["个人资料", "修改密码", "退出登录"]
    let identifiers = ["mineInfoID", "changePwdID"]
    let cellId = "exitViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.groupTableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: ExitViewCell.self), bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SetViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.titles.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExitViewCell
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "payCell")
        cell.textLabel?.text = self.titles[indexPath.section]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == self.titles.count - 1{
            logout()
        }else{
            let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
            let identifier = self.identifiers[indexPath.section]
            let walletVC = storyBoard.instantiateViewController(withIdentifier: identifier)
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
    }
    
    func logout() {
        
        let alertController = UIAlertController(title: "退出", message: "确定要退出吗？",
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "退出登录", style: .destructive, handler: {_ in AppUser.logout()})
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
