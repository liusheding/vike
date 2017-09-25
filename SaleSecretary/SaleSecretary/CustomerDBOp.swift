//
//  CustomerDBOp.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/15.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CustomerDBOp : NSObject {
    
    let customerVar = ["birthday","company","gender","group_id","id","is_solar","nick_name","phone_number","user_name" , "app_userId","desc"]
    
    private static let instance = CustomerDBOp()
    
    var dbContact : [Customers] = []
    
    var dbGroup : [Group] = []
    
    var contacts2Group : [CustomerGroup] = []
    
    static func defaultInstance() -> CustomerDBOp {
        return self.instance
    }
    
    private override init(){
        
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // while flag is true , read data again
    func getContacts2Group(userId : String , _ flag: Bool = false) -> [CustomerGroup] {
        if ( self.contacts2Group.count == 0 ) || flag {
            self.contacts2Group.removeAll()
            let tmpGp = self.getGroupInDb(userId : userId , true)
            let tmp = self.getCustomerInDb(userId : userId , true)
            for gp in tmpGp {
                self.contacts2Group.append( CustomerGroup.init(customer: tmp , group: gp ))
            }
        }
        return self.contacts2Group
    }
    
    //
    func getCustomerInDb(userId : String , _ flag: Bool = false) -> [Customers] {
        if ( flag || self.dbContact.count == 0 ){
            self.dbContact = self.getCustomers(userId:  userId)
        }
        return self.dbContact
    }
    
    func getGroupInDb(userId : String , _ flag: Bool = false ) -> [Group] {
        if ( flag || self.dbGroup.count == 0 )  {
            self.dbGroup = self.getGroup(userId: APP_USER_ID!)
        }
        return self.dbGroup
    }
    
    // batch insert Customer 
    func insertCustomerArray(ctms : [Customer] , groupId : String) {
        if ctms.count > 0 {
            for c in ctms {
                insertCustomer(ctms: c , groupId: groupId )
            }
        }
    }
    
    func insertCustomer(ctms : Customer , groupId : String){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Customers", in: context)
        
        let cmt = NSManagedObject(entity: entity!, insertInto: context)
        cmt.setValue( ctms.birthday , forKey: self.customerVar[0] )
        cmt.setValue( ctms.company , forKey: self.customerVar[1] )
        cmt.setValue( ctms.gender , forKey: self.customerVar[2] )
        
        // 第一次 ， 从手机通讯录加载数据
        if ctms.group_id == ContactCommon.groupDefaultX {
            cmt.setValue( groupId , forKey: self.customerVar[3] )
        }else {
            cmt.setValue( ctms.group_id , forKey: self.customerVar[3] )
        }
        
        cmt.setValue( ctms.id , forKey: self.customerVar[4] )
        cmt.setValue( ctms.is_solar , forKey: self.customerVar[5] )
        cmt.setValue( ctms.nick_name , forKey: self.customerVar[6] )
//        cmt.setValue( ctms.phone_number?.joined(separator: ",") , forKey: self.customerVar[7] )
        cmt.setValue( (ctms.phone_number?.count)! > 0 ? ctms.phone_number?[0] : "", forKey: self.customerVar[7])
        cmt.setValue( ctms.name , forKey: self.customerVar[8] )
        cmt.setValue( APP_USER_ID! , forKey: self.customerVar[9] )
        cmt.setValue( ctms.desc , forKey: self.customerVar[10] )
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func insertCustomers(ctms : Customers)  {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Customers", in: context)
        
        let cmt = NSManagedObject(entity: entity!, insertInto: context)
        cmt.setValue( ctms.birthday , forKey: self.customerVar[0] )
        cmt.setValue( ctms.company , forKey: self.customerVar[1] )
        cmt.setValue( ctms.gender , forKey: self.customerVar[2] )
        cmt.setValue( ctms.group_id , forKey: self.customerVar[3] )
        cmt.setValue( ctms.id , forKey: self.customerVar[4] )
        cmt.setValue( ctms.is_solar , forKey: self.customerVar[5] )
        cmt.setValue( ctms.nick_name , forKey: self.customerVar[6] )
        cmt.setValue( ctms.phone_number , forKey: self.customerVar[7] )
        cmt.setValue( ctms.user_name , forKey: self.customerVar[8] )
        cmt.setValue( ctms.app_userId , forKey: self.customerVar[9])
        cmt.setValue( ctms.desc , forKey: self.customerVar[10])
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    // delete one by one
    func deleteCustomer(cust : Customer  , tag : String = ""){
        let context = getContext()
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        if tag.characters.count > 0 {
            fetchRequest.predicate = NSPredicate(format: " phone_number = %s and app_userId = %s ", argumentArray: [ ( cust.phone_number?.count)! > 0 ? (cust.phone_number?[0])! : "" , cust.app_userId])
        }else {
            fetchRequest.predicate = NSPredicate(format: "id = %s and app_userId = %s ", argumentArray: [ cust.id , cust.app_userId])
        }
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of delete \(searchResults.count)")
            
            for p in searchResults  {
                context.delete(p)
            }
            try! context.save()
        } catch  {
            NSLog(error as! String)
        }
    }
    
    func updateByPhoneForId(phone : String , id : String) {
        if phone.characters.count > 0 {
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "phone_number = %@  and app_userId = %s ", argumentArray: [ phone , APP_USER_ID!])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of update by phone for id \(searchResults.count)")
                if searchResults.count > 0 {
                    for sr in searchResults {
                        sr.id = id
                    }
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func updateByPhone(phone:String , g : MemGroup) {
        if phone.characters.count > 0 {
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "phone_number = %@  and app_userId = %s ", argumentArray: [ phone , APP_USER_ID!])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of update by phone \(searchResults.count)")
                if searchResults.count > 0 {
                    for sr in searchResults {
                        sr.group_id = g.id
                    }
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func updateCustomer(cust : Customer) {
        let context = getContext()
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.fetchOffset = 0 //查询的偏移量
        let phone = (cust.phone_number?.count)! > 0 ? cust.phone_number?[0] : ""
        
        fetchRequest.predicate = NSPredicate(format: "phone_number = %@  and app_userId = %s ", argumentArray: [ phone ?? "" , APP_USER_ID!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of update phone \(searchResults.count)")
            if searchResults.count > 0 {
                for sr in searchResults {
                    sr.birthday = cust.birthday
                    sr.user_name = cust.name
                    sr.nick_name = cust.nick_name
                    sr.desc = cust.desc
                    sr.company = cust.company
                    sr.phone_number = (cust.phone_number?.count)! > 0 ? cust.phone_number?[0] : ""
                    sr.id = cust.id
                    sr.group_id = cust.group_id
                }
            }
            try context.save()
        } catch  {
            NSLog(error as! String)
        }
    }
    
    func batchDeleteCustomer(cust : [Customer] , tag : String = "") {
        if cust.count > 0 {
            var ids : [String] = []
            if tag.characters.count > 0 {
                for c in cust {
                    ids.append((c.phone_number?.count)! > 0 ? (c.phone_number?[0])! : "" )
                }
            }else {
                for c in cust {
                    ids.append(c.id)
                }
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            if tag.characters.count > 0 {
                fetchRequest.predicate = NSPredicate(format: "app_userId = %s and phone_number in %s ", argumentArray: [ cust[0].app_userId, ids ])
            }else {
                fetchRequest.predicate = NSPredicate(format: "app_userId = %s and id in %s ", argumentArray: [ cust[0].app_userId, ids ])
            }
            
            do {
                let searchResults = try context.fetch(fetchRequest)
                
                for p in searchResults  {
                    context.delete(p)
                }
                try! context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func getCustomers(userId : String) -> [Customers]{
        var result : [Customers] = []
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.predicate = NSPredicate(format: "app_userId = %@", argumentArray: [userId])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            NSLog("numbers of \(searchResults.count)")
            
            for p in searchResults{
                result.append(p)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func queryByIdentifer(id : String) -> [Customers] {
        var result : [Customers] = []
        
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.predicate = NSPredicate(format: " phone_number = %s and app_userId = %s", argumentArray: [id , APP_USER_ID!])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            if searchResults.count > 0 {
                for p in searchResults {
                    result.append(p)
                }
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func updateById(id : String , newGroup : String)  {
        let context = getContext()
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "id = %@  and app_userId = %s ", argumentArray: [ id , APP_USER_ID!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of delete \(searchResults.count)")
            
            for p in searchResults  {
                p.group_id = newGroup
            }
            try context.save()
        } catch  {
            NSLog(error as! String)
        }
    }
    // 暂时按照手机来修改分组 ， 后续会做修改，为用户id
    func batchChangeCustomerGroup(cust : [Customer] , group : Group) {
        if cust.count > 0 {
            var ids : [String] = []
//            for c in cust {
//                ids.append(c.id)
//            }
            for c in cust {
                let phone = (c.phone_number?.count)! > 0 ? c.phone_number?[0] : ""
                if (phone?.characters.count)! > 0 {
                    ids.append( phone! )
                }
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
            fetchRequest.fetchOffset = 0 //查询的偏移量
            fetchRequest.predicate = NSPredicate(format: "phone_number in %@", argumentArray: [ ids ])
//            fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ ids ])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of remove \(searchResults.count)")
                
                for p in searchResults  {
                    p.group_id = group.id
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func changeCustomerGroup(group : [MemGroup] , defaultGroup : [MemGroup])  {
        if group.count > 0 {
            var strArray : [String]  = []
            
            for g in group {
                strArray.append(g.id)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "group_id in %@ and app_userId = %s ", argumentArray: [ strArray , APP_USER_ID! ])
            
            var defaultId = ""
            for d in defaultGroup {
                if d.group_name == ContactCommon.groupDefault as String {
                    defaultId = d.id
                    break
                }
            }
            
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of delete \(searchResults.count)")
                
                for p in searchResults  {
                    p.group_id = defaultId
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func storeGroup( id : String , group_name : String , userId : String){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue( id, forKey: "id")
        person.setValue( group_name, forKey: "group_name")
        person.setValue( userId , forKey: "app_userId")
        do {
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func storeGroupArray(userId : String , gArray : [MemGroup]) {
        if gArray.count > 0 {
            for g in gArray {
                self.storeGroup(id: g.id , group_name: g.group_name, userId: userId)
            }
        }
    }
    
    func deleteGroup(g:MemGroup)  {
        let context = getContext()
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        
        fetchRequest.predicate = NSPredicate(format: " id = %s and app_userId = %s", argumentArray: [g.id , APP_USER_ID!])
        do {
            let searchResults = try context.fetch(fetchRequest)
            NSLog("numbers of delete \(searchResults.count)")
            
            for p in searchResults  {
                context.delete(p)
            }
            
        } catch  {
            NSLog(error as! String)
        }
    }
    
    func deleteGroupArray(gArray : [MemGroup]) {
        if gArray.count > 0 {
            var strArray : [String] = []
            for g in gArray {
                strArray.append(g.id)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
            
            fetchRequest.predicate = NSPredicate(format: "id  in %@ and app_userId = %s ", argumentArray: [strArray , APP_USER_ID!])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of delete \(searchResults.count)")
                
                for p in searchResults  {
                    context.delete(p)
                }
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func  getGroup(userId : String ) -> [Group]{
        var result : [Group] = []
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        
        fetchRequest.predicate = NSPredicate(format: "app_userId = %@", argumentArray: [userId])
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            
            for p in searchResults {
                result.append(p )
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }

    
    func storeTrailInfo(trail : TrailMessage) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "TrailMsg", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue( trail.id , forKey: "id")
        person.setValue( trail.title , forKey: "title")
        person.setValue( trail.content, forKey: "content")
        person.setValue( trail.date , forKey: "date")
        person.setValue( trail.cusInfoId , forKey: "cusInfoId")
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
    }
    
    func queryTrailInfo(cusInfoId : String) -> [TrailMsg] {
        var result : [TrailMsg] = []
        let fetchRequest = NSFetchRequest<TrailMsg>(entityName: "TrailMsg")
        
        fetchRequest.predicate = NSPredicate(format: "cusInfoId = %@", argumentArray: [cusInfoId])
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            result = searchResults
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    
}
