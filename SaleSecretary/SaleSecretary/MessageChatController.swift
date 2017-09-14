//
//  MessageChatController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/7/27.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MessageChatController: UIViewController,ChatDataSource,UITextViewDelegate {
    
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextView!
    
    var keyBaordView:UIView!
    var KeyBoardHeight:CGFloat!
    var DataSource:MessageData!
    var chattitle: String!
    var isShowBoard:Bool = false
    var keyBoardRect:CGRect!
    var sendBtn:UIButton!
    
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
    
    func textChanged(_ notification: Notification){
        let txtheight = txtMsg.contentSize.height
        if txtheight <= txtMsg.bounds.height{
            return
        }
        
        changeviewsize()
        scrollToRow()
        print("\(txtMsg.bounds.height)")
    }
    
    func changeviewsize(){
        let txtheight = txtMsg.contentSize.height
        let screenWidth = UIScreen.main.bounds.width
        let offset = txtheight - txtMsg.bounds.height
        
        keyBaordView.frame = CGRect(x: 0,y: keyBaordView.frame.origin.y - offset,width: screenWidth,height: keyBaordView.frame.height + offset)
        txtMsg.frame = CGRect(x: 7,y: 10,width: screenWidth - 95,height: txtheight)
        self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:self.tableView.frame.height - offset)
        sendBtn.frame = CGRect(x: screenWidth - 80,y: sendBtn.frame.origin.y + offset,width: 72,height: 36)
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
        
        txtMsg = UITextView(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.systemFont(ofSize: 15)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor = UIColor(red: 0x21/255, green: 0xcd/255, blue: 0x68/255, alpha: 1)
        sendButton.addTarget(self, action:#selector(self.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius = 6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
        
        sendBtn = sendButton
        keyBaordView = sendView
        
        if self.tableView.frame.height < self.tableView.viewHeight && self.Chats.count > 0{
            let offset = CGPoint(x:0, y:self.tableView!.contentSize.height
                - self.tableView!.bounds.size.height + 76)
            self.tableView!.setContentOffset(offset, animated: true)
            
        }
        
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
        keyBoardRect = kbRect
        //键盘的高度
        let kbHeight = kbRect.size.height
        KeyBoardHeight = kbHeight
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76 - kbHeight)
            self.keyBaordView.frame = CGRect(x:0, y:kbRect.origin.y - 56, width:SCREEN_WIDTH,  height:56)
            self.txtMsg.frame = CGRect(x: 7,y: 10,width: SCREEN_WIDTH - 95,height: 36)
            self.sendBtn.frame = CGRect(x: SCREEN_WIDTH - 80,y: 10,width: 72,height: 36)
            
            let txtheight = self.txtMsg.contentSize.height
            if txtheight > 36{
                self.changeviewsize()
            }
            self.scrollToRow()
        }
        self.isShowBoard = true
    }
    //键盘的隐藏
    func keyboardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyBoardRect = kbRect
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76)
            self.keyBaordView.frame = CGRect(x:0, y:changeY - 56, width:SCREEN_WIDTH, height:56)
            self.txtMsg.frame = CGRect(x: 7,y: 10,width: SCREEN_WIDTH - 95,height: 36)
            self.sendBtn.frame = CGRect(x: SCREEN_WIDTH - 80,y: 10,width: 72,height: 36)
            
            let txtheight = self.txtMsg.contentSize.height
            if txtheight > 36{
                self.changeviewsize()
            }
            self.scrollToRow()
        }
        self.isShowBoard=false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{ // 输入换行符时发送
            sendMessage()
            return false
        }
        
        changeviewsize()
        scrollToRow()
        return true
    }
    
    func sendMessage()
    {
        let sender = txtMsg
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:MINE_TYPE)
        let thatChat =  MessageItem(body:"你说的是：\(sender!.text!)" as NSString, user:you, date:Date(), mtype:OTHER_TYPE)
        
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        if self.isShowBoard{
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76 - KeyBoardHeight)
        }
        else{
            self.tableView.frame = CGRect(x:0 , y:20 , width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 76)
            }
        if self.keyBaordView != nil && keyBoardRect != nil{
            self.keyBaordView.frame = CGRect(x:0, y:keyBoardRect.origin.y - 56, width:SCREEN_WIDTH,  height:56)
        }
        self.sendBtn.frame = CGRect(x: SCREEN_WIDTH - 80,y: 10,width: 72,height: 36)
        self.txtMsg.frame = CGRect(x: 7,y: 10,width: SCREEN_WIDTH - 95,height: 36)
        scrollToRow()
        sender?.text = ""
        
    }
    
    func scrollToRow()  {
        self.tableView.reloadData()
        
        if self.Chats == nil{
            return
        }
        
        let vHeight = self.tableView.frame.height
        if vHeight == SCREEN_HEIGHT - 76 || vHeight > self.tableView.viewHeight{
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
        me = UserInfo(name:"" ,logo:(""))
        you  = UserInfo(name:"", logo:(""))
        
        Chats = NSMutableArray()
        let message = self.DataSource.message
        var array: [MessageItem] = []
        for msgdetail in message as! NSMutableArray {
            let msg = msgdetail as! MessageDetail
            array.append(MessageItem(body:msg.msgcontent as NSString, user:me,  date:msg.msgdate, mtype:msg.msgtype))
        }
        Chats.addObjects(from: array)
        self.tableView.chatDataSource = self
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
