//
//  BusinessRecordController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class BusinessRecordController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menu: JSDropDownMenu!
    var selTimesIndex:Int = 0
    var selJobsIndex:Int = 0
    
    let menuTitles = ["全部", "全部"]
    
    let times = ["全部", "今天", "最近一周", "最近一月", "最近半年", "最近一年"]
    
    let jobs = ["全部", "一级代理", "二级代理", "业务员"]
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.times, self.jobs]
        }()
    
    let RecordCells = [
        ["label": "新增会员", "image": "icon_xzhy", "info":"10人"],
        ["label": "短信群发数量", "image": "icon_dxqf", "info":"200条"],
        ["label": "充值金额", "image": "icon_czje", "info":"150元"],
        ["label": "剩余短信数量", "image": "icon_sydx", "info":"188条"],
        ["label": "累计提成", "image": "icon_ljtc", "info":"500元"],
        ]
    
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
        case 0, 1:
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
        if menu.currentSelectedMenudIndex == 0{
            return self.selTimesIndex
        }else{
            return self.selJobsIndex
        }
    }
    
    func displayByCollectionView(inColumn column: Int) -> Bool {
        return false
    }
    
    func menu(_ menu: JSDropDownMenu!, didSelectRowAt indexPath: JSIndexPath!) {
        if menu.currentSelectedMenudIndex == 0{
            self.selTimesIndex = indexPath.row
        }else{
            self.selJobsIndex = indexPath.row
        }
    }
}


extension BusinessRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RecordCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "smsTemplateCell")
        cell.imageView?.image = UIImage(named: (self.RecordCells[indexPath.row]["image"])!)
        cell.textLabel?.text = self.RecordCells[indexPath.row]["label"]
        cell.detailTextLabel?.text = self.RecordCells[indexPath.row]["info"]
        cell.detailTextLabel?.textColor = APP_THEME_COLOR
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
}
