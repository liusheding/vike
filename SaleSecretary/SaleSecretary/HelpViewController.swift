//
//  HelpViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let titles = ["产品动态", "欢迎页", "新手指南", "问题反馈", "服务热线"]
    let identifiers = ["newsID", "welcomeID", "guideID", "problemID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
//        tableView.separatorColor = UIColor.groupTableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        version.text = "销小秘 V1.0.0"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HelpViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "helpCell")
        cell.textLabel?.text = self.titles[indexPath.row]
        if indexPath.row == self.titles.count - 1{
            cell.detailTextLabel?.text = "400-400-400"
            cell.selectionStyle = .none
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        if indexPath.row < self.identifiers.count{
            let identifier = self.identifiers[indexPath.row]
            let walletVC = storyBoard.instantiateViewController(withIdentifier: identifier)
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
    }

}
