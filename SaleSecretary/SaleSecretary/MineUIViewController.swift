//
//  MineUIViewController.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MineUIViewController: UITableViewController {
    let labelCellId = "mineListID"
    let mineInfoID = "mineinfoID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MineViewCell.self), bundle: nil), forCellReuseIdentifier: labelCellId)
        self.tableView.register(UINib(nibName: String(describing: MineInfoCell.self), bundle: nil), forCellReuseIdentifier: mineInfoID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(130)
        }
        return CGFloat(50)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mineCells[section]?.count)!
    }
    
    private var mineCells = [
        0: [["label": "", "image": "", "id":""]],
        1: [["label": "短信", "image": "icon_w_dx", "id":"dx"]],
        2: [["label": "用户管理", "image": "icon_w_yhgl", "id":"yhgl"]],
        3: [["label": "钱包（点我试试）", "image": "icon_w_qb", "id":"qb"]],
        4: [["label": "短信发送统计（点我试试）", "image": "icon_w_dxtj", "id":"dxtj"]],
        5: [["label": "设置", "image": "icon_w_sz", "id":"sz"], ["label": "帮助", "image": "icon_w_bz", "id":"bz"]],
    ]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: mineInfoID, for: indexPath) as! MineInfoCell
            cell.name.text = "指尖小王"
            cell.phone.text = "12345678901"
            cell.job.text = "业务员"
            cell.invitecode.text = "12459"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        let secNum = indexPath.section
        let rowNo = indexPath.row
        let dict = self.mineCells[secNum]?[rowNo]
        let cell = tableView.dequeueReusableCell(withIdentifier: labelCellId, for: indexPath) as! MineViewCell
        cell.mineImage.image = UIImage(named: (dict!["image"]!))
        cell.mineName.text = dict!["label"]
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
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        if indexPath.section == 3{
            let walletVC = storyBoard.instantiateViewController(withIdentifier: "walletView")
            self.navigationController?.pushViewController(walletVC, animated: true)
        }else if indexPath.section == 4{
            let walletVC = storyBoard.instantiateViewController(withIdentifier: "BusinessRecord")
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
        
    }

}
