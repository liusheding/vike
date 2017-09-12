//
//  CardManageController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class CardManageController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cardData = [Dictionary<String, Any>]()
    let cellId = "cardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // 创建右侧按钮
        let rightButton = UIBarButtonItem(title: "添加银行卡", style: .plain, target: self, action: #selector(clickAddCardBtn))
        self.navigationItem.setRightBarButton(rightButton, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func clickAddCardBtn(){
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "addcardID") as! AddCardController
        controller.isadd = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cardData = [Dictionary<String, Any>]()
        loading()
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["userId": APP_USER_ID, "pageSize":"1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_KB", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getcardData(jsondata)
                self.tableView.reloadData()
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    func getcardData(_ jsondata:JSON){
        for data in jsondata.array!{self.cardData.append(["bankname":data["bankName"].stringValue,"cardnumber":data["cardNumber"].stringValue,"id":data["id"].stringValue])
        }
    }

}

extension CardManageController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = self.cardData[indexPath.row]["bankname"] as? String
        cell.accessoryType = .disclosureIndicator
        let cardnum = self.cardData[indexPath.row]["cardnumber"] as? String
        let endindex = cardnum?.index((cardnum?.endIndex)!, offsetBy: -4)
        let endchar = cardnum?.substring(from: endindex!)
        
        cell.detailTextLabel?.text = "**** **** **** " + endchar!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "addcardID") as! AddCardController
        controller.isadd = false
        controller.cardid = self.cardData[indexPath.row]["id"] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // left slide
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "解除绑定") { action, index in
        let bankid = self.cardData[indexPath.row]["id"] as? String
        let body = ["ids":bankid]
        let request = NetworkUtils.postBackEnd("D_ME_KB", body: body , handler: {[weak self] (val ) in
            let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "解绑成功"
            self?.cardData.remove(at: indexPath.row)
            self?.tableView.reloadData()
            hub.hide(animated: true, afterDelay: 1)
        })
        request.response(completionHandler: {_ in
        })
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
}
