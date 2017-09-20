//
//  SMSUIViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/28.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Foundation
import DropDown
import MBProgressHUD
import SwiftyJSON

class SMSUIViewController : UITableViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    fileprivate var cellId = "SMSListCell"
    
    @IBOutlet weak var moreBarItem: UIBarButtonItem!
    
    var moreDrop: CustomerPopUpView!
    
    var emptyView: EmptyContentView?
    
    @IBAction func moreActions(_ sender: UIBarButtonItem) {
        print("tapped")
        self.moreDrop.hide(!self.moreDrop.isHidden)
    }
    
    
    override func viewDidLoad() {
        print("invoke SMSUIViewController.viewDidLoad()")
        super.viewDidLoad()
        self.setUp()
        // self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.moreDrop.hide(true)
    }
    
    var schedules: [MessageSchedule] = []
    
    var images: [String:String] = ["0":"pic_qf", "1": "pic_zdy", "2": "pic_jjr"]
    
    open var formatter : DateFormatter = DateFormatter()
    
    lazy var times : [String] = {
        var date = Date()
        var df = DateFormatter()
        df.dateFormat = "yyy-MM-dd HH:mm:ss"
        var str = df.string(from: date)
       return [str, str, str]
    }()
    
    func loadData() {
        emptyView?.dismiss()
        Utils.showLoadingHUB(view: self.view, completion: { hub in
            let request = MessageSchedule.loadMySchedules({
                msgs in
                self.schedules = msgs
                self.tableView.reloadData()
                if self.schedules.count == 0 {
                    self.emptyView = EmptyContentView.init(frame: self.tableView.frame)
                    self.emptyView?.textLabel.text = "您还没有执行计划，点击右上角去新建一个吧～"
                    self.emptyView?.textLabel.numberOfLines = 2
                    self.emptyView?.showInView(self.view)
                }
            })
            request?.response(completionHandler: {
                _ in
                hub.hide(animated: true, afterDelay: 0.3)
            })
        })
    }
    
}

extension SMSUIViewController  {
    
    
    static func visibleWindow() -> UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        
        if currentWindow == nil {
            let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
            
            for window in frontToBackWindows {
                if window.windowLevel == UIWindowLevelNormal {
                    currentWindow = window
                    break
                }
            }
        }
        
        return currentWindow
    }
    
    fileprivate func setUp() {
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = APP_BACKGROUND_COLOR
        self.view.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "SMSListViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.register(UINib(nibName: "SMSStatusCell", bundle: nil), forCellReuseIdentifier: "statusCell")
        // moreDrop.anchorView = self.moreBarItem
        let appearance = DropDown.appearance()
        self.moreDrop =  CustomerPopUpView(titles: ["新的执行计划", "短信模板", "我的模板"], images: ["icon_xjzxjh", "icon_mlmb", "icon_mlmb"])
        let window = SMSUIViewController.visibleWindow()
        window?.addSubview(moreDrop)
        self.moreDrop.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 5
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        moreDrop.delegate = self
//        moreDrop.dataSource = ["新建执行计划", "模板目录"]
//        moreDrop.selectionAction = { [unowned self] (index, item) in
//            print("click \(index), \(item) ")
//            if index == 0 {
//                self.performSegue(withIdentifier: "addMsgSchedule", sender: self)
//            } else if index == 1 {
////                NetworkUtils.postBackEnd("R_BASE_TXL_CUS_GROUP", body: ["id" : "15dc14f554af466f99b946cc495bd772"]) {
////                    json in
////                    print("call back : \(json)")
////                }
//                let vc = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "TemplateSelectorController") as! TemplateSelectorController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        
    }
}

extension SMSUIViewController {
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("only one row ")
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SMSListViewCell
//        let section = indexPath.section
//        let schedule = self.schedules[section]
//        cell.imageLabel.image = UIImage(named: images[schedule.type]!)
//        cell.contentLabel.text = schedule.content
//        cell.timeLabel.text = "执行时间：\(schedule.executeTime!)/共\(schedule.count!)条短信"
//        cell.createLabel.text = schedule.createTime
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! SMSStatusCell
        let section = indexPath.section
        let schedule = self.schedules[section]
        cell.smsImage.image = UIImage(named: images[schedule.type]!)
        cell.textContent.text = schedule.content
        let status = schedule.status ?? "0"
        if (status == "1" || status == "3") {
            cell.smsStatus.textColor = APP_THEME_COLOR
        } else if (status == "0" || status == "4") {
            cell.smsStatus.textColor = UIColor.orange
        } else {
            cell.smsStatus.textColor = UIColor.red
        }
        cell.smsStatus.text = "状态未知"
        if let json: JSON = NetworkUtils.getDictionary(key: "DXJH_STATUS") {
            if let s = json[status].string {
                cell.smsStatus.text = s
            }
        }
        cell.createTime.text = "创建于:\(schedule.createTime!)"
        cell.executeDate.text = "执行时间:\(schedule.executeTime!)"
        cell.totalSMS.text = "\(schedule.count!)条短信"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showSMSDetailRel", sender: self.schedules[indexPath.section])
        // self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // print("display table view sections, 1/1")
        return self.schedules.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = APP_BACKGROUND_COLOR
        return view
    }
    
}

extension SMSUIViewController: ActionFloatViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSMSDetailRel" {
            let vc = segue.destination as! SMSDetailViewController
            vc.schedule = sender as! MessageSchedule
        }
    }
    
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        switch type.rawValue {
        case 0:
            self.performSegue(withIdentifier: "addMsgSchedule", sender: self)
            break
        case 1:
            let vc = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "TemplateSelectorController") as! TemplateSelectorController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "我的模板正在紧张研发中，敬请期待。"
            hub.hide(animated: true, afterDelay: 1.5)
        default:
            print("unexcepted tap action")
            break
        }
    }
}
