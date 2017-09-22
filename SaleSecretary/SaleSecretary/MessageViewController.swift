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
    let notifyPhone = "100001" //消息通知预设的电话号码
    var emptyView: EmptyContentView?
    
    static var instance: MessageViewController?
    
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
        
        emptyView?.dismiss()
        if DataSource.count == 0{
            let frame = self.tableView.frame
            emptyView = EmptyContentView.init(frame: frame)
            emptyView?.textLabel.text = "暂无任何消息通知～"
            emptyView?.textLabel.numberOfLines = 2
            emptyView?.showInView(self.view)
        }
        self.tableView.reloadData()
    }
    
    func getPhoneNumber(_ phone:String) -> String{
        let endindex = phone.index(phone.endIndex, offsetBy: -11)
        let phonenumber = phone.substring(to: endindex)
        return phonenumber
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
    
    func RefreshCell(_ msgphone: String){
        let cell = self.tableView.cellForRow(at: [0, 0]) //目前只有1个section 1个row 先用此方法处理
        if cell == nil || AppUser.currentUser == nil {
            return
        }
        let msgcell = cell as! MessageListCell
        let msglist = msgdb.getMsgList(msgphone: msgphone)
        if msglist.count == 0{
            msgcell.setCellContnet(1)
            msgcell.cellphone.text = "您有1条新消息通知"
        }else{
            let value = msglist[0].msg_unread
            msgcell.setCellContnet(Int(value))
            msgcell.cellphone.text = "您有\(value)条新消息通知"
        }
        let time = Date()
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        msgcell.celltime.text = dateFormatter.string(from: time)
    }
    
    func showDotOnItem(){
        let msglist = msgdb.getAllMsgList()
        for msg in msglist{
            if msg.msg_unread > 0{
                self.removeBadgeOnItemIndex(index: 2)
                self.showDotOnItemIndex(index: 2)
                return
            }
        }
        self.removeBadgeOnItemIndex(index: 2)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageViewController.instance = self
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MessageListCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initData()
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
    
    func insertMsg(msgdetail: MessageDetail){
        msgdb.insertMsgItem(msgdetail: msgdetail)
        let msglist = msgdb.getMsgList(msgphone: msgdetail.msgphone)
//        if msglist.count == 0{
//            let msgdata = MessageData(name: <#String#>, phone: <#String#>, time: <#Date#>, mtype: Int, message: [msgdetail,], unread: 1)
//            msgdb.insertMsgList(msgdata: msgdata)
//            //将新data插到第一行
//            self.DataSource.insert(msgdata, at: 0)
//            self.tableView.reloadData()
//            self.removeBadgeOnItemIndex(index: 2)
//            self.showDotOnItemIndex(index: 2)
//            return
//        }
        let value = msglist[0].msg_unread
        msgdb.updateMsgList(msgphone: msgdetail.msgphone, key: "msg_unread", value: value + 1)
       
        self.removeBadgeOnItemIndex(index: 2)
        self.showDotOnItemIndex(index: 2)
        
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
        if data.phone == notifyPhone{
            if data.unread == 0{
                cell.cellphone.text = "暂无新的消息通知"
            }else{
                cell.cellphone.text = "您有\(data.unread)条新消息通知"
            }
        }
        cell.celltime.text = data.time
        cell.mtype = data.mtype
        cell.setCellContnet(data.unread)
        
        if cell.mtype == 3{
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
        
        var flag = false
        
        for data in self.DataSource {
            let d = data as! MessageData
            if d.unread > 0{
                flag = true
                break
            }
        }
        
        if flag == false{
            self.removeBadgeOnItemIndex(index: 2)
        }
        
        if data.phone == notifyPhone{
            cell.cellphone.text = "暂无新的消息通知"
        }
        
        let msgitem = msgdb.getMsgItem(msgphone: data.phone)
        var msgitems = [MessageDetail]()
        for item in msgitem{
            let phonenumber = getPhoneNumber(item.msg_item_phone!)
            msgitems.append(MessageDetail(msgtime:item.msg_item_time! as Date, msgtype:Int(item.msg_item_type), msgcontent:item.msg_item_content!, msgphone:phonenumber, msgtitle:item.msg_item_title!))
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
        
        self.showDotOnItem()
        emptyView?.dismiss()
        if DataSource.count == 0{
            let frame = self.tableView.frame
            emptyView = EmptyContentView.init(frame: frame)
            emptyView?.textLabel.text = "暂无任何消息通知～"
            emptyView?.textLabel.numberOfLines = 2
            emptyView?.showInView(self.view)
        }
    }

}
