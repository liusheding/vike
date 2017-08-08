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
    var DataSource:MessageData!
    var chattitle:String!
    
    override func viewDidLoad() {
        self.navigationItem.title = chattitle
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        return self.DataSource.message.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageDetailCell
        
        let message = self.DataSource.message as NSMutableArray
        let msg = message[indexPath.row] as! MessageDetail
        cell.celltime.text = msg.msgtime
        cell.cellcontent.text = msg.msgcontent
        cell.celltitle.text = self.DataSource.name
        return cell
    }

}
