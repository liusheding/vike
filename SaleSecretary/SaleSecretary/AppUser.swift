//
//  AppUser.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/22.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum UserRole:String {
    case PTYWY = "业务员"
    case YJDLS = "一级代理商"
    case EJDLS = "二级代理商"
    case KH    = "客户"
    
    static func fromString(str: String?) -> UserRole? {
        if str == "PTYWY" {return .PTYWY}
        else if str == "YJDLS" {return .YJDLS}
        else if str == "EJDLS" {return .EJDLS}
        else if str == "KH" {return .KH}
        else {return nil}
    }
}

class AppUser: NSObject {
    
    public static var currentUser: AppUser?
    
    var id: String?
    
    var cellphoneNumber: String?
    
    var loginPwd: String?
    
    var name: String?
    
    var referralCode: String?
    
    // 平台业务员：PTYWY
    // 一级代理商：YJDLS
    // 二级代理商：EJDLS
    // 客户：KH
    var role: UserRole?
    
    override init() {
        
    }
    
    init(response: JSON) {
        self.id = response["id"].string
        self.name = response["name"].string
        self.cellphoneNumber = response["cellphoneNumber"].string
        self.role = UserRole.fromString(str: response["roleCode"].string)
        self.referralCode = response["referralCode"].string
        self.body = response
    }
    
    
    
    var body: JSON?
    
    
    public static func loadFromServer(callback: @escaping ((AppUser)-> Void) ) -> DataRequest? {
        let id:String? = UserDefaults.standard.string(forKey: APP_USER_KEY)
        if let _id = id {
            return fromId(id: _id, callback: callback)
        }
        return nil
    }
    
    
    public static func fromId(id: String, callback: @escaping ((AppUser)-> Void)) -> DataRequest? {
        let body:[String: Any] = ["busi_scene": "USER_INFO", "id": id]
        
        return NetworkUtils.postBackEnd("R_BASE_USER", body: body, handler: {
            json in
            let response = json["body"]
            let user = AppUser(response: response)
            callback(user)
        })
    }
    
    
    public static func login(phone: String, password: String, callback: @escaping ((AppUser)-> Void)) -> DataRequest? {
        let body:[String: Any] = ["busi_scene": "LOGIN", "cellphoneNumber": phone, "loginPwd": password]
        return NetworkUtils.postBackEnd("R_BASE_USER", body: body, handler: {
            json in
            let response = json["body"]
            let user = AppUser(response: response)
            callback(user)
        })
    }
    
    
    public static func logout() {
        APP_USER_ID = nil
        UserDefaults.standard.setValue(nil, forKey: APP_USER_KEY)
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginID")
        UIApplication.shared.delegate?.window??.rootViewController = loginVC
    }
    
    
}
