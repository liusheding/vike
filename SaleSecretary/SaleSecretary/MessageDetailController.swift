//
//  MessageDetailController.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/7/27.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageDetailController: UITableViewController {
    
    let cellId = "MessageDetailID"
    var aa = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(aa)")
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MessageDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageDetailCell
        
        cell.celltime.text = "2017-7-24 12:45"
        cell.celltitle.text = "系统上线通知"
        cell.cellcontent.text = "指尖科技指尖科技指尖科技指尖科技指尖科技指尖科技指尖科技指尖科技指尖科技指尖科技"
        return cell
    }

}
