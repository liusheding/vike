//
//  CustomerModel.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CustomerModel: NSObject {

    
}

class Customer : NSObject{
    var name: String?
    var phone_number: String?
    var nick_name: String? // nick name
    var time: String?  // birthday
//    var type: String?
    var icon: String?   //
//    var userid: Int?
//    var is_verify: Bool?
    let properties = ["name", "phone_number" , "icon"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
   }

class CustomerGroup:NSObject {
    var name:String?
    var friends:Array<AnyObject>?
    var count:String?
    // 这个变量是控制分组是否打开的，如果打开则设定展示cell的个数
    var isOpen:Bool? = false
    
    let properties = ["friends", "name", "count","isOpen"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        var friends = [Customer]()
//        if (dict["friends"] as! String) != "" {
            for friendDict in self.friends! {
                let friend = Customer.init(dict: friendDict as! [String : AnyObject])
                friends.append(friend)
            }
//        }
        self.friends = friends
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    class func dictModel() -> [CustomerGroup] {
        
        let path = Bundle.main.path(forResource: "customerList.plist", ofType: nil)
        let list = NSArray.init(contentsOfFile: path!)
        
        var models = [CustomerGroup]()
        for dict in list! {
            models.append(CustomerGroup(dict: dict as! [String : AnyObject]))
        }
        return models
    }
    
}

