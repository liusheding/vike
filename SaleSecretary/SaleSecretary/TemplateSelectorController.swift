//
//  TemplateSelectorController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import SnapKit

//var sections: [Section] = [
//    Section(name: "七夕节", items:[
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt)
//        ]),
//    Section(name: "中秋节", items:[
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt)
//        ]),
//    Section(name: "国庆节", items:[
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt),
//        Item(name:"", detail: txt)
//        ])
//]

fileprivate var templateSections: [Section] = []

class TemplateSelectorController: UIViewController {
    
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // 下拉框插件
    var menu: JSDropDownMenu!
    
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    
    var searchTableView: UITableView!
    
    let menuTitles = ["月份", "短信类型"]
    
    let months: [Month] = Month.allYear()
    
    var smsTypes:[[String]]?  {
        get {
            let _json = NetworkUtils.getDictionary(key: "DXMBLX")?.dictionaryValue
            if let json = _json  {
                let keys:[String] = [""] + json.flatMap({(key, _) in return key})
                let values:[String] = ["全部"] + json.flatMap({(_, value) in return value.stringValue})
                return [keys, values]
            }
            return [[""], ["全部"]]
        }
    }
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.months, self.smsTypes![1]]
    }()
    
    var indexForColumTypes: Int = 0
    
    
    // 模板tableview代理，需要跟UISearchBar分开
    var templateViewDelegate: TamplateTableViewDelegator?
    
    // 模板选择后代理，parentViewController如果要选择需要实现该代理
    var templateSelectorDelegate: TemplateSelectorDelegate?
    
    //
    var tableCanSelected: Bool = false
    
    
    fileprivate var currentMonth: Int = 12
    
    fileprivate var currentType: Int = 0
    
    var searchResults: [Item] = []
    var emptyView: EmptyContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 选择框
        self.menu = JSDropDownMenu(origin: CGPoint(x: 0, y: 108), andHeight: 45)
        // UIColor(colorLiteralRed: <#T##Float#>, green: <#T##Float#>, blue: <#T##Float#>, alpha: <#T##Float#>)
        // UIColor.init(displayP3Red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        menu.indicatorColor = UIColor(colorLiteralRed: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1)
        menu.separatorColor = UIColor(colorLiteralRed: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1)
        // menu.textColor = UIColor(colorLiteralRed: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1)
        menu.textColor = APP_THEME_COLOR
        menu.dataSource = self
        menu.delegate = self
        // self.tableView.isHidden = true
        self.view.addSubview(menu)
        self.automaticallyAdjustsScrollViewInsets = false
        // 模板table view
        self.templateViewDelegate = TamplateTableViewDelegator(self.tableView, controller: self)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = templateViewDelegate
        self.tableView.dataSource = templateViewDelegate
        self.tableView.tableFooterView = UIView()
        if !tableCanSelected {
            self.confirmBtn.title = nil
        }
        self.loadData()
        // 搜索
        self.searchTableView = self.searchDisplayController?.searchResultsTableView
        self.searchTableView.estimatedRowHeight = 44.0
        self.searchTableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.snp.makeConstraints({
            make in
            make.top.equalTo(self.menu.snp.bottom)
        })
        
    }
    
    
    @IBAction func confirmSelection(_ sender: UIBarButtonItem) {
        let idx = self.templateViewDelegate?.selectedPath
        if idx != nil {
            let cell = self.tableView.cellForRow(at: idx!) as! CollapsibleTableViewCell
            let content = cell.detailLabel.text!
            let template = SMSTemplate("", content: content)
            template.id = cell.templateId!
            template.dxtd = cell.dxtdId!
            self.templateSelectorDelegate!.didSelected(template)
            let count = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[count! - 2])!, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func loadData() {
        if self.emptyView != nil {
            self.emptyView?.dismiss()
        }
        let hub: MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.label.text = "正在加载中..."
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            var body: [String: Any] = [:]
            if self.currentMonth != 12 {
                body["month"] = String(self.currentMonth + 1)
            }
            if self.currentType != 0 {
                body["type"] = self.smsTypes?[0][self.currentType]
            }
            let request = NetworkUtils.postBackEnd("R_QUERY_DXMB", body: body) {
                json in
                let array:[JSON]? = json["body"].array
                templateSections = self.toSections(array)
                if templateSections.count == 0 {
                    self.emptyView = EmptyContentView.init(frame: self.tableView.frame)
                    self.emptyView?.showInView(self.view)
                }
            }
            request.response(completionHandler: { _ in
                hub.hide(animated: true)
                self.tableView.reloadData()
            })
        }
    }
    
    func toSections(_ array: [JSON]?) -> [Section] {
        var _sec:[Section] = []
        if let arr = array {
            for s in arr {
                let name = s["name"].stringValue
                let list = s["list"].arrayValue
                var items: [Item] = []
                for item in list {
                    var i = Item(name: "", detail: item["content"].stringValue)
                    i.templateId = item["id"].stringValue
                    i.dxtd = item["dxtdId"].stringValue
                    items.append(i)
                }
                _sec.append(Section(name: name, items: items))
            }
        }
        return _sec
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        templateSections = []
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
        var needReload = false
        if indexPath.column == 1 {
            self.indexForColumTypes = indexPath.row
            if indexPath.row != self.currentType {
                self.currentType = indexPath.row
                needReload = true
            }
        } else {
            if indexPath.row != self.currentMonth {
                self.currentMonth = indexPath.row
                needReload = true
            }
        }
        if needReload {
            self.loadData()
        }
    }
}


extension TemplateSelectorController: UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CollapsibleTableViewCell(style: .subtitle, reuseIdentifier: "smsTemplateSearchCell")
        let item = self.searchResults[indexPath.row]
        let textLabel = cell.detailLabel
        textLabel.text = item.detail
        textLabel.textColor = UIColor.black
        cell.dxtdId = item.dxtd
        cell.templateId = item.templateId
        return cell
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        var result:[Item] = []
        let text = self.searchBar.text
        for sec in templateSections {
            if sec.name.contains(text!) {
                result += sec.items
                continue
            }
            for item in sec.items {
                if item.detail.contains(text!) {
                    result.append(item)
                }
            }
        }
        self.searchResults = result
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CollapsibleTableViewCell
        if self.tableCanSelected {
            let content = cell.detailLabel.text!
            let temp = SMSTemplate("", content: content)
            temp.id = cell.templateId!
            temp.dxtd = cell.dxtdId!
            self.templateSelectorDelegate!.didSelected(temp)
            let count = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[count! - 2])!, animated: true)
        }
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        if let text = searchString {
            var result:[Item] = []
            for sec in templateSections {
                if sec.name.contains(text) {
                    result += sec.items
                    continue
                }
                for item in sec.items {
                    if item.detail.contains(text) {
                        result.append(item)
                    }
                }
            }
            self.searchResults = result
            return true
        } else {
            return false
        }
    }
    
    
}
typealias Section = CollapsibleSection
typealias Item = CollapsibleItem

let txt = "没有相关模板"


protocol TemplateSelectorDelegate {
    func didSelected(_ template: SMSTemplate)
}

class TamplateTableViewDelegator: NSObject ,UITableViewDataSource, UITableViewDelegate, CollapsibleTableViewHeaderDelegate {
    
    var tableView : UITableView
    
    var controller: TemplateSelectorController
    
    var selectedPath : IndexPath?
    
    public init(_ tableView : UITableView, controller: TemplateSelectorController) {
        self.tableView = tableView
        self.controller = controller
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return templateSections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateSections[section].collapsed ? 0 : templateSections[section].items.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = CollapsibleTableViewCell(style: .subtitle , reuseIdentifier: "cell")
        let item: Item = templateSections[indexPath.section].items[indexPath.row]
        // cell.nameLabel.text = item.name
        cell.detailLabel.text = item.detail
        cell.dxtdId = item.dxtd!
        cell.templateId = item.templateId!
        if controller.tableCanSelected {
            // cell.accessoryView = UIImageView(image: UIImage(named: "ico_nr"))
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
        }
        
        return cell
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = templateSections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(templateSections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !templateSections[section].collapsed
        // Toggle collapse
        templateSections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if controller.tableCanSelected {
            if selectedPath == nil  {
                cell?.accessoryType = .disclosureIndicator
                cell?.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
                selectedPath = indexPath
            } else if selectedPath == indexPath {
                cell?.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
                selectedPath = nil
            } else {
                cell?.accessoryType = .disclosureIndicator
                cell?.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
                let sCell = tableView.cellForRow(at: selectedPath!)
                if sCell != nil {
                    sCell?.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
                }
                selectedPath = indexPath
            }
        }
    }
}



