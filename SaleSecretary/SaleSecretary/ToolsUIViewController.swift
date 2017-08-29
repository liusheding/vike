//
//  ToolsUIViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import AipBase
import AipOcrSdk
import SwiftyJSON
import MBProgressHUD


let AIP_APP_KEY = "A5BKNDgXQavsP5O2HpTXPP1X"

let AIP_APP_SK = "5O2jMbVeUGBHc64DgwHHRGA6OtP2svY6"

protocol ScanORCResultDelegate {
    func processReuslt(result:[String]) -> Customer?
}


class ToolsUIViewController : UITableViewController {
    
    
    
    let cellId = "toolsListID"
    
    let storyBoard = UIStoryboard(name: "SMSView", bundle: nil)
    
//    @objc
//    lazy var aip : AipOcrService = {
//        let _aip = AipOcrService.shard()
//        _aip?.auth(withAK: AIP_APP_KEY, andSK: AIP_APP_SK)
//        _aip?.getTokenSuccessHandler({token in print(token!)}, failHandler: {(error) in print(error ?? "")})
//        return _aip!
//    }()
    
    var aipVC: UIViewController?
    
    var accessToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.backgroundColor = APP_BACKGROUND_COLOR
        self.tableView.register(UINib(nibName: String(describing: ToolCellView.self), bundle: nil), forCellReuseIdentifier: cellId)
        // self.tableView.register(MessageListCell.self, forCellReuseIdentifier: "MessageListID")
        // CSToastManager.setQueueEnabled(true)
        // CSToastManager.setTapToDismissEnabled(true)
        //
        // let l = NSData(contentsOfFile: "aip.license")
        NetworkUtils.refreshAipSession()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.toolCells[section]?.count)!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 10))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    private var toolCells = [
        0: [["label": "短信计划", "image": "icon_gj_dxjh", "id":"dxjg"]],
        1: [["label": "名片扫描", "image": "icon_gj_mpsm", "id":"mpsm"], ["label": "二维码名片", "image": "icon_gj_ewmmp", "id":"ewmmp"]],
        2: [["label": "查找企业", "image": "icon_gj_czqy", "id":"czqy"]]
    ]
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secNum = indexPath.section
        // _ = curIdx(sec: secNum)
        let rowNo = indexPath.row
        let dict = self.toolCells[secNum]?[rowNo]
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        // cell.setValue(value: dict?["id"], forKey: "id")
        // 
        // cell.setValue(dict?["id"], forKey: "id")
        cell.imageView?.image = UIImage(named: (dict!["image"]!))
        // cell.imageView?.sizeThatFits(<#T##size: CGSize##CGSize#>)
        cell.textLabel?.text = dict!["label"]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        // cell.toolLabel.text = dict!["label"]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 10
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 5
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let footView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 5))
            footView.backgroundColor = UIColor.clear
            return footView
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selectedRow = self.tableView.cellForRow(at: indexPath)
        print("\(String(describing: selectedRow))")
        let row = indexPath.row
        if indexPath.section == 0 {
            // 执行计划
            let smsVC = storyBoard.instantiateViewController(withIdentifier: "SMSUIViewController")
            self.navigationController?.pushViewController(smsVC, animated: true)
        } else if indexPath.section == 1  && row == 0 {
            // 名片扫描
            self.aipVC = AipGeneralVC.viewController(with: self)
            self.present(aipVC!, animated: true, completion: nil)
        } else if indexPath.section == 1  && row == 1 {
            // 二维码分享
            let vc = storyBoard.instantiateViewController(withIdentifier: "qrScrollView")
            self.navigationController?.pushViewController(vc, animated: true) // (scanvc, sender: self)
            // self.present(vc, animated: true, completion: nil)
        } else {
            // 其他
            // NetworkUtils.requestNLPLexer("刘社定，湖南指尖科技有限公司，18619283902", successHandler: nil)
            // self.navigationController?.view.makeToast("正在研发中，敬请期待...", duration: 1.5, position: .bottom)
            
            let view = UIApplication.topViewController()?.view
            let hub = MBProgressHUD.showAdded(to: view!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "正在研发中，敬请期待..."
            // hub.offset = CGPoint(x: 0, y: MBProgressMaxOffset - 100)
            hub.show(animated: true)
            hub.hide(animated: true, afterDelay: 1.5)
        }
    }
    
    private func curIdx(sec: Int) -> Int {
        if sec == 0 {
            return 0
        }
        let len = self.toolCells.count
        var cur : Int = 0
        for i in 0 ... (len - 1) {
            cur += toolCells[i]!.count
        }
        return cur
    }
}


extension ToolsUIViewController: AipOcrDelegate {
    
    
    
    
    func ocr(onIdCardSuccessful result: Any!) {
        
    }
    
    func ocr(onBankCardSuccessful result: Any!) {
        
    }

    
    
    func ocr(onGeneralSuccessful resut: Any!) {
        print("\(resut)")
        let json = JSON(resut)
        var strWords: [String] = []
        let words = json["words_result"].arrayValue
        if words.count > 0 {
            let queue = OperationQueue.main
            queue.addOperation({
                let scanvc = self.storyBoard.instantiateViewController(withIdentifier: "ScanResultViewController") as! ScanResultViewController
                for w in words {
                    let str = w["words"].string
                    strWords.append(str!)
                }
                scanvc.words = strWords
                if self.aipVC != nil {
                    self.aipVC!.dismiss(animated: true, completion: {
                        [weak self] in
                        self?.navigationController?.pushViewController(scanvc, animated: true)
                    })
                
                }
            })
        }
    }

    
    func ocr(onFail error: Error!) {
        // self.navigationController?.view.makeToast("识别失败，请稍后再重试！")
    }
}
