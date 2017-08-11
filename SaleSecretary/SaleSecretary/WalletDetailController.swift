//
//  WalletDetailController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class WalletDetailController: UITableViewController {
    let cellId = "WalletDetailID"
    let RecordData = [
                ["title":"充值短信", "time":"2017-07-24", "record":"-20"],
                ["title":"提成收益", "time":"2017-07-23", "record":"+10"],
                ["title":"充值短信", "time":"2017-07-22", "record":"-200"],
                ["title":"提成收益", "time":"2017-07-21", "record":"+100"]
                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: WalletDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RecordData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletDetailCell
        
        cell.title.text = self.RecordData[indexPath.row]["title"]
        cell.time.text = self.RecordData[indexPath.row]["time"]
        cell.money.text = self.RecordData[indexPath.row]["record"]
        let str = cell.money.text
        let index = str?.index((str?.startIndex)!, offsetBy: 1)
        let prefix = str?.substring(to: index!)
        if prefix == "+"{
            cell.money.textColor = APP_THEME_COLOR
        }else{
            cell.money.textColor = UIColor.black
        }
        
        return cell
    }

}
