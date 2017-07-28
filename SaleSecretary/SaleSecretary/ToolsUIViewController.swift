//
//  ToolsUIViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ToolsUIViewController : UITableViewController {
    
    
    
    let cellId = "toolsListID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: ToolCellView.self), bundle: nil), forCellReuseIdentifier: cellId)
        // self.tableView.register(MessageListCell.self, forCellReuseIdentifier: "MessageListID")
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.toolCells[section]?.count)!
    }
    
    
    
    private var toolCells = [
        0: [["label": "短信计划", "image": "icon_gj_dxjh", "id":"dxjg"]],
        1: [["label": "名片扫描", "image": "icon_gj_mpsm", "id":"mpsm"], ["label": "二维码名片", "image": "icon_gj_ewmmp", "id":"ewmmp"]],
        2: [["label": "查找企业", "image": "icon_gj_czqy", "id":"czqy"]]
    ]
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secNum = indexPath.section
        // _ = curIdx(sec: secNum)
        let rowNo = indexPath.row
        let dict = self.toolCells[secNum]?[rowNo]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ToolCellView
        // cell.setValue(value: dict?["id"], forKey: "id")
        // 
        // cell.setValue(dict?["id"], forKey: "id")
        cell.toolImage.image = UIImage(named: (dict!["image"]!))
        cell.toolLabel.text = dict!["label"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 20
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = self.tableView.cellForRow(at: indexPath)
        print("\(String(describing: selectedRow))")
        // print(selectedRow?.value(forKey: "id"))
        self.navigationController?.pushViewController(SMSUIViewController(), animated: false)
    
    }
    
    private func curIdx(sec: Int) -> Int {
        if sec == 0 {
            return 0
        }
        let len = self.toolCells.count
        var cur : Int = 0
        for i in 0 ... (len - 1) {
            cur += toolCells[i]!.count
        }
        return cur
    }
    
    
}
