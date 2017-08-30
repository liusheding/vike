//
//  TemplateSelectorController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

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

var templateSections: [Section] = []

class TemplateSelectorController: UIViewController {
    
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // 下拉框插件
    var menu: JSDropDownMenu!
    
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    
    
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
    
    // var sections:[Section] = []
    
    
    
    
    // 模板tableview代理，需要跟UISearchBar分开
    var templateViewDelegate: TamplateTableViewDelegator?
    
    // 模板选择后代理，parentViewController如果要选择需要实现该代理
    var templateSelectorDelegate: TemplateSelectorDelegate?
    
    //
    var tableCanSelected: Bool = false

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    
    @IBAction func confirmSelection(_ sender: UIBarButtonItem) {
        let idx = self.tableView.indexPathForSelectedRow
        if self.templateSelectorDelegate != nil {
            if idx != nil {
                let cell = self.tableView.cellForRow(at: idx!) as! CollapsibleTableViewCell
                let content = cell.detailLabel.text!
                self.templateSelectorDelegate!.didSelected(SMSTemplate("fake_id", content: content))
                let count = self.navigationController?.viewControllers.count
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[count! - 2])!, animated: true)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func loadData() {
        
        if templateSections.count > 0 { return }
        
        let hub: MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hub.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(3)
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_DXMB", body: ["pageSize": "20"]) {
                json in
                print(json)
            }
            request.response(completionHandler: { _ in hub.hide(animated: true)})
        }
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
        cell.textLabel?.text = txt
        return cell
    }
}
typealias Section = CollapsibleSection
typealias Item = CollapsibleItem

let txt = "七夕到，喜鹊叫，我发短信把喜报，一喜夫妻恩爱好，二喜儿女膝边绕，三喜体健毛病少，四喜平安把你照，五喜吉祥富贵抱，六喜开心没烦恼，七喜幸福指数高，七夕的短信转转好，七夕的快乐少不了！"


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
        cell.backgroundColor = UIColor.clear
        // cell.nameLabel.text = item.name
        cell.detailLabel.text = item.detail
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
        let cell = tableView.cellForRow(at: indexPath)
        if controller.tableCanSelected {
            cell?.accessoryType = .disclosureIndicator
            cell?.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
            if selectedPath != nil {
                let sCell = tableView.cellForRow(at: selectedPath!)
                if sCell != nil {
                    sCell?.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
                }
            }
            selectedPath = indexPath
        }
    }
}



