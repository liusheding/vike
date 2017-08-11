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
    fileprivate var itemDataSouce = [Int]()
    
    func initData(){
        let first = MessageData(name:"指尖刘总", phone:"12345678901",time:Date(timeIntervalSinceNow:-60*60*24),mtype:1,message:[MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:.mine,msgcontent:"巴基斯坦《国际新闻》网站7日报道称，据可靠消息，中国政府就印军非法越界严正警告印度后，5日深夜到6日凌晨期间，印军在洞朗地区连夜撤离，只剩下少数人留守。报道称，这意味着印度军队终于向中国投降。"), MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:.someone,msgcontent:"对于印度边防部队非法越界，国防部8月3日深夜发布重磅声明，敦促印方立即将越界的边防部队撤回边界线印度一侧，尽快妥善解决此次事件，恢复两国边境地区的和平与安宁。")])
        
        let second = MessageData(name:"待执行计划", phone:"还有4个计划等待您执行",time:Date(timeIntervalSinceNow:-60*60*24*3),mtype:2,message:[MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*3),msgtype:.system,msgcontent:"韩国外交部相关人士7日对外披露，双方对于韩国政府的对朝提议交换了意见。这是韩国文在寅政府执政以来，朝韩高级别官员的第一次会面。对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道"), MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*3),msgtype:.system,msgcontent:"对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道。"),MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*3),msgtype:.system,msgcontent:"对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道。对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道"),MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*3),msgtype:.system,msgcontent:"对于朝韩外长马尼拉会面，中国外交部长王毅在7日上午表示，中国支持双方展开对话，恢复接触、进行对话是沟通的渠道。")])
        
        let third = MessageData(name:"指尖何总", phone:"12345678902",time:Date(timeIntervalSinceNow:-60*60*24*5),mtype:1,message:[MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*5),msgtype:.someone,msgcontent:"国防部声明指出，中印边境对峙事件发生以来，中国本着最大善意，努力通过外交渠道解决当前事态。中国军队从维护两国关系大局和地区和平稳定出发，始终保持高度克制。但善意不是没有原则，克制不是没有底线。"), MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*5),msgtype:.mine,msgcontent:"印方要打消任何以拖待变的幻想。任何国家都不应低估中国军队履行保卫和平之责的信心和能力，都不应低估中国军队维护国家主权、安全、发展利益的决心和意志。")])
        
        let fouth = MessageData(name:"消息通知", phone:"您有1条通知消息等待查看",time:Date(timeIntervalSinceNow:-60*60*24*2),mtype:3,message:[MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24*2),msgtype:.system,msgcontent:"据韩联社报道，昨天（6日）晚上，朝韩外长在马尼拉参加菲律宾外长举行的欢迎晚宴时见面，双方握手后进行了简短的对话。")])
        
        DataSource=NSMutableArray()
        DataSource.addObjects(from: [first,second,third,fouth])
        DataSource.sort(comparator: sortDate)
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
    
    //更新消息列表
    func updateMessageList() {
        //更新缓存
        let message = "{\"name\": \"hangge\",\"phone\":\"12345678901\",\"time\":\"\(Date(timeIntervalSinceNow:-60*60*24))\"}"
        
        let data = getmessagedata(message)
        
        let cache = MessageCache()
        cache.writeLocalCacheData(data: message, withKey: "12345678901")
        
        //读取缓存
        let nsdata = cache.readLocalCacheDataWithKey(key:"12345678901")
        print("读文件\(nsdata!))")
        
        //从列表中删除
        if data != nil && DataSource.contains(data!){
            DataSource.remove(data!)
        }
        
        //构造新的MessageData
        let new = MessageData(name:"指尖刘总", phone:"12345678901",time:Date(timeIntervalSinceNow:-60*60*24),mtype:1,message:[MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:.mine,msgcontent:"刘总你好"), MessageDetail(msgtime:Date(timeIntervalSinceNow:-60*60*24),msgtype:.someone,msgcontent:"你好")])
        
        //将新data插到第一行
        DataSource.insert(new, at: 0)
    }
    
    //按日期排序方法
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
        initData()
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MessageListCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        self.itemDataSouce = [100,1,4,0]
//        self.tableView.register(MessageListCell.self, forCellReuseIdentifier: "MessageListID")
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
        cell.setCellContnet(self.itemDataSouce[indexPath.row])

        let data = self.DataSource[indexPath.row] as! MessageData
        cell.cellname.text = data.name
        cell.cellphone.text = data.phone
        cell.celltime.text = data.time
        cell.mtype = data.mtype
        
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
        
//        let message = "{\"name\": \"hangge\",\"phone\":\"12345678901\",\"time\":\"\(Date(timeIntervalSinceNow:-60*60*24))\"}"
//        
//        //写文件
//        let json = string2json(message)
//        if json != nil{
//            let keystr = String(describing: json!["phone"])
//            let cache = MessageCache()
//            cache.writeLocalCacheData(data: message, withKey: keystr)
//            }
//        
//        //读文件
//        let cache = MessageCache()
//        let readdata = cache.readLocalCacheDataWithKey(key:"12345678901")
//        let index = readdata?.index((readdata?.endIndex)!, offsetBy: -3)
//        let subdata = readdata?.substring(to: index!)
//        let array = subdata?.components(separatedBy: "|&|") as! NSMutableArray
//        print("读文件\(subdata!)")
//        if array.count > 0{
//            let jsdata = string2json(array[0] as! String)
//            if jsdata != nil{
//                let name = String(describing: jsdata!["name"])
//                print("得到数组\(name)")
//            }
//        }
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
            self.DataSource.remove(at: indexPath.row)
            self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            //删除聊天缓存文件
            let cache = MessageCache()
            cache.deleteLocalCacheDataWithKey(key:"12345678901")
        }

    }

}
