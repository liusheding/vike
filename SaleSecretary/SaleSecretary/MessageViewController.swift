//
//  MessageViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageViewController: UITableViewController {
    var DataSource:NSMutableArray!
    let cellId = "MessageListID"
    let msgdb = MessageDB.defaultInstance()
    
    func initData(){
        let msglist = msgdb.getAllMsgList()
        var msgdata = [MessageData]()
        for msg in msglist{
            let phonenumber = getPhoneNumber(msg.msg_phone!)
            msgdata.append(MessageData(name:msg.msg_name!, phone:phonenumber,time:msg.msg_time! as Date,mtype:Int(msg.msg_type), message:[], unread:Int(msg.msg_unread)))
        }
        
        DataSource=NSMutableArray()
        DataSource.addObjects(from: msgdata)
        DataSource.sort(comparator: sortDate)
    
    }
    
    func getPhoneNumber(_ phone:String) -> String{
        let endindex = phone.index(phone.endIndex, offsetBy: -11)
        let phonenumber = phone.substring(to: endindex)
        return phonenumber
    }
    
    //根据新消息的手机号得到对应的cell
    func getmessagedata(_ message:String) -> MessageData?{
        let json = string2json(message)
        if json != nil{
            for data in self.DataSource as NSMutableArray{
                let msg = data as! MessageData
                let str = String(describing: json!["phone"])
                if msg.phone == str{
                    return msg
                }
            }
        }
        return nil
    }
    
    //消息列表按日期排序方法
    func sortDate(_ m1: Any, m2: Any) -> ComparisonResult {
        if((m1 as! MessageData).date.timeIntervalSince1970 < (m2 as! MessageData).date.timeIntervalSince1970)
        {
            return ComparisonResult.orderedDescending
        }
        else
        {
            return ComparisonResult.orderedAscending
        }
    }
    
    //显示小红点
    func showDotOnItemIndex(index:Int) {
        let tabBar = self.tabBarController?.tabBar
        let view = UIView()
        view.tag = 888
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.red
        let tabBarFrome = tabBar?.frame
        
        let percentX = (Double(index) + 1.25) / 5;
        let x = ceilf(Float( percentX) * Float((tabBarFrome?.size.width)!))
        let y = ceilf(0.01 * Float((tabBarFrome?.size.width)!))
        view.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(10), height: CGFloat(10))//圆形大小为10
        tabBar?.addSubview(view)
    }
    
    //移除小红点
    func removeBadgeOnItemIndex(index:Int) {
        let tabBar = self.tabBarController?.tabBar
        if let view = tabBar?.viewWithTag(888) {
            view.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.removeBadgeOnItemIndex(index: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showDotOnItemIndex(index: 2)
    }
    
    func string2json(_ str:String) -> JSON? {
        if let jsonData = str.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: jsonData)
            return json
        }
        return nil
    }
    
    override func viewDidLoad() {
        insertMsgList()
        insertMsgItem()
        
        initData()
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MessageListCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
    }
    
    func delectMsgList(){
        for data in self.DataSource{
            let d = data as! MessageData
            msgdb.deleteMsgList(msgdata: d)
        }
    }
    
    func delectMsgItem(){
        for data in self.DataSource{
            let d = data as! MessageData
            for dd in d.message{
                msgdb.deleteMsgItem(msgphone: dd.msgphone)
            }
        }
    }
    
    func insertMsgList(){
        let msglist = msgdb.getAllMsgList()
        if msglist != []{
            return
        }
        
        msgdb.insertMsgList(msgdata: MessageData(name:"指尖刘总", phone:"12345678901",time:Date(timeIntervalSinceNow:-60*60*24*2),mtype:1, message: [], unread:0))
        msgdb.insertMsgList(msgdata: MessageData(name:"指尖何总", phone:"12345678902",time:Date(timeIntervalSinceNow:-60*60*24),mtype:1, message: [], unread:0))
        msgdb.insertMsgList(msgdata: MessageData(name:"待执行计划", phone:"您有3个待执行计划",time:Date(timeIntervalSinceNow:-60*60*24*4),mtype:2, message: [], unread:0))
        msgdb.insertMsgList(msgdata: MessageData(name:"消息通知", phone:"您有1条消息通知",time:Date(timeIntervalSinceNow:-60*60*24*3),mtype:3, message: [], unread:0))
    }
    
    func insertMsg(msgdetail: MessageDetail){
        msgdb.insertMsgItem(msgdetail: msgdetail)
        let msglist = msgdb.getMsgList(msgphone: msgdetail.msgphone)
        let value = msglist[0].msg_unread
        msgdb.updateMsgList(msgphone: msgdetail.msgphone, key: "msg_unread", value: value + 1)
        
        if self.DataSource == nil{
            return
        }
        //旧列表中删除
        for data in self.DataSource as NSMutableArray{
            let msg = data as! MessageData
            if msg.phone == msgdetail.msgphone{
                self.DataSource.remove(msg)
                break
            }
        }
        
        //得到新的MessageData
        let msgdata = msgdb.getMsgList(msgphone: msgdetail.msgphone)
        
        //将新data插到第一行
        self.DataSource.insert(msgdata[0], at: 0)
        self.tableView.reloadData()
            
    }
    
    func insertMsgItem(){
        let msgitem = msgdb.getAllMsgItem()
        if msgitem != []{
            return
        }

        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:0),msgtype:2,msgcontent:"国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。", msgphone: "12345678901"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:1,msgcontent:"巴基斯坦《国际新闻》网站7日报道称，据可靠消息，中国政府就印军非法越界严正警告。", msgphone: "12345678901"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:0),msgtype:1,msgcontent:"国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。", msgphone: "12345678902"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:2,msgcontent:"巴基斯坦《国际新闻》网站7日报道称，据可靠消息，中国政府就印军非法越界严正警告。", msgphone: "12345678902"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:0),msgtype:3,msgcontent:"国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。", msgphone: "您有1条消息通知"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:3,msgcontent:"巴基斯坦《国际新闻》网站7日报道称，据可靠消息，中国政府就印军非法越界严正警告。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。", msgphone: "您有3个待执行计划"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:0),msgtype:3,msgcontent:"国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。", msgphone: "您有3个待执行计划"))
        
        insertMsg(msgdetail: MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:3,msgcontent:"巴基斯坦《国际新闻》网站7日报道称，据可靠消息，中国政府就印军非法越界严正警告。国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。", msgphone: "您有3个待执行计划"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.DataSource != nil{
            return self.DataSource.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageListCell
        let data = self.DataSource[indexPath.row] as! MessageData
        cell.cellname.text = data.name
        cell.cellphone.text = data.phone
        cell.celltime.text = data.time
        cell.mtype = data.mtype
        cell.setCellContnet(data.unread)
        
        if cell.mtype == 1{
            cell.cellimage.image = UIImage(named: "pic_xx_hf.png")
        }else if cell.mtype == 2{
            cell.cellimage.image = UIImage(named: "pic_xx_dzx.png")
        }else{
            cell.cellimage.image = UIImage(named: "pic_xx_tz.png")
        }
        
        return cell
    }
    
    //处理选中事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        self.hidesBottomBarWhenPushed = true
        let cell = self.tableView.cellForRow(at: indexPath) as! MessageListCell
        let data = self.DataSource[indexPath.row] as! MessageData
        data.unread = 0
        cell.setCellContnet(data.unread)
        msgdb.updateMsgList(msgphone: data.phone, key: "msg_unread", value: 0)
        
        let msgitem = msgdb.getMsgItem(msgphone: data.phone)
        var msgitems = [MessageDetail]()
        for item in msgitem{
            let phonenumber = getPhoneNumber(item.msg_item_phone!)
            msgitems.append(MessageDetail(msgtime:item.msg_item_time! as Date, msgtype:Int(item.msg_item_type), msgcontent:item.msg_item_content!, msgphone:phonenumber))
            }
        data.message = msgitems.sorted { (s1, s2) -> Bool in
            if(s1.msgdate.timeIntervalSince1970 < s2.msgdate.timeIntervalSince1970){return true}
            else{return false}
        }
        
        if (cell.mtype == 1){
            let controller = MessageChatController()
            controller.DataSource = data
            controller.chattitle = data.name
            self.navigationController?.pushViewController(controller, animated: true)
            self.hidesBottomBarWhenPushed = false
            return
        }
       
        let controller = MessageDetailController()
        controller.DataSource = data
        controller.chattitle = data.name
        self.navigationController?.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false
    
    }
    
    //返回编辑类型，滑动删除
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //修改删除按钮的文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //点击删除按钮的响应方法，处理删除的逻辑
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let data = self.DataSource[indexPath.row] as! MessageData
            self.DataSource.removeObject(at: indexPath.row)
            msgdb.deleteMsgItem(msgphone: data.phone)
            msgdb.deleteMsgList(msgdata: data)
            self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }

}
