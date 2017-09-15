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
    var emptyView: EmptyContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: PayDetailCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        loading()
    }
    
    func loading(){
        emptyView?.dismiss()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["userId":APP_USER_ID, "pageSize":"1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_DXCZ", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getRecordData(jsondata: jsondata)
                
                if self.RecordData.count == 0{
                    self.emptyView = EmptyContentView.init(frame: self.tableView.frame)
                    self.emptyView?.textLabel.text = "您还没有短信充值记录哦～"
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
        for data in jsondata.array!{self.RecordData.append(["title":data["dxts"].stringValue,"time":data["orderDate"].stringValue,"record":data["paymentAmount"].stringValue,"state":data["status"].stringValue, "paystate":data["payStatus"].stringValue])
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
        let money = self.RecordData[indexPath.row]["record"] as? String
        cell.title.text = "\(title!)条/\(money!)元"
        
        cell.time.text = self.RecordData[indexPath.row]["time"] as? String
        
        let state = self.RecordData[indexPath.row]["state"] as? String
        let states = ["0":"短信未到账", "1":"短信已到账", "2":"待处理"]
        let paystate = self.RecordData[indexPath.row]["paystate"] as? String
        let paystates = ["1":"未支付", "2":"支付成功", "3":"支付失败"]
        cell.state.text = paystates[paystate!]! + "/" + states[state!]!
        cell.selectionStyle = .none
        return cell
    }
}
