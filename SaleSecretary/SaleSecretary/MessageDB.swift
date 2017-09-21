//
//  MessageDB.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/18.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import CoreData

enum JPNotificationType {
    case APNS;
    case CUSTOM;
}

class MessageDB: NSObject {
    
    public static let instance = MessageDB()
    
    public static func defaultInstance() -> MessageDB {
        return self.instance
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func insertMsgList(msgdata: MessageData) {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "MsgList", in: context)
        let message = NSManagedObject(entity: entity!, insertInto: context)
        if AppUser.currentUser == nil {
            return 
        }
        
        message.setValue(AppUser.currentUser?.cellphoneNumber, forKey: "msg_owner")
        message.setValue(msgdata.name, forKey: "msg_name")
        message.setValue(msgdata.phone + (AppUser.currentUser?.cellphoneNumber)!, forKey: "msg_phone")
        message.setValue(msgdata.date, forKey: "msg_time")
        message.setValue(msgdata.mtype, forKey: "msg_type")
        
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteMsgList(msgdata: MessageData){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgList>(entityName: "MsgList")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_phone = %s", argumentArray: [msgdata.phone+(AppUser.currentUser?.cellphoneNumber)!])
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            for p in searchResults  {
                context.delete(p)
            }
        } catch  {
            NSLog(error as! String)
        }
        
        do {
            try context.save()
        }catch{
            print(error)
        }
        
    }
    
    func updateMsgList(msgphone: String, key:String, value:Any){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgList>(entityName: "MsgList")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        fetchRequest.predicate = NSPredicate(format: "msg_phone=%s", argumentArray: [msgphone+(AppUser.currentUser?.cellphoneNumber)!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            for p in searchResults  {
                p.setValue(value, forKey: key)
            }
        } catch  {
            NSLog(error as! String)
        }
        
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getMsgList(msgphone: String) -> [MsgList]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgList")
        var result : [MsgList] = []
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_phone=%s", argumentArray: [msgphone+(AppUser.currentUser?.cellphoneNumber)!])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgList)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func getAllMsgList() -> [MsgList]{
        if AppUser.currentUser == nil {
            return []
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgList")
        var result : [MsgList] = []
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        fetchRequest.predicate = NSPredicate(format: "msg_owner=%s", argumentArray: [AppUser.currentUser?.cellphoneNumber])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgList)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func insertMsgItem(msgdetail: MessageDetail) {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "MsgItem", in: context)
        let message = NSManagedObject(entity: entity!, insertInto: context)
        
        message.setValue(msgdetail.msgdate, forKey: "msg_item_time")
        message.setValue(msgdetail.msgphone + (AppUser.currentUser?.cellphoneNumber)!, forKey: "msg_item_phone")
        message.setValue(msgdetail.msgcontent, forKey: "msg_item_content")
        message.setValue(msgdetail.msgtype, forKey: "msg_item_type")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteMsgItem(msgphone: String){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgItem>(entityName: "MsgItem")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_item_phone=%s", argumentArray: [msgphone+(AppUser.currentUser?.cellphoneNumber)!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            for p in searchResults  {
                context.delete(p)
            }
        } catch  {
            NSLog(error as! String)
        }
        
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateMsgItem(msgphone: String, key:String, value:Any){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgItem>(entityName: "MsgItem")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        fetchRequest.predicate = NSPredicate(format: "msg_item_phone=%s", argumentArray: [msgphone+(AppUser.currentUser?.cellphoneNumber)!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            for p in searchResults  {
                p.setValue(value, forKey: key)
            }
        } catch  {
            NSLog(error as! String)
        }
        
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func getMsgItem(msgphone: String) -> [MsgItem]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgItem")
        var result : [MsgItem] = []
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_item_phone=%s", argumentArray: [msgphone+(AppUser.currentUser?.cellphoneNumber)!])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgItem)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func getAllMsgItem() -> [MsgItem]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgItem")
        var result : [MsgItem] = []
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgItem)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func addSystemMessege(_ msg: MessageDetail) {
        self.insertMsgItem(msgdetail: msg)
        let msglist = self.getMsgList(msgphone:  msg.msgphone)
        if msglist.count == 0 {
            let msgdata = MessageData(name: "系统通知", phone: msg.msgphone, time: Date(), mtype: 3, message: [msg], unread: 1)
            self.insertMsgList(msgdata: msgdata)
        } else {
            let m = msglist[0].msg_unread >= 0 ? msglist[0].msg_unread : 0
            self.updateMsgList(msgphone: msg.msgphone, key: "msg_unread", value: m + 1)
        }
        MessageViewController.instance?.showDotOnItem()
    }
    
    
    // 处理极光推送消息
    func handlerNotification(userinfo: [AnyHashable : Any]?, type: JPNotificationType) {
        if  userinfo == nil || userinfo?.count == 0 { return }
        let info = userinfo!
        let k = AnyHashable("title")
        let exists = info.contains { $0.key == k}
        if exists {
            print(info[k])
        }
    }
}
