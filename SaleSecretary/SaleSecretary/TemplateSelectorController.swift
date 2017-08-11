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
    
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    
    let menuTitles = ["月份", "短信类型"]
    
    let months: [Month] = Month.allYear()
    
    let smsTypes = ["祝福类", "营销类", "自定义"]
    
    lazy var menus: [[Any]] = { [unowned self] in
        return [self.months, self.smsTypes]
    }()
    
    var indexForColumTypes: Int = 0
    
    var templateDelegate: TamplateTableViewDelegator?
    
    var tableCanSelected: Bool = true

    
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
        self.templateDelegate = TamplateTableViewDelegator(self.tableView, controller: self)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = templateDelegate
        self.tableView.dataSource = templateDelegate
        self.tableView.tableFooterView = UIView()
        
        if !tableCanSelected {
            self.confirmBtn.title = nil
        }
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
        cell.textLabel?.text = txt
        return cell
    }
}
typealias Section = CollapsibleSection
typealias Item = CollapsibleItem

let txt = "七夕到，喜鹊叫，我发短信把喜报，一喜夫妻恩爱好，二喜儿女膝边绕，三喜体健毛病少，四喜平安把你照，五喜吉祥富贵抱，六喜开心没烦恼，七喜幸福指数高，七夕的短信转转好，七夕的快乐少不了！"

class TamplateTableViewDelegator: NSObject ,UITableViewDataSource, UITableViewDelegate, CollapsibleTableViewHeaderDelegate {
    
    var tableView : UITableView
    
    var controller: TemplateSelectorController
    
    var selectedPath : IndexPath?
    
    var sections: [Section] = [
        Section(name: "七夕节", items:[
            Item(name:"", detail: txt),
            Item(name:"", detail: txt),
            Item(name:"", detail: txt),
            Item(name:"", detail: txt)
        ]),
        Section(name: "中秋节", items:[
            Item(name:"", detail: txt),
            Item(name:"", detail: txt),
            Item(name:"", detail: txt)
        ]),
        Section(name: "我的模板", items:[
            Item(name:"", detail: txt),
            Item(name:"", detail: txt),
            Item(name:"", detail: txt)
        ])
    ]
    
    let unSelectedImage = UIImageView(image: UIImage(named: "ico_wxz"))
    let doSelectedImage = UIImageView(image: UIImage(named: "ico_xz_1"))
    
    public init(_ tableView : UITableView, controller: TemplateSelectorController) {
        self.tableView = tableView
        self.controller = controller
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = CollapsibleTableViewCell(style: .subtitle , reuseIdentifier: "cell")
        
        let item: Item = sections[indexPath.section].items[indexPath.row]
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
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        return header
    }
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
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



