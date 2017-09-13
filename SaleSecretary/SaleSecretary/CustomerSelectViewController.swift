//
//  CustomerSelectViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CustomerSelectDelegate {
    
    func selectedRecipients(rec:[Customer])
}

protocol CustomerGroupTapDelegate {
    
    func tappedSectionImage(_ section: Int)
    
    func tappedRow(_ indexPath: IndexPath)
}




class CustomerSelectViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CustomerSelectDelegate?
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    
    let customerDB = CustomerDBOp.defaultInstance()
    
    var contacts: [CustomerGroup] = CustomerDBOp.defaultInstance().getContacts2Group(userId: APP_USER_ID!)
    
    let cellId : String  = "CustomerSelectViewCellId"
    
    lazy var collapses: [Bool] = { [unowned self] in
        return Array<Bool>(repeating: true, count: self.contacts.count)
    }()
    
    // 初始化二维状态数组，
    // false = 未选择 true =  选择
    // status 为整个group的选择状态
    lazy var selctions: JSON = {[unowned self] in
        var _selctions: [[String: Any]] = []
        for c in self.contacts {
            var dict:[String: Any] = [:]
            dict["status"] = false
            dict["array"] = Array<Bool>(repeating: false, count: c.friends!.count)
            _selctions.append(dict)
        }
        return JSON(_selctions)
    }()
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        print(self.tableView.indexPathsForSelectedRows ?? "selected none")
        
        var idxs:[[Int]] = []
        let cnt = self.selctions.arrayValue.count
        for i in 0..<cnt {
            let array = selctions[i]["array"].arrayValue
            let acnt = array.count
            for j in 0..<acnt {
                if array[j].boolValue {
                    idxs.append([i, j])
                }
            }
        }
        if idxs.count == 0 {
            let uc = UIAlertController(title: "", message: "请选择客户", preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            self.present(uc, animated: true, completion: nil)
            return
        }
        var _recs : [Customer] = []
        for idx in idxs {
           // _recs.append(self.contacts[i.row])
            let i = idx[0], j = idx[1]
            _recs.append((self.contacts[i].friends?[j])!)
        }
        
        self.dismiss(animated: true) { [weak self] in
            let that = self!
            if that.delegate != nil {
                that.delegate?.selectedRecipients(rec: _recs)
            }
        }
    }
    
//    lazy var contacts : [Recipient] = {
//        
//        let _rec = [Recipient(name : "客户1", phone : "18519283902"),
//                    Recipient(name : "客户2", phone : "13319283902"),
//                    Recipient(name : "客户3", phone : "185192233902")]
//        return _rec
//        
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }

    
}

extension CustomerSelectViewController : UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.allowsMultipleSelection = true
        self.tableView.estimatedRowHeight = 35
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collapses[section] ? 0 : (self.contacts[section].friends?.count)!
        // return self.contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "imageHeader") as? CollapsibleImageHeaderView ?? CollapsibleImageHeaderView(reuseIdentifier: "imageHeader")
        let status = self.selctions[section]["status"].boolValue
        header.titleLabel.text = self.contacts[section].name
        // header.arrowLabel.text = ">"
        // header.setCollapsed(sections[section].collapsed)
        header.section = section
        header.delegate = self
        header.collapsed = self.collapses[section]
        if status {
            header.imageLabel.image = UIImage(named: "icon_xz_1")
        }
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CollapsibleTableImageViewCell = CollapsibleTableImageViewCell(style: .subtitle , reuseIdentifier: "CollapsibleTableImageViewCell")
        
        let status = self.selctions[indexPath.section]["array"][indexPath.row].boolValue
        
        let item: Customer = self.contacts[indexPath.section].friends![indexPath.row]
        cell.backgroundColor = UIColor.clear
        // cell.nameLabel.text = item.name
        cell.detailLabel.text = item.phone_number?.joined(separator: ",")
        cell.nameLabel.text = item.name
        
        // cell.accessoryView = UIImageView(image: UIImage(named: "ico_nr"))
        cell.accessoryType = .disclosureIndicator
        if !status {
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
        } else {
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let status = !self.selctions[indexPath.section]["array"][indexPath.row].boolValue
        self.selctions[indexPath.section]["array"][indexPath.row].boolValue = status
        self.changeAccessoryView(indexPath, status: status)
        let header = self.tableView.headerView(forSection: section) as! CollapsibleImageHeaderView
        if !status {
            self.selctions[section]["status"].boolValue = status
            header.imageLabel.image = UIImage(named: "icon_wxz")
        } else {
            var all = true
            let array = self.selctions[section]["array"].arrayValue
            for obj in array {
                if !obj.boolValue {
                    all = false
                    break
                }
            }
            if all {
                header.imageLabel.image = UIImage(named: "icon_xz_1")
            }
        }
    }
    
    func changeAccessoryView(_ indexPath: IndexPath, status: Bool) {
        let cell = self.tableView.cellForRow(at: indexPath)
        if !status {
            
            cell?.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
        } else {
            cell?.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
                    }
    }
}

extension CustomerSelectViewController: CollapsibleImageHeaderViewDelegate {
    
    func toggleSection(_ header: CollapsibleImageHeaderView, section: Int) {
        let collapsed = !self.collapses[section]
        self.collapses[section] = collapsed
        header.setHeaderCollapsed(collapsed)
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tappedSectionImage(_ section: Int) {
        var sec = self.selctions[section]
        let status = !sec["status"].boolValue
        self.selctions[section]["status"].boolValue = status
        let array = self.selctions[section]["array"].arrayValue
        let count = array.count
        for i in 0..<count {
            self.selctions[section]["array"][i].boolValue = status
        }
        // 展开状态下 直接修改section下面的所有的row
        if !self.collapses[section] {
            let count = self.selctions[section]["array"].arrayValue.count
            for i in 0..<count {
                self.changeAccessoryView(IndexPath(row: i, section: section), status: status)
            }
        }
        
    }
    
    func sectionStatus(_ section: Int) -> Bool {
        return self.selctions[section]["status"].boolValue
    }
    
}

