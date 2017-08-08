//
//  MessageInfo.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageData {
    //用户名字
    var name:String
    //用户电话/提示内容
    var phone:String
    //消息时间
    var date:Date
    var time:String
    //消息类型 1-对话 2-待执行 3-通知
    var mtype:Int
    //消息内容
    var message:NSMutableArray!
    
    init(name:String, phone:String, time:Date, mtype:Int, message:NSMutableArray) {
        self.name = name
        self.phone = phone
        self.mtype = mtype
        self.date = time
        self.message = message
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        self.time = dateFormatter.string(from: time)
    }
}

class MessageDetail {
    //消息时间
    var msgdate:Date
    var msgtime:String
    //消息类型 1-自己 2-对方
    var msgtype:ChatType
    //消息内容
    var msgcontent:String
    
    init(msgtime:Date, msgtype:ChatType, msgcontent:String) {
        self.msgtype = msgtype
        self.msgdate = msgtime
        self.msgcontent = msgcontent
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        self.msgtime = dateFormatter.string(from: msgtime)
    }
}
