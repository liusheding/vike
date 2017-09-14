//
//  BusinessRecordController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class BusinessRecordController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "smshistoryCell"
    
    var menu: JSDropDownMenu!
    var selTimesIndex:Int = 0
    
    let menuTitles = ["今天"]
    
    let times = ["今天", "最近一周", "最近一月", "最近两月", "最近三月"]
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.times]
        }()
    
    var RecordData = [Dictionary<String, Any>]()
    let daySeconds = Int(60*60*24)
    
    var emptyView: EmptyContentView?
    
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
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(menu)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.register(UINib(nibName: String(describing: SmsHistoryCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
        let dateEnd = dataFormat(Date(timeIntervalSinceNow:0))
        let dateStart = dataFormat(Date(timeIntervalSinceNow:0))
        loading(dateStart, dateEnd)
    }
    
    
    
    func loading(_ dateStart:String, _ dateEnd:String){
        emptyView?.dismiss()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            var body = ["userId":APP_USER_ID, "pageSize": "1000"]
            if dateStart != ""{
                body["dateStart"] = dateStart
            }
            if dateEnd != ""{
                body["dateEnd"] = dateEnd
            }
            
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_DXQF", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.getRecordData(jsondata: jsondata)
                if self.RecordData.count == 0{
                    let frame = self.tableView.frame
                    self.emptyView = EmptyContentView.init(frame: frame)
                    self.emptyView?.textLabel.frame = CGRect(x: frame.origin.x + 20, y: frame.origin.y - 80, width: frame.width - 40, height:  40)
                    self.emptyView?.textLabel.text = "您\(self.times[self.selTimesIndex])还没有发送过短信哦～"
                    self.emptyView?.textLabel.numberOfLines = 2
                    self.emptyView?.showInView(self.view)
                }
                self.tableView.reloadData()
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    func getRecordData(jsondata:JSON){
        RecordData = [Dictionary<String, Any>]()
        for data in jsondata.array!{RecordData.append(["qfts":data["qfts"].stringValue,"time":data["dateLastUpdate"].stringValue, "content":data["tempContent"].stringValue,"id":data["id"].stringValue])
        }
        RecordData.sort { (s1, s2) -> Bool in
            s1["time"] as! String > s2["time"] as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BusinessRecordController: JSDropDownMenuDataSource, JSDropDownMenuDelegate {
    
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
        return self.selTimesIndex
    }
    
    func displayByCollectionView(inColumn column: Int) -> Bool {
        return false
    }
    
    func dataFormat(_ time:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: time)
    }
    
    func menu(_ menu: JSDropDownMenu!, didSelectRowAt indexPath: JSIndexPath!) {
        self.selTimesIndex = indexPath.row
        let dateEnd = dataFormat(Date(timeIntervalSinceNow:0))
        let timesdic = [0:0, 1:7, 2:30, 3:60, 4:90]
        let dateStart = dataFormat(Date(timeIntervalSinceNow:TimeInterval(-daySeconds*timesdic[indexPath.row]!)))
        loading(dateStart, dateEnd)
    }
}


extension BusinessRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RecordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SmsHistoryCell
        let qfts = self.RecordData[indexPath.row]["qfts"] as? String
        let time = self.RecordData[indexPath.row]["time"] as? String
        cell.title.text = time! + " 群发短信\(qfts!)条"
        cell.content.text = self.RecordData[indexPath.row]["content"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "smsdetailID") as! SMSDetailRecordController
        controller.smsid = self.RecordData[indexPath.row]["id"] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}
