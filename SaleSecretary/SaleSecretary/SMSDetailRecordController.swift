//
//  SMSDetailRecordController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/12.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class SMSDetailRecordController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let contextDb  = CustomerDBOp.defaultInstance()
    var smsid:String?
    var menu: JSDropDownMenu!
    var selStatesIndex:Int = 0
    
    let cellId = "stateCell"
    let menuTitles = ["全部"]
    
    let states = ["全部", "提交中", "发送成功", "发送失败", "未知状态"]
    let statesdic = ["0":"提交中", "1":"发送成功", "2":"发送失败", "3":"未知状态"]
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.states]
        }()
    
    var RecordData = [Dictionary<String, Any>]()
    var DataCache = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menu = JSDropDownMenu(origin: CGPoint(x: 0, y: 58), andHeight: 45)
        
        menu.indicatorColor = UIColor(colorLiteralRed: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1)
        menu.separatorColor = UIColor(colorLiteralRed: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1)
        menu.textColor = UIColor(colorLiteralRed: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1)
        menu.dataSource = self as JSDropDownMenuDataSource
        menu.delegate = self as JSDropDownMenuDelegate
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(menu)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.register(UINib(nibName: String(describing: SmsStateCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        loading()
        
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["dxqfPId":self.smsid, "pageSize":"10000"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_DXQFMX", body: body) {
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
        for data in jsondata.array!{
            let phone = data["cellphoneNumber"].stringValue
            let result = self.contextDb.queryByIdentifer(id: phone)
            var names = [String]()
            for r in result{
                names.append(r.user_name!)
            }
            if names.count != 0{
                for name in names{
                    RecordData.append(["name":name,"phone":phone, "status":data["status"].stringValue])
                }
            }else{
                RecordData.append(["name":"","phone":phone, "status":data["status"].stringValue])
            }
            
        }
        RecordData.sort { (s1, s2) -> Bool in
            s1["name"] as! String > s2["name"] as! String
        }
        DataCache = RecordData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SMSDetailRecordController: JSDropDownMenuDataSource, JSDropDownMenuDelegate {
    
    func numberOfColumns(in menu: JSDropDownMenu!) -> Int {
        return self.menus.count
    }
    
    func menu(_ menu: JSDropDownMenu!, numberOfRowsInColumn column: Int, leftOrRight: Int, leftRow: Int) -> Int {
        return self.menus[column].count
    }
    
    func menu(_ menu: JSDropDownMenu!, titleForRowAt indexPath: JSIndexPath!) -> String! {
        let col = indexPath.column
        let row = indexPath.row
        switch col {
        case 0:
            let ms = self.menus[col] as! [String]
            return ms[row]
        default:
            return ""
        }
    }
    
    func menu(_ menu: JSDropDownMenu!, titleForColumn column: Int) -> String! {
        return self.menuTitles[column]
    }
    
    func widthRatio(ofLeftColumn column: Int) -> CGFloat {
        return 1
    }
    
    func haveRightTableView(inColumn column: Int) -> Bool {
        return false
    }
    
    func currentLeftSelectedRow(_ column: Int) -> Int {
        return self.selStatesIndex
    }
    
    func displayByCollectionView(inColumn column: Int) -> Bool {
        return false
    }
    
    func refreshTable(_ indexPath:JSIndexPath){
        let statusdic = [1:"0", 2:"1", 3:"2", 4:"3"]
        if indexPath.row == 0{
            RecordData = DataCache
            self.tableView.reloadData()
        }else{
            RecordData = [Dictionary<String, Any>]()
            for data in DataCache{
                if data["status"] as? String == statusdic[indexPath.row]{
                    RecordData.append(data)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func menu(_ menu: JSDropDownMenu!, didSelectRowAt indexPath: JSIndexPath!) {
        self.selStatesIndex = indexPath.row
        refreshTable(indexPath)
    }
}


extension SMSDetailRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RecordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! SmsStateCell
        let userName = self.RecordData[indexPath.row]["name"] as? String
        var cString : String = ""
        if !((userName?.isEmpty)!) {
            let index = userName?.index((userName?.startIndex)!, offsetBy: 1)
            cString = (userName?.substring(to: index!))!
        }
        
        cell.name.text = userName
        let phone = self.RecordData[indexPath.row]["phone"] as? String
        cell.phone.text = phone?.replacingOccurrences(of: " ", with: "")
        let state = self.RecordData[indexPath.row]["status"] as? String
        cell.state.text = self.statesdic[state!]
        cell.picName.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count ]
        cell.picName.setTitle(cString , for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
}

