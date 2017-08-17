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
    
    static func defaultInstance() -> CustomerDBOp {
        return self.instance
    }
    
    private override init(){
        
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // batch insert Customer 
    func insertCustomerArray(ctms : [Customer]) {
        if ctms.count != 0 {
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
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        fetchRequest.predicate = NSPredicate(format: "user_name = %s and phone_number=%s", argumentArray: [cust.name ?? "" , cust.phone_number?.joined(separator: ContactCommon.separatorDefault ) ?? ""])
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
    
    func getCustomers() -> [Customers]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        var result : [Customers] = []
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
    
    
    func  getGroup() -> [Group]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        var result : [Group] = []
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            NSLog("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                result.append(p as! Group)
//                NSLog("Group contents : \(c.objectID) [\(c.id) : \(String(describing: c.group_name))]")
            }
        } catch  {
            NSLog(error as! String)
        }
        return result
    }

    
    
}
