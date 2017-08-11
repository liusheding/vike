//
//  TemplateSelectorController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TemplateSelectorController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var menu: JSDropDownMenu!
    
    let menuTitles = ["月份", "短信类型"]
    
    let months: [Month] = Month.allYear()
    
    let smsTypes = ["祝福类", "营销类", "自定义"]
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.months, self.smsTypes]
    }()
    
    var indexForColumTypes: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menu = JSDropDownMenu(origin: CGPoint(x: 0, y: 108), andHeight: 45)
        // UIColor(colorLiteralRed: <#T##Float#>, green: <#T##Float#>, blue: <#T##Float#>, alpha: <#T##Float#>)
        // UIColor.init(displayP3Red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        menu.indicatorColor = UIColor(colorLiteralRed: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1)
        menu.separatorColor = UIColor(colorLiteralRed: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1)
        menu.textColor = UIColor(colorLiteralRed: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1)
        menu.dataSource = self
        menu.delegate = self
        // self.tableView.isHidden = true
        self.view.addSubview(menu)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    
}

extension TemplateSelectorController: JSDropDownMenuDataSource, JSDropDownMenuDelegate {
    
    
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
            let ms = self.menus[col] as! [Month]
            return ms[row].chinese
        case 1:
            let ts = self.menus[col] as! [String]
            return ts[row]
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
        if column == 0 {
            return 0
        }
        return indexForColumTypes
    }
    
    func displayByCollectionView(inColumn column: Int) -> Bool {
        if column == 0 { return true }
        return false
    }
    
    func menu(_ menu: JSDropDownMenu!, didSelectRowAt indexPath: JSIndexPath!) {
        if indexPath.column == 1 {
            self.indexForColumTypes = indexPath.row
        }
        print(indexPath)
    }
}


extension TemplateSelectorController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "smsTemplateSearchCell")
        cell.textLabel?.text = "你好ya "
        return cell
    }
}



