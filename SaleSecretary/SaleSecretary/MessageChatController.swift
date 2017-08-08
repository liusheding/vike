//
//  MessageChatController.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/7/27.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MessageChatController: UIViewController,ChatDataSource,UITextFieldDelegate {
    
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextField!
    
    var keyBaordView:UIView!
    var KeyBoardHeight:CGFloat!
    var DataSource:MessageData!
    var chattitle: String!
    
    override func viewDidLoad() {
        self.navigationItem.title = chattitle
        super.viewDidLoad()
        
        setupChatTable()
        setupSendPanel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        //注册点击事件
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            txtMsg.resignFirstResponder()
        }
        sender.cancelsTouchesInView = true
    }
    
    func setupSendPanel()
    {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        
        sendView.backgroundColor=UIColor.groupTableViewBackground
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor = UIColor(red: 0x15/255, green: 0x7d/255, blue: 0xf9/255, alpha: 1)
        sendButton.addTarget(self, action:#selector(self.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius = 6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
        
        keyBaordView = sendView
    }
    
    //移除监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //键盘的出现
    func keyboardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的高度
        let kbHeight = kbRect.size.height
        KeyBoardHeight = kbHeight
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76 - kbHeight)
            self.keyBaordView.frame = CGRect(x:0, y:kbRect.origin.y - 56, width:SCREEN_WIDTH,  height:56)
            self.scrollToRow()
        }
    }
    //键盘的隐藏
    func keyboardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76)
            self.keyBaordView.frame = CGRect(x:0, y:changeY - 56, width:SCREEN_WIDTH, height:56)
            self.scrollToRow()
        }
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    func sendMessage()
    {
        //composing=false
        let sender = txtMsg
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
        let thatChat =  MessageItem(body:"你说的是：\(sender!.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
        
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        scrollToRow()
        sender?.text = ""
        
    }
    
    func scrollToRow()  {
        self.tableView.reloadData()
        
        if self.Chats == nil{
            return
        }
        
        let vHeight = self.tableView.frame.height
        
        var num = self.Chats.count
        var chatHeight:CGFloat = 0
        while (num > 0) {
            let item = self.Chats[num - 1] as! MessageItem
            chatHeight += item.view.frame.height
            num -= 1
        }
        
        if vHeight == SCREEN_HEIGHT - 76 || vHeight > chatHeight{
            return
        }
        
        if self.Chats.count > 0 {
            let offset = CGPoint(x:0, y:self.tableView!.contentSize.height
                - self.tableView!.bounds.size.height)
            self.tableView!.setContentOffset(offset, animated: true)
        }
    }
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 76), style: .plain)
        
        //创建一个重用的单元格
        self.tableView!.register(ChatViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"" ,logo:("xiaoming.png"))
        you  = UserInfo(name:"", logo:("xiaohua.png"))
        
        Chats = NSMutableArray()
        let message = self.DataSource.message
        var array: [MessageItem] = []
        for msgdetail in message! as NSMutableArray {
            let msg = msgdetail as! MessageDetail
            array.append(MessageItem(body:msg.msgcontent as NSString, user:me,  date:msg.msgdate, mtype:msg.msgtype))
        }
        Chats.addObjects(from: array)
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        if self.Chats != nil{
            return self.Chats.count
        }
        return 0
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
