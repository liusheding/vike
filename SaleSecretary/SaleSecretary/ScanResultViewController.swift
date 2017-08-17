//
//  ScanResultViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ScanResultViewController: UIViewController, ScanORCResultDelegate {
    
    var words:[String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cid = "ScanResultCellId"
    
    fileprivate let labels = ["姓名", "称谓", "电话", "公司", "邮件" ,"地点"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "ScanResultCell", bundle: nil), forCellReuseIdentifier: cid)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44.0
        tableView.sectionHeaderHeight = 10.0
        tableView.delegate = self
        tableView.dataSource = self
        // self.view.addSubview(tableView)
    }
    
    func processReuslt(result: [String]) -> Customer? {
        return nil
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        
    }
}


extension ScanResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cid) as! ScanResultCell
        let row = indexPath.row
        cell.label.text = labels[row]
        return cell
    }
}
