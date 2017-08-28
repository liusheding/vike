//
//  PayDetailController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/12.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class PayDetailController: UITableViewController {

    let cellId = "PayDetailID"
    let RecordData = [
        ["title":"充值短信50条", "time":"2017-07-24", "record":"50.00"],
        ["title":"充值短信100条", "time":"2017-07-23", "record":"95.00"],
        ["title":"充值短信200条", "time":"2017-07-22", "record":"188.00"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: PayDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PayDetailCell
        
        cell.title.text = self.RecordData[indexPath.row]["title"]
        cell.time.text = self.RecordData[indexPath.row]["time"]
        cell.money.text = self.RecordData[indexPath.row]["record"]
        cell.selectionStyle = .none
        return cell
    }
}
