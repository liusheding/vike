//
//  CustomerModel.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Contacts
import Alamofire

class CustomerModel: NSObject {
    
    
}

class Customer : NSObject{
    
    let contactDb = CustomerDBOp.defaultInstance()
    
    var name:         String?
    var phone_number: [String]?
    var nick_name:    String? // nick name
    var is_solar :    Bool
    var id :          String
    var group_id :    String
    var gender :      Int   // 0:feman 1:man
    var company :     String
    var birthday :    String
    var app_userId :  String
    var desc : String
    
    let properties = ["birthday","company","gender","group_id","id","is_solar","nick_name","phone_number","name"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    
    static public func == (lhs: Customer, rhs: Customer) -> Bool {
        return true
    }
    
    override init() {
        self.name = ""
        self.phone_number = []
        self.nick_name = ""
        self.company = ""
        self.birthday = ""
        self.gender = 1
        self.group_id = ContactCommon.groupDefaultX
        self.id =  ""
        self.is_solar = true
        self.app_userId = ""
        self.desc = ""
    }
    
    init( json : JSON ){
        self.name = json["name"].stringValue
        self.id = json["id"].stringValue
        self.group_id = json["cusGroupId"].stringValue
        self.phone_number = [json["cellphoneNumber"].stringValue]
        self.birthday = json["birthday"].stringValue
        self.nick_name = json["cw"].stringValue
        self.is_solar = json["birthdayType"].stringValue == "1" ? true : false
        self.gender =  0 //Int(json["sex"].stringValue)!
        self.company = json["company"].stringValue
        self.app_userId = APP_USER_ID!
        self.desc = ""
    }
    
    init( name : String , phoneNum : [String] ) {
        self.name = name
        self.phone_number = phoneNum
        self.nick_name = ""
        self.company = ""
        self.birthday = ""
        self.gender = 1
        self.group_id = ContactCommon.groupDefaultX
        self.id =  ""
        self.is_solar = true
        self.app_userId = APP_USER_ID!
        self.desc = ""
    }
    
    /*
     * default : [ gender : 1 , group_id : "默认" , id : 0 , is_solar : true ]
     */
    init( birth : String , company:String , nick_name:String  , phone_number : [String] , name:String , id : String ) {
        self.name = name
        self.phone_number = phone_number
        self.nick_name = nick_name
        self.company = company
        self.birthday = birth
        self.is_solar = true
        self.id = id
        self.group_id = ContactCommon.groupDefaultX
        self.gender = 1
        self.app_userId = APP_USER_ID!
        self.desc = ""
    }
    
    init( birth : String , company:String , nick_name:String  , phone_number : [String] , name:String , id : String , is_solar : Bool , groupId : String , gender : Int , desc : String){
        
        self.name = name
        self.phone_number = phone_number
        self.nick_name = nick_name
        self.company = company
        self.birthday = birth
        self.id = id
        self.is_solar = is_solar
        self.group_id = groupId
        self.gender = gender
        self.app_userId = APP_USER_ID!
        self.desc = desc
        
    }
    
    init(ctm : Customers) {
        self.name = ctm.user_name
        self.birthday = ctm.birthday!
        self.company = ctm.company!
        self.gender = Int(ctm.gender)
        self.group_id = ctm.group_id!
        self.id = ctm.id!
        self.is_solar = ctm.is_solar
        self.nick_name = ctm.nick_name
        self.phone_number = ctm.phone_number?.components(separatedBy: ",")
        self.app_userId = ctm.app_userId!
        self.desc =  ctm.desc!
    }
    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.name = ( cnContact.familyName + cnContact.givenName  ).trimmingCharacters(in: CharacterSet.whitespaces)
        // phone
        self.phone_number = []
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                self.phone_number?.append((phone?.stringValue)!)
            }
        }
        self.nick_name = ""
        self.company = ""
        self.birthday = ""
        self.gender = 1
        self.group_id = ContactCommon.groupDefaultX
        self.id =  ""
        self.is_solar = true
        self.app_userId = APP_USER_ID!
        self.desc = ""
        
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    public func save(_ callback: @escaping ((JSON) -> Void)) -> DataRequest? {
        var body : [String : String] = [:]
        body["busi_scene"] = ContactCommon.addUserSingle
        body["userId"]     = APP_USER_ID
        body["name"]       = self.name
        body["cusGroupId"] = self.group_id
        body["cellphoneNumber"] = (self.phone_number?.count)!>0 ? self.phone_number?[0] : ""
        body["sex"]        = "\(self.gender)"
        body["birthday"]   = self.birthday
        body["birthdayType"] = self.is_solar ? "0" : "1"
        body["company"]    = self.company
        body["cw"]         = self.nick_name
        body["desc"]       = self.desc
        
        let request = NetworkUtils.postBackEnd("C_TXL_CUS_INFO"  , body: body) { (json) in
            let id = json["body"]["id"].stringValue
            self.id = id
            self.contactDb.insertCustomer(ctms: self , groupId: self.group_id)
            callback(json["body"])
        }
        return request
    }
    
//    public func update() -> DataRequest {
//        
//    }
}

class MemGroup{
    
    var id :          String
    var group_name :  String
    var app_userId :  String
    var total  : Int
    
    init() {
        self.id = ""
        self.group_name = ContactCommon.groupDefault as String
        self.app_userId = APP_USER_ID!
        self.total = 0
    }
    
    init(id: String , gn : String ){
        self.id = id
        self.group_name  = gn
        self.app_userId = APP_USER_ID!
        self.total = 0
    }
    
    init(json : JSON) {
        self.group_name = json["name"].stringValue
        self.id = json["id"].stringValue
        self.total = Int(json["cusTotal"].stringValue)!
        self.app_userId = APP_USER_ID!
    }
    
    static func toMemGroup( dbGroup : [Group]) -> [MemGroup] {
        var result : [MemGroup] = []
        if dbGroup.count > 0 {
            for dbg in dbGroup {
                result.append( MemGroup.init(id: dbg.id! , gn: dbg.group_name! ))
            }
        }
        return result
    }
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
    
    init( customer: [Customers] , group : Group ){
        self.name = group.group_name
        self.friends = [Customer]()
        for ctm in customer {
            if ctm.group_id == group.id {
                self.friends?.append( Customer.init(ctm: ctm))
            }
        }
    }
    
    init(cust : [Customer] , group : MemGroup) {
        self.name = group.group_name
        self.friends = [Customer]()
        for ctm in cust  {
            if ctm.group_id == group.id {
                self.friends?.append(ctm)
            }
        }
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
}

class TrailMessage {
    var id : String?
    var cusInfoId : String?
    var title : String?
    var content : String?
    var date : String?
    
    init() {
        self.id = ""
        self.title = ""
        self.cusInfoId = ""
        self.content = ""
        self.date = ""
    }
    
    init(json : JSON) {
        self.id = json["cusInfoId"].stringValue
        self.title = json["title"].stringValue
        self.content = json["content"].stringValue
        self.date = json["date"].stringValue
        self.cusInfoId = ""
    }
    
    init(title : String , content : String , cusInfoId : String) {
        self.title = title
        self.content  = content
        self.date = DateFormatterUtils.getStringFromDate( Date.init() , dateFormat:"yyyy/MM/dd HH:mm:ss")
        self.id = "1"
        self.cusInfoId = cusInfoId
    }
    
    func save(_ callback: @escaping ((JSON) -> Void) ) -> DataRequest? {
        var body :[String : String] = [:]
        body["cusInfoId"] = self.cusInfoId
        body["title"]     = self.title
        body["content"]   = self.content
        let request = NetworkUtils.postBackEnd("C_TXL_CUS_GTGJ", body: body) { (json) in
            let id = json["body"]["id"].stringValue
            self.id = id
            callback(json["body"])
        }
        return request
    }
}

struct ContactCommon {
    static let max = 255.0
    
    static let defaultLength : Int = 10
    
    static let trailTitltLen : Int = 20
    static let trailContentLen : Int = 1000
    static let THEME_COLOR = UIColor.colorWithHexString(hex: "01B414")
    static let  sampleColor = [ UIColor.colorWithHexString(hex: "feaa28") , UIColor.colorWithHexString(hex: "ff8e89") , UIColor.colorWithHexString(hex: "76abf0") , UIColor.colorWithHexString(hex: "4ec962")]
    
    static let count = sampleColor.count
    
    static let addUserSingle = "SINGLE"
    static let addUserBatch = "BATCH"
    static let defaultRequestCount = 1000
    
    // confirm ctm is in target or not  : name and phoneNumber
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
    static let groupDefault : NSString = "默认分组"
    static let groupDefaultX : String = "defaultId"
    
    static func limitedLength(str : String) -> Bool {
        var flag = false
        if str.characters.count > 0 && str.characters.count <= ContactCommon.defaultLength {
            flag = true
        }
        return flag
    }
    
    static func isExistInGroup(newName :String , group : [MemGroup]) -> Bool{
        var flag = false
        for g in group {
            if g.group_name == newName {
                flag = true
                break
            }
        }
        return flag
    }
    
    static func validateGroupName(newName :String , group : [MemGroup]) -> String {
        var msg = ""
        if !limitedLength(str: newName){
            msg = "输入字数过长"
        }
        if isExistInGroup(newName: newName, group: group){
            msg = "您输入组名重复，请重新输入！"
        }
        return msg
    }
    
    static func generateCustomerGroup(cust : [Customer] , grp : [MemGroup]) -> [CustomerGroup] {
        var result : [CustomerGroup]  = []
        
        for g in grp {
            result.append( CustomerGroup.init(cust: cust , group: g ))
        }
        
        return result
    }
    
    static func getDefaultId(groups : [Group]) -> String {
        
        var defaultId = ""
        for g in groups {
            if g.group_name == self.groupDefault as String {
                defaultId = g.id!
                break
            }
        }
        return defaultId
    }
    
}

