//
//  ChooseCardController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class ChooseCardController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var rootView:TakeoutMoneyViewController!
    var cardData = [Dictionary<String, Any>]()
    let cellId = "cardCell"
    var emptyView: EmptyContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cardData = [Dictionary<String, Any>]()
        loading()
    }
    
    func loading(){
        emptyView?.dismiss()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["userId": APP_USER_ID, "pageSize":"1000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_KB", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getcardData(jsondata)
                if self.cardData.count == 0{
                    let frame = self.tableView.frame
                    self.emptyView = EmptyContentView.init(frame: frame)
                    self.emptyView?.textLabel.frame = CGRect(x: frame.origin.x + 20, y: frame.origin.y + 80, width: frame.width - 40, height:  40)
                    self.emptyView?.textLabel.text = "您还没有添加任何银行卡哦～"
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
    
    func getcardData(_ jsondata:JSON){
        for data in jsondata.array!{self.cardData.append(["bankname":data["bankName"].stringValue,"cardnumber":data["cardNumber"].stringValue,"id":data["id"].stringValue])
        }
    }

}

extension ChooseCardController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = self.cardData[indexPath.row]["bankname"] as? String
        
        let cardnum = self.cardData[indexPath.row]["cardnumber"] as? String
        var endchar = cardnum
        if (cardnum?.characters.count)! > 4{
            let endindex = cardnum?.index((cardnum?.endIndex)!, offsetBy: -4)
            endchar = cardnum?.substring(from: endindex!)
        }
        cell.detailTextLabel?.text = "**** **** **** " + endchar!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rootcell = rootView.tableView.cellForRow(at: [0,0])
        let bankname = self.cardData[indexPath.row]["bankname"] as? String
        let cardnum = self.cardData[indexPath.row]["cardnumber"] as? String
        var endchar = cardnum
        if (cardnum?.characters.count)! > 4{
            let endindex = cardnum?.index((cardnum?.endIndex)!, offsetBy: -4)
            endchar = cardnum?.substring(from: endindex!)
        }
        rootcell?.textLabel?.text = bankname! + "(**** \(endchar!))"
        rootView.cardid = self.cardData[indexPath.row]["id"] as? String
        self.navigationController?.popViewController(animated: true)
    }
}
