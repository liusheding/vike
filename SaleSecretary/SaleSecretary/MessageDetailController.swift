//
//  MessageDetailController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/7/27.
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: MessageDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        
        //滑倒最底部
        DispatchQueue.main.async(execute: {
            let offset = CGPoint(x:0, y:self.tableView.contentSize.height
            - self.tableView.frame.size.height)
            self.tableView.setContentOffset(offset, animated: false)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.DataSource.message.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageDetailCell
        
        let message = self.DataSource.message as! [MessageDetail]
        let msg = message[indexPath.section] as! MessageDetail
        cell.celltime.text = msg.msgtime
        cell.cellcontent.text = msg.msgcontent
        cell.celltitle.text = self.DataSource.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

}
