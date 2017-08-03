//
//  CustomerSelectViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


protocol CustomerSelectDelegate {
    
    func selectedRecipients(rec:[Recipient])
}

class CustomerSelectViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CustomerSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    
    let cellId : String  = "CustomerSelectViewCellId"
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        print(self.tableView.indexPathsForSelectedRows ?? "selected none")
        
        let idxs = self.tableView.indexPathsForSelectedRows
        
        if idxs == nil {
            let uc = UIAlertController(title: "", message: "请选择客户", preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            present(uc, animated: true, completion: nil)
            return
        }
        var _recs : [Recipient] = []
        for i in idxs! {
            _recs.append(self.contacts[i.row])
        }
        
        self.dismiss(animated: true) { [weak self] in
            let that = self!
            if that.delegate != nil {
                that.delegate?.selectedRecipients(rec: _recs)
            }
        }
    }
    
    lazy var contacts : [Recipient] = {
        
        let _rec = [Recipient(name : "客户1", phone : "18519283902"),
                    Recipient(name : "客户2", phone : "13319283902"),
                    Recipient(name : "客户3", phone : "185192233902")]
        return _rec
    }()
    
    
}

extension CustomerSelectViewController : UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.allowsMultipleSelection = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_kh")
        cell.textLabel?.text = self.contacts[indexPath.row].name
        cell.detailTextLabel?.text = self.contacts[indexPath.row].phone
        // cell.de
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        let v = UIView.init(frame: cell.frame)
        v.backgroundColor = UIColor.init(valueRGB: 0x50af37)
        cell.selectedBackgroundView = v
        cell.accessoryType = UITableViewCellAccessoryType.detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.detailButton
    }
    
}

