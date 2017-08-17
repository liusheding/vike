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
    
    var name:         String?
    var phone_number: [String]?
    var nick_name:    String? // nick name
    var is_solar :    Bool
    var id :          Int
    var group_id :    String
    var gender :      Int   // 0:feman 1:man
    var company :     String
    var birthday :    String
    
    let properties = ["birthday","company","gender","group_id","id","is_solar","nick_name","phone_number","name"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    
    override init() {
        self.name = ""
        self.phone_number = []
        self.nick_name = ""
        self.company = ""
        self.birthday = ""
        self.gender = 1
        self.group_id = "默认"
        self.id =  0
        self.is_solar = true
    }
    
    /* 
     * default : [ gender : 1 , group_id : "默认" , id : 0 , is_solar : true ]
     */
    init( birth : String , company:String , nick_name:String  , phone_number : [String] , name:String ) {
        self.name = name
        self.phone_number = phone_number
        self.nick_name = nick_name
        self.company = company
        self.birthday = birth
        self.is_solar = true
        self.id = 0
        self.group_id = "默认"
        self.gender = 1
    }
    
    init(ctm : Customers) {
        self.name = ctm.user_name
        self.birthday = ctm.birthday!
        self.company = ctm.company!
        self.gender = Int(ctm.gender)
        self.group_id = ctm.group_id!
        self.id = Int(ctm.id)
        self.is_solar = ctm.is_solar
        self.nick_name = ctm.nick_name
        self.phone_number = ctm.phone_number?.components(separatedBy: ",")
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
   }


class CustomerGroup:NSObject {
    var name:String?
    var friends:Array<Customer>?
    var count:String?
    // 这个变量是控制分组是否打开的，如果打开则设定展示cell的个数
    var isOpen:Bool? = false
    
    let properties = ["friends", "name", "count","isOpen"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    
    override init(){}
    
    init(group: Group ){
        self.name = group.group_name
    }
    
    // MARK: - 构造函数
//    init(dict: [String: AnyObject]) {
//        super.init()
//        setValuesForKeys(dict)
//        var friends = [Customer]()
//        for friendDict in self.friends! {
//            let friend = Customer.init( )
//            friends.append(friend)
//        }
//        self.friends = friends
//    }
    
    init( customer: [Customers] , group : Group ){
        self.name = group.group_name
        self.friends = [Customer]()
        for ctm in customer {
            if ctm.group_id == self.name {
                self.friends?.append( Customer.init(ctm: ctm))
            }
        }
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
//    class func dictModel() -> [CustomerGroup] {
//        
//        let path = Bundle.main.path(forResource: "customerList.plist", ofType: nil)
//        let list = NSArray.init(contentsOfFile: path!)
//        
//        var models = [CustomerGroup]()
//        for dict in list! {
//            models.append(CustomerGroup(dict: dict as! [String : AnyObject]))
//        }
//        return models
//    }
    
}


struct ContactCommon {
    static let max = 255.0
//    static let sampleColor = [UIColor.init(red: CGFloat.init(254.0/max), green: CGFloat.init(170)/max, blue: CGFloat.init(40)/max, alpha: CGFloat.init(1)) ,
//                 UIColor.init(red: CGFloat.init(255)/max, green: CGFloat.init(142)/max, blue: CGFloat.init(137)/max, alpha: CGFloat.init(1)) ,
//        UIColor.init(red: CGFloat.init(118)/max, green: CGFloat.init(171)/max, blue: CGFloat.init(240)/max, alpha: CGFloat.init(1)) ,
//        UIColor.init(red: CGFloat.init(78)/max, green: CGFloat.init(210)/max, blue: CGFloat.init(98)/max, alpha: CGFloat.init(1))
//    ]
    static let  sampleColor = [ UIColor.colorWithHexString(hex: "feaa28") , UIColor.colorWithHexString(hex: "ff8e89") , UIColor.colorWithHexString(hex: "76abf0") , UIColor.colorWithHexString(hex: "4ec962")]
    
    static let count = sampleColor.count
    
    // confirm ctm in target or not  : name and phoneNumber
    static func isContain(ctm : Customer , target : [Customers]) -> Bool {
        var result  = false
        if (findIndexInArray(ctm: ctm , target: target) > -1) {
            result = true
        }
        return result
    }
    
    static func findIndexInArray(ctm : Customer , target : [Customers] ) -> Int{
        var indexFlag = -1
        let phone = ctm.phone_number?.joined(separator: ",")
        for (index , tg) in target.enumerated() {
            if tg.user_name == ctm.name && tg.phone_number == phone {
                indexFlag = index
                break
            }
        }
        return indexFlag
    }
    
    static let separatorDefault = ","
    
}

