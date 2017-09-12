//
//  PayDetailController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/12.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class PayDetailController: UITableViewController {
    let cellId = "PayDetailID"
    var RecordData = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: PayDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        loading()
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["userId":APP_USER_ID, "pageSize":"1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_DXCZ", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getRecordData(jsondata: jsondata)
                self.tableView.reloadData()
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    func getRecordData(jsondata:JSON){
        RecordData = [Dictionary<String, Any>]()
        for data in jsondata.array!{self.RecordData.append(["title":data["dxts"].stringValue,"time":data["orderDate"].stringValue,"record":data["paymentAmount"].stringValue])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PayDetailCell
        
        let title = self.RecordData[indexPath.row]["title"] as? String
        cell.title.text = "充值短信\(title!)条"
        
        cell.time.text = self.RecordData[indexPath.row]["time"] as? String
        let money = self.RecordData[indexPath.row]["record"] as? String
        cell.money.text = money
        cell.selectionStyle = .none
        return cell
    }
}
