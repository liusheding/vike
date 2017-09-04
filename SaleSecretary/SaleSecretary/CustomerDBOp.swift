//
//  CustomerDBOp.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/15.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import CoreData

class CustomerDBOp : NSObject {
    
    let customerVar = ["birthday","company","gender","group_id","id","is_solar","nick_name","phone_number","user_name"]
    
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
    func getContacts2Group(_ flag: Bool = false) -> [CustomerGroup] {
        if ( self.contacts2Group.count == 0 ) || flag {
            self.contacts2Group.removeAll()
            let tmpGp = self.getGroupInDb(true)
            let tmp = self.getCustomerInDb(true)
            for gp in tmpGp {
                self.contacts2Group.append( CustomerGroup.init(customer: tmp , group: gp ))
            }
        }
        return self.contacts2Group
    }
    
    //
    func getCustomerInDb(_ flag: Bool = false) -> [Customers] {
        if ( flag || self.dbContact.count == 0 ){
            self.dbContact = self.getCustomers()
        }
        return self.dbContact
    }
    
    func getGroupInDb( _ flag: Bool = false ) -> [Group] {
        if ( flag || self.dbGroup.count == 0 )  {
            self.dbGroup = self.getGroup()
            if self.dbGroup.count == 0 {
                self.storeGroup(id: 0, group_name: ContactCommon.groupDefault as String )
            }
        }
        return self.dbGroup
    }
    
    // batch insert Customer 
    func insertCustomerArray(ctms : [Customer]) {
        if ctms.count > 0 {
            for c in ctms {
                insertCustomer(ctms: c)
            }
        }
    }
    
    func insertCustomer(ctms : Customer){
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
        cmt.setValue( ctms.phone_number?.joined(separator: ",") , forKey: self.customerVar[7] )
        cmt.setValue( ctms.name , forKey: self.customerVar[8] )
        
        do {
            try context.save()
            print("saved")
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
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    // delete one by one
    func deleteCustomer(cust : Customer){
        let context = getContext()
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "id = %s ", argumentArray: [ cust.id ])
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
    
    func batchDeleteCustomer(cust : [Customer]) {
        if cust.count > 0 {
            var ids : [String] = []
            for c in cust {
                ids.append(c.id)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "id in %s ", argumentArray: [ ids ])
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
    
    func getCustomers() -> [Customers]{
        var result : [Customers] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            NSLog("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! Customers)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }
    
    func queryByIdentifer(id : String) -> Bool {
        var flag = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        fetchRequest.predicate = NSPredicate(format: "id=%s", argumentArray: [id])
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            if searchResults.count > 0 {
                flag = true
            }
        } catch  {
            NSLog(error as! String)
        }
        return flag
    }
    
    func updateById(id : String , newGroup : String)  {
        let context = getContext()
        let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [ id ])
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
    
    func batchChangeCustomerGroup(cust : [Customer] , group : Group) {
        if cust.count > 0 {
            var ids : [String] = []
            for c in cust {
                ids.append(c.id)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ ids ])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of delete \(searchResults.count)")
                
                for p in searchResults  {
                    p.group_id = group.group_name
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func changeCustomerGroup(group : [MemGroup])  {
        if group.count > 0 {
            var strArray : [String]  = []
            
            for g in group {
                strArray.append(g.group_name)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Customers>(entityName: "Customers")
            //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
            fetchRequest.fetchOffset = 0 //查询的偏移量
            
            fetchRequest.predicate = NSPredicate(format: "group_id in %@", argumentArray: [ strArray ])
            do {
                let searchResults = try context.fetch(fetchRequest)
                NSLog("numbers of delete \(searchResults.count)")
                
                for p in searchResults  {
                    p.group_id = ContactCommon.groupDefault as String
                }
                try context.save()
            } catch  {
                NSLog(error as! String)
            }
        }
    }
    
    func storeGroup( id : Int , group_name : String ){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue( id, forKey: "id")
        person.setValue( group_name, forKey: "group_name")
        
        do {
            try context.save()
            NSLog("op group saved")
        }catch{
            print(error)
        }
    }
    
    func storeGroupArray(gArray : [MemGroup]) {
        if gArray.count > 0 {
            for g in gArray {
                self.storeGroup(id: Int(g.id) , group_name: g.group_name)
            }
        }
    }
    
    func deleteGroup(g:MemGroup)  {
        let context = getContext()
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
//        fetchRequest.fetchLimit = 10 //限定查询结果的数量
//        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "group_name=%s", argumentArray: [g.group_name ])
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
                strArray.append(g.group_name)
            }
            let context = getContext()
            let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
            
            fetchRequest.predicate = NSPredicate(format: "group_name  in %@", argumentArray: [strArray])
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
    
    func  getGroup() -> [Group]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        var result : [Group] = []
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! Group)
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }

    
    
}
