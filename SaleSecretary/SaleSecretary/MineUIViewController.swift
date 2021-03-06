//
//  MineUIViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class MineUIViewController: UITableViewController {
    let labelCellId = "mineListID"
    let mineInfoID = "mineinfoID"
    
    var identifiers = [1:["onlinepayID"], 2:["userManageID"], 3:["walletView"], 4:["businessRecord"], 5:["setViewID", "helpViewID"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MineViewCell.self), bundle: nil), forCellReuseIdentifier: labelCellId)
        self.tableView.register(UINib(nibName: String(describing: MineInfoCell.self), bundle: nil), forCellReuseIdentifier: mineInfoID)
        
        if AppUser.currentUser?.role == .KH{
            self.mineCells = [
                0: [["label": "", "image": "", "id":""]],
                1: [["label": "短信充值", "image": "icon_w_dx", "id":"dx"]],
                2: [["label": "钱包", "image": "icon_w_qb", "id":"qb"]],
                3: [["label": "短信发送统计", "image": "icon_w_dxtj", "id":"dxtj"]],
                4: [["label": "设置", "image": "icon_w_sz", "id":"sz"], ["label": "帮助", "image": "icon_w_bz", "id":"bz"]],
            ]
            
            self.identifiers = [1:["onlinepayID"], 2:["walletView"], 3:["businessRecord"], 4:["setViewID", "helpViewID"]]
            
            if WXApi.isWXAppInstalled() == false || AppUser.currentUser?.cellphoneNumber == "13888888888"{
                self.mineCells = [
                    0: [["label": "", "image": "", "id":""]],
                    1: [["label": "短信发送统计", "image": "icon_w_dxtj", "id":"dxtj"]],
                    2: [["label": "设置", "image": "icon_w_sz", "id":"sz"], ["label": "帮助", "image": "icon_w_bz", "id":"bz"]],
                ]
                
                self.identifiers = [1:["businessRecord"], 2:["setViewID", "helpViewID"]]
            }
            
        }
        else{
            if WXApi.isWXAppInstalled() == false || AppUser.currentUser?.cellphoneNumber == "13888888888"{
                self.mineCells = [
                    0: [["label": "", "image": "", "id":""]],
                    1: [["label": "用户管理", "image": "icon_w_yhgl", "id":"yhgl"]],
                    2: [["label": "短信发送统计", "image": "icon_w_dxtj", "id":"dxtj"]],
                    3: [["label": "设置", "image": "icon_w_sz", "id":"sz"], ["label": "帮助", "image": "icon_w_bz", "id":"bz"]],
                ]
                self.identifiers = [1:["userManageID"], 2:["businessRecord"], 3:["setViewID", "helpViewID"]]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(130)
        }
        return CGFloat(50)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.mineCells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mineCells[section]?.count)!
    }
    
    private var mineCells = [
        0: [["label": "", "image": "", "id":""]],
        1: [["label": "短信充值", "image": "icon_w_dx", "id":"dx"]],
        2: [["label": "用户管理", "image": "icon_w_yhgl", "id":"yhgl"]],
        3: [["label": "钱包", "image": "icon_w_qb", "id":"qb"]],
        4: [["label": "短信发送统计", "image": "icon_w_dxtj", "id":"dxtj"]],
        5: [["label": "设置", "image": "icon_w_sz", "id":"sz"], ["label": "帮助", "image": "icon_w_bz", "id":"bz"]],
    ]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: mineInfoID, for: indexPath) as! MineInfoCell
            let user = AppUser.currentUser
            cell.name.text = user?.name == "" ? "未知姓名" :  user?.name
            cell.phone.text = user?.cellphoneNumber
            cell.job.text = user?.role?.rawValue
            cell.invitecode.text = user?.referralCode
            cell.inviteBtn.addTarget(self, action: #selector(clickInviteBtn), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        let secNum = indexPath.section
        let rowNo = indexPath.row
        let dict = self.mineCells[secNum]?[rowNo]
        let cell = tableView.dequeueReusableCell(withIdentifier: labelCellId, for: indexPath) as! MineViewCell
        cell.mineImage.image = UIImage(named: (dict!["image"]!))
        cell.mineName.text = dict!["label"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 10
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let identifier = self.identifiers[indexPath.section]?[indexPath.row]
        let walletVC = storyBoard.instantiateViewController(withIdentifier: identifier!)
        self.navigationController?.pushViewController(walletVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var vHeight = 10
        if section == 0{
            vHeight = 5
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: vHeight))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func clickInviteBtn(){
        let shareView = ShareView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        shareView.delegate = self
        shareView.showInViewController(self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loading()
    }
    
    func loading(){
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["busi_scene":"USER_INFO", "id": APP_USER_ID]
            let request = NetworkUtils.postBackEnd("R_BASE_USER", body: body) {
                json in
                let jsondata = json["body"]
                let cell = self.tableView.cellForRow(at: [0,0]) as! MineInfoCell
                cell.name.text = jsondata["name"].stringValue
                
                if WXApi.isWXAppInstalled() == true && AppUser.currentUser?.cellphoneNumber != "13888888888"{
                    let smscell = self.tableView.cellForRow(at: [1,0]) as! MineViewCell
                    smscell.mineinfo.isHidden = false
                    let messageSyts = jsondata["messageSyts"].stringValue
                    let messageDjts = jsondata["messageDjts"].stringValue
                    let messageKyts = Int(messageSyts)! - Int(messageDjts)!
                    smscell.mineinfo.text = "剩余\(messageKyts)条"
                }
            }
            request.response(completionHandler: { _ in
            })
        }
    }
    
}

extension MineUIViewController: ShareViewDelegate {
    
    func sendLinkContent(inScene: WXScene) {
        let message = WXMediaMessage()
        message.title = "销小秘"
        message.description = "握在手心里的小秘 带你走上人生巅峰"
        message.setThumbImage(UIImage(named:"logo_xxm"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = "http://xm.zj.vc/download"
        message.mediaObject = ext
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(inScene.rawValue)
        WXApi.send(req)
    }
}
