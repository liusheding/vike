//
//  ScanResultViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum NLPWordNE: String {
    case PER = "PER"
    case ORG = "ORG"
    case LOC = "LOC"
    case TIME = "TIME"
}

class ScanResultViewController: UIViewController, ScanORCResultDelegate {
    
    var words:[String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cid = "ScanResultCellId"
    
    fileprivate let labels = ["姓名*", "工作", "电话*", "公司", "邮件" ,"地点"]
    
    var nlpResults: [Set<String>] = [Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>()]
    
    var indicator: UIActivityIndicatorView?
    
    let contactDb = CustomerDBOp.defaultInstance()
    
    var groups: [Group]!
    
    var group: Group?
    
    var delegate: ContactTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "ScanResultCell", bundle: nil), forCellReuseIdentifier: cid)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44.0
        tableView.sectionHeaderHeight = 10.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = APP_BACKGROUND_COLOR
        // let v = UIActivityIndicatorView.init(frame: CGRect(x: 50, y: 200, width: 200, height: 200))
        // self.makeIndicator()
        if words != nil {
            // self.navigationController?.view.makeToast("正在理解识别文字..", duration: 5.0, position: .center, title: nil, image: UIImage(named:""), completion: nil)
            // self.navigationController?.view.makeToast("正在理解识别文字", duration: 5.0, position: .center)
            self.indicator?.isHidden = false
            self.indicator?.startAnimating()
            loadNlpResults()
        }
        self.groups = self.contactDb.getGroupInDb(userId: APP_USER_ID!)
        for g in self.groups {
            if g.group_name! == "默认分组" {
                self.group = g
                break
            }
        }
        self.delegate = ContactTableViewController.instance
        // self.view.addSubview(tableView)
    }
    
    func processReuslt(result: [String]) -> Customer? {
        return nil
    }
    
    func makeIndicator() {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0,height: 100.0))
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.center = self.view.center
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 10
        view.color = APP_THEME_COLOR
        view.isHidden = true
        view.hidesWhenStopped = true
        self.indicator = view
        self.view.addSubview(self.indicator!)
    }

 
    func loadNlpResults() {
        var str = ""
        for w in words! { //识别前的文本处理
            var s = w.replacingOccurrences(of: " ", with: "")
            if s.lengthOfBytes(using: .utf8) < 2 { continue }
            s += ","
            str += s
        }
        self.words = str.components(separatedBy: ",")
        NetworkUtils.requestNLPLexer(str, successHandler: { (val) in
            let items = val["items"].arrayValue
            if items.count <= 0 {}
            else {
                self.parseNlpResults(items: items)
                self.tableView.reloadData()
            }
            self.indicator?.stopAnimating()
        })
    }
    
    // ["姓名", "称谓", "电话", "公司", "邮件" ,"地点"]
    //TODO 
    func parseNlpResults(items: [JSON]) {
        for item in items {
            let ne = item["ne"].string!  // 命名实体类型
            // let pos = item["pos"].string! // 词性
            let str:String = item["item"].string! //词汇的字符串
            if str == "" {continue}
            let nep = NLPWordNE(rawValue: ne)
            if let np = nep {
                switch np {
                case .PER: //人名
                    self.nlpResults[0].insert(str)
                case .ORG: //组织
                    if let org = self.getFullWords(str: str) {
                        self.nlpResults[3].insert(org)
                    }
                case .LOC: //地点
                    if let loc = self.getFullWords(str: str) {
                        self.nlpResults[5].insert(loc)
                    }
                default: break
                }
                continue
            }
            //  手机
            if let matchs = Utils.matchsMobile(str: str) {
                for m in matchs {
                    self.nlpResults[2].insert(m)
                }
                continue
            }
            // 邮箱
            if str.contains("@") {
                if let w = getFullWords(str: str) {
                    self.nlpResults[4].insert(str)
                }
                continue
            }
            // 工作
            if let job = Utils.matchesJob(str: str) {
                self.nlpResults[1].insert(str)
                continue
            }
        }
    }
    
    func getFullWords(str: String!) -> String? {
        for word in self.words! {
            if word.contains(str) {
                return word
            }
        }
        return nil
    }
    
    func chooseRole(title : String , index : IndexPath) {
        
        let alertController = UIAlertController(title: "", message: title ,preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for group in self.groups {
            let roleAction = UIAlertAction(title: group.group_name, style: .destructive, handler: {_ in self.showRole(group , index: index)})
            alertController.addAction(roleAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showRole(_ g: Group , index : IndexPath){
        let cell = self.tableView.cellForRow(at: index)
        cell?.detailTextLabel?.text = g.group_name
        self.group = g
    }
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        let customer: Customer = Customer()
        let vals: [String?] = self.labels.enumerated().flatMap({
            e -> String? in
            return getText(at: [0, e.offset])
        })
        let name = vals[0]
        let phone = vals[2]
        if name == nil || phone == nil {
            Utils.alert("请务必填写客户姓名和电话哦")
            return
        }
         // ["姓名*", "工作", "电话*", "公司", "邮件" ,"地点"]
        customer.name = name!
        customer.phone_number?.append(phone!)
        customer.nick_name = "\(name!)\(vals[1] ?? "")"
        customer.company = vals[3] ?? ""
        customer.desc = vals[5] ?? ""
        customer.group_id = (self.group?.id)!
        
        Utils.showLoadingHUB(view: self.view, msg: "保存中..", completion: {
            hub in
            let req = customer.save({
                json in
                self.delegate?.reloadTableViewData()
                self.navigationController?.popViewController(animated: true)
            })
            req?.response(completionHandler: {
                _ in
                hub.hide(animated: true)
            })
        })
    }
    
    
    func getText(at: IndexPath) -> String? {
        let cell = self.tableView.cellForRow(at: at) as! ScanResultCell
        let text = cell.textField.text
        if text == nil  {
            return nil
        }
        let str = text!
        if str.isEmpty || str.trimmingCharacters(in: .whitespaces).isEmpty {
            return nil
        }
        return str
    }
    
}


extension ScanResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return labels.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if indexPath.section == 1 {
            let cell = UITableViewCell(style:.value1, reuseIdentifier: "")
            let attr = NSMutableAttributedString(string: "分组*")
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 2, length: 1))
            attr.addAttribute(NSForegroundColorAttributeName, value: APP_THEME_COLOR, range: NSRange(location: 0, length: 2))
            cell.textLabel?.attributedText = attr
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.snp.makeConstraints({
                make in
                make.left.equalToSuperview().offset(5)
                make.centerY.equalToSuperview()
            })
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = self.group?.group_name
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.detailTextLabel?.textAlignment = .right
            cell.detailTextLabel?.textColor = UIColor.black
            cell.backgroundColor = APP_BACKGROUND_COLOR
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cid) as! ScanResultCell
        let text = labels[row]
        if text.contains("*") {
            let attr = NSMutableAttributedString(string: text)
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSString(string: text).range(of: "*"))
            cell.label.attributedText = attr
        } else {
            cell.label.text = text
        }
        let set: Set<String> = self.nlpResults[row]
        cell.textField.text = set.count == 0 ? "" : set.joined(separator: ",")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            self.chooseRole(title: "选择分组", index: indexPath)
        }
    }
    
    
}
