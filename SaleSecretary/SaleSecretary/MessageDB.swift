//
//  MessageDB.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/18.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import CoreData

class MessageDB: NSObject {
    
    private static let instance = MessageDB()
    
    static func defaultInstance() -> MessageDB {
        return self.instance
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //MsgList增
    func insertMsgList(msgdata: MessageData) {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "MsgList", in: context)
        let message = NSManagedObject(entity: entity!, insertInto: context)
        
        message.setValue(msgdata.name, forKey: "msg_name")
        message.setValue(msgdata.phone, forKey: "msg_phone")
        message.setValue(msgdata.date, forKey: "msg_time")
        message.setValue(msgdata.mtype, forKey: "msg_type")
        
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
    }
    
    //MsgList删
    func deleteMsgList(msgdata: MessageData){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgList>(entityName: "MsgList")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        print("<<<<<<<\(msgdata.phone)")
        fetchRequest.predicate = NSPredicate(format: "msg_phone = %s", argumentArray: [msgdata.phone])
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of delete \(searchResults)")
            
            for p in searchResults  {
                print(">>>>>>>>\(p)")
                context.delete(p)
            }
        } catch  {
            print("11111111")
            NSLog(error as! String)
        }
        
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
        
    }
    
    //MsgList查
    func getMsgList() -> [MsgList]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgList")
        var result : [MsgList] = []
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            NSLog("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgList)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    //MsgItem增
    func insertMsgItem(msgdetail: MessageDetail) {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "MsgItem", in: context)
        let message = NSManagedObject(entity: entity!, insertInto: context)
        
        message.setValue(msgdetail.msgdate, forKey: "msg_item_time")
        message.setValue(msgdetail.msgphone, forKey: "msg_item_phone")
        message.setValue(msgdetail.msgcontent, forKey: "msg_item_content")
        message.setValue(msgdetail.msgtype, forKey: "msg_item_type")
        
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
    }
    
    //MsgItem删
    func deleteMsgItem(msgdetail: MessageDetail){
        let context = getContext()
        let fetchRequest = NSFetchRequest<MsgItem>(entityName: "MsgItem")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_item_phone=%s", argumentArray: [msgdetail.msgphone])
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of deleteMsgItem \(searchResults.count)")
            
            for p in searchResults  {
                context.delete(p)
            }
        } catch  {
            NSLog(error as! String)
        }
        
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
    }
    
    //MsgItem查
    func getMsgItem(msgphone: String) -> [MsgItem]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MsgItem")
        var result : [MsgItem] = []
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "msg_item_phone=%s", argumentArray: [msgphone])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            NSLog("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! MsgItem)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
}
