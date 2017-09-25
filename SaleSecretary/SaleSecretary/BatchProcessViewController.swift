//
//  BatchProcessViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/30.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class BatchProcessViewController: UIViewController {

    let batchCell = "batchCell"
    let bottomHeight : CGFloat = 60
    let batchMoveGroupWidth : CGFloat = 100
    
    @IBOutlet weak var tableView: UITableView!
    
    let customerDB = CustomerDBOp.defaultInstance()
    
    var contacts: [CustomerGroup] = CustomerDBOp.defaultInstance().getContacts2Group(userId: APP_USER_ID!)
    
    let cellId : String  = "CustomerSelectViewCellId"
    
    var delegate: ContactTableViewDelegate?
    
    lazy var collapses: [Bool] = { [unowned self] in
        return Array<Bool>(repeating: true, count: self.contacts.count)
    }()

    var selctions: JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selctions = self.initSelections()
        self.tableViewInit()
        
        self.navigationSetting()
        self.bottomSetting()
        delegate = ContactTableViewController.instance
    }
    
    func initSelections() -> JSON {
        var _selctions: [[String: Any]] = []
        for c in self.contacts {
            var dict:[String: Any] = [:]
            dict["status"] = false
            dict["array"] = Array<Bool>(repeating: false, count: c.friends!.count)
            _selctions.append(dict)
        }
        return JSON(_selctions)
    }
    
    func navigationSetting() {
        self.navigationItem.title = "批量处理"
    }
    
    func bottomSetting() {
        let baseX = self.view.frame.size.height - self.bottomHeight
        
        let bottomView = UIView.init(frame: CGRect(x: 0 , y : baseX , width:self.view.frame.size.width, height: self.bottomHeight ))
        bottomView.backgroundColor = UIColor.groupTableViewBackground
        
        let leftButton = UIButton.init(frame: CGRect(x: 5 , y: 5  , width: self.batchMoveGroupWidth , height: self.bottomHeight - 5 ))
        leftButton.setTitle("移动分组", for: .normal )
        leftButton.setTitleColor( ContactCommon.THEME_COLOR , for: .normal)
        leftButton.setTitleColor( UIColor.lightGray , for: .disabled)
//        leftButton.isEnabled = false
        leftButton.addTarget(self , action: #selector(batchMovedGroup), for: .touchUpInside )
        
        let rightButton = UIButton.init(frame: CGRect(x:self.view.frame.size.width - self.batchMoveGroupWidth , y: 5  , width: self.batchMoveGroupWidth , height: self.bottomHeight - 5 ))
        rightButton.setTitleColor( UIColor.red , for: .normal)
        rightButton.setTitleColor( UIColor.lightGray , for: .disabled)
        rightButton.setTitle("批量删除", for:  .normal )
//        rightButton.isEnabled = false
        rightButton.addTarget(self, action: #selector(batchDelete), for: .touchUpInside )
        
        bottomView.addSubview(rightButton)
        bottomView.addSubview(leftButton)
        self.view.addSubview(bottomView)
    }
    
    func cancelButton()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSelectIndexPath() -> [[Int]] {
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
        return idxs
    }

    func batchMovedGroup()  {
        
        let idxs:[[Int]] = self.getSelectIndexPath()
        if idxs.count == 0 {
            let uc = UIAlertController(title: "提示信息", message: "请选择需要移动的客户！", preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            self.present(uc, animated: true, completion: nil)
            return
        }
        var _recs : [Customer] = []
        for idx in idxs {
            let i = idx[0], j = idx[1]
            _recs.append((self.contacts[i].friends?[j])!)
        }
        
        let detailPage = UIStoryboard(name: "ContactStoryboard" , bundle: nil).instantiateViewController(withIdentifier: "selectGroup") as! CTChooseGroupController
        detailPage.selectedCustomer = _recs
        detailPage.reloadViewDelegate = self
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
    
    func batchDelete( ) {
        let idxs:[[Int]] = self.getSelectIndexPath()
        
        if idxs.count == 0 {
            let uc = UIAlertController(title: "警告", message: "请选择需要删除的客户！", preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            self.present(uc, animated: true, completion: nil)
            return
        }
        var _recs : [Customer] = []
        for idx in idxs {
            let i = idx[0], j = idx[1]
            _recs.append((self.contacts[i].friends?[j])!)
        }
        let alertController = UIAlertController(title: "删除提醒", message: "确定从销小秘中删除这 \(_recs.count) 个用户？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            var phoneArr : [String] = []
            for r in _recs {
                phoneArr.append( (r.phone_number?.count)!>0 ? (r.phone_number?[0])! : "" )
            }
            let request = NetworkUtils.postBackEnd("D_TXL_CUS_INFO", body: ["userId":APP_USER_ID! , "sjhms" : phoneArr.joined(separator: ContactCommon.separatorDefault) ], handler: { (json) in
                self.customerDB.batchDeleteCustomer(cust: _recs)
            })
            request.response(completionHandler: { _ in
                self.reloadTableViewData()
                self.delegate?.reloadTableViewData()
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
    }
    
}

extension BatchProcessViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableViewInit()  {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsMultipleSelection = true
        self.tableView.estimatedRowHeight = 35
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: CollapsibleTableImageViewCell = CollapsibleTableImageViewCell(style: .subtitle , reuseIdentifier: "CollapsibleTableImageViewCell")
        
        let status = self.selctions[indexPath.section]["array"][indexPath.row].boolValue
        
        let item: Customer = self.contacts[indexPath.section].friends![indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.detailLabel.text = item.phone_number?.joined(separator: ",")
        cell.nameLabel.text = item.name
        
        cell.accessoryType = .disclosureIndicator
        if !status {
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_wxz"))
        } else {
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_xz_1"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return self.collapses[section] ? 0 : (self.contacts[section].friends?.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "imageHeader") as? CollapsibleImageHeaderView ?? CollapsibleImageHeaderView(reuseIdentifier: "imageHeader")
        let status = self.selctions[section]["status"].boolValue
        header.titleLabel.text = self.contacts[section].name
        header.section = section
        header.delegate = self
        header.collapsed = self.collapses[section]
        if status {
            header.imageLabel.image = UIImage(named: "icon_xz_1")
        }
        return header
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

extension BatchProcessViewController : CollapsibleImageHeaderViewDelegate {
    
    func toggleSection(_ header: CollapsibleImageHeaderView, section: Int) {
        if (self.contacts[section].friends?.count)! > 3000 {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.show(animated: true, whileExecuting: {
                let collapsed = !self.collapses[section]
                self.collapses[section] = collapsed
                header.setHeaderCollapsed(collapsed)
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }, on: DispatchQueue.main)
        }else {
            let collapsed = !self.collapses[section]
            self.collapses[section] = collapsed
            header.setHeaderCollapsed(collapsed)
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        
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
extension BatchProcessViewController : ContactTableViewDelegate {
    func reloadTableViewData( ){
        self.contacts = CustomerDBOp.defaultInstance().getContacts2Group(userId: APP_USER_ID!, true)
        self.selctions = self.initSelections()
        self.tableView.reloadData()
    }
}

