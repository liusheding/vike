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
    
    fileprivate let labels = ["姓名", "工作", "电话", "公司", "邮件" ,"地点"]
    
    var nlpResults: [Set<String>] = [Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>(),
                                 Set<String>()]
    
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "ScanResultCell", bundle: nil), forCellReuseIdentifier: cid)
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
        // self.view.addSubview(tableView)
    }
    
    func processReuslt(result: [String]) -> Customer? {
        return nil
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        
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
        for w in words! { //识别的前文本处理
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
    
}


extension ScanResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cid) as! ScanResultCell
        let row = indexPath.row
        cell.label.text = labels[row]
        let set: Set<String> = self.nlpResults[row]
        cell.textField.text = set.count == 0 ? "" : set.joined(separator: ",")
        return cell
    }
}
