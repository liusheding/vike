//
//  WalletDetailController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class WalletDetailController: UITableViewController {
    let cellId = "WalletDetailID"
    var RecordData = [Dictionary<String, Any>]()
    var emptyView: EmptyContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: WalletDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        loading()
    }
    
    func loading(){
        emptyView?.dismiss()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["userId":APP_USER_ID, "pageSize": "1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_BONUS_DETAIL", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getRecordData(jsondata: jsondata)
                
                if self.RecordData.count == 0{
                    self.emptyView = EmptyContentView.init(frame: self.tableView.frame)
                    self.emptyView?.textLabel.text = "您还没有收支记录哦～"
                    self.emptyView?.textLabel.numberOfLines = 2
                    self.emptyView?.showInView(self.view)
                }else{
                    self.tableView.reloadData()
                }
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    func getRecordData(jsondata:JSON){
        RecordData = [Dictionary<String, Any>]()
        for data in jsondata.array!{RecordData.append(["title":data["bonusGs"].stringValue,"time":data["dateLastUpdate"].stringValue,"record":data["bonus"].stringValue, "cztype":data["czType"].stringValue])
        }
        RecordData.sort { (s1, s2) -> Bool in
            s1["time"] as! String > s2["time"] as! String
        }
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
        
        cell.title.text = self.RecordData[indexPath.row]["title"] as? String
        cell.time.text = self.RecordData[indexPath.row]["time"] as? String
        let record = self.RecordData[indexPath.row]["record"] as? String
        let cztype = self.RecordData[indexPath.row]["cztype"] as? String
        cell.money.text = record!
        cell.money.textColor = UIColor.black
        if cztype == "TX"{
            cell.money.text = "-" + record!
            cell.money.textColor = UIColor.black
        }else if cztype == "TXSHSBTK"{
            cell.money.text = "+" + record!
            cell.money.textColor = APP_THEME_COLOR
        }
        cell.selectionStyle = .none
        return cell
    }

}
