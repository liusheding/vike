//
//  Usermodel.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SwiftyJSON

class User : NSObject{
    var name: String!
    var phone: String?
    var userid: String?
    var status: String?
    var role: String?
    let properties = ["name", "phone", "userid", "status", "role"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override init () {
        self.name =  ""
        self.phone = ""
        self.userid = ""
        self.status = ""
        self.role = ""
    }
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
}

class UserGroup:NSObject {
    var name:String?
    var friends:Array<AnyObject>?
    // 这个变量是控制分组是否打开的，如果打开则设定展示cell的个数
    var isOpen:Bool? = false
    
    let properties = ["friends", "name", "isOpen"]
    
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return ("\(dict)")
    }
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        var friends = [User]()
        for friendDict in self.friends! {
            let friend = User.init(dict: friendDict as! [String : AnyObject])
            friends.append(friend)
        }
        friends.sort { (s1, s2) -> Bool in
            s1.name < s2.name
        }
        self.friends = friends
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    class func dictModel(jsondata:JSON) -> [UserGroup] {
        var list = [
            ["name":"一级代理商", "isOpen":0, "friends":[]],
            ["name":"二级代理商", "isOpen":0, "friends":[]],
            ["name":"客户", "isOpen":0, "friends":[]],
            ["name":"冻结账号", "isOpen":0, "friends":[]],
        ]
        
        if AppUser.currentUser?.role == .YJDLS{
            list = [
                ["name":"二级代理商", "isOpen":0, "friends":[]],
                ["name":"客户", "isOpen":0, "friends":[]],
                ["name":"冻结账号", "isOpen":0, "friends":[]],
            ]
        } else if AppUser.currentUser?.role == .EJDLS{
            list = [
                ["name":"客户", "isOpen":0, "friends":[]],
                ["name":"冻结账号", "isOpen":0, "friends":[]],
            ]
        }
        
        for data in jsondata.array!{
            if AppUser.currentUser?.role == .PTYWY{
                var freeze = list[3]["friends"] as! Array<[String:String]>
                if data["roleCode"].stringValue == "YJDLS"{
                    if data["status"].stringValue == "1"{
                        freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    }else{
                        var fir = list[0]["friends"] as! Array<[String:String]>
                        fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                        list[0]["friends"] = fir
                    }
                    
                }
                else if data["roleCode"].stringValue == "EJDLS"{
                    if data["status"].stringValue == "1"{
                        freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    }else{
                        var fir = list[1]["friends"] as! Array<[String:String]>
                        fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                        list[1]["friends"] = fir
                    }
                    
                }
                else if data["roleCode"].stringValue == "KH"{
                    if data["status"].stringValue == "1"{
                        freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    }else{
                        var fir = list[2]["friends"] as! Array<[String:String]>
                        fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                        list[2]["friends"] = fir
                    }
                }
                list[3]["friends"] = freeze
            }
            else if AppUser.currentUser?.role == .YJDLS{
                var freeze = list[3]["friends"] as! Array<[String:String]>
                if data["roleCode"].stringValue == "EJDLS"{
                    if data["status"].stringValue == "1"{
                        freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    }else{
                        var fir = list[0]["friends"] as! Array<[String:String]>
                        fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                        list[0]["friends"] = fir
                    }
                }
                else if data["roleCode"].stringValue == "KH"{
                    if data["status"].stringValue == "1"{
                        freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    }else{
                        var fir = list[1]["friends"] as! Array<[String:String]>
                        fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                        list[1]["friends"] = fir
                    }
                }
                list[3]["friends"] = freeze
            }
            else if AppUser.currentUser?.role == .EJDLS{
                var freeze = list[3]["friends"] as! Array<[String:String]>
                if data["status"].stringValue == "1"{
                    freeze.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                }else{
                    var fir = list[0]["friends"] as! Array<[String:String]>
                    fir.append(["name":data["name"].stringValue, "phone":data["cellphoneNumber"].stringValue, "userid":data["id"].stringValue, "status":data["status"].stringValue, "role":data["roleCode"].stringValue])
                    list[0]["friends"] = fir
                }
                list[3]["friends"] = freeze
            }
        }
        
        var models = [UserGroup]()
        for dict in list {
            models.append(UserGroup(dict: dict as! [String : AnyObject]))
        }
        return models
    }
    
}

