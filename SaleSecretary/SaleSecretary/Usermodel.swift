//
//  Usermodel.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class User : NSObject{
    var name: String?
    var phone: String?
    let properties = ["name", "phone"]
    
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
        self.name =  "demo"
        self.phone = "888888"
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
        //        if (dict["friends"] as! String) != "" {
        for friendDict in self.friends! {
            let friend = User.init(dict: friendDict as! [String : AnyObject])
            friends.append(friend)
        }
        //        }
        self.friends = friends
    }
    
    override func  setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    class func dictModel() -> [UserGroup] {
        
        let path = Bundle.main.path(forResource: "userList.plist", ofType: nil)
        let list = NSArray.init(contentsOfFile: path!)
        
        var models = [UserGroup]()
        for dict in list! {
            models.append(UserGroup(dict: dict as! [String : AnyObject]))
        }
        return models
    }
    
}

