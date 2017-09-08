//
//  MessageSchedule.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MsgKH: NSObject {
    
    var cw: String!
    var sjhm: String!
    var qm: String?
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        self.cw = json["cw"].stringValue
        self.sjhm = json["sjhm"].stringValue
        self.qm = json["qm"].string
    }
    
    init(customer: Customer) {
        super.init()
        self.cw = customer.name
        self.sjhm = customer.phone_number?[0]
        self.qm = ""
    }
    
}


class MessageSchedule: NSObject {
    
    var id: String?
    
    var userId: String!
    
    var type: String!
    
    var content: String!
    
    var executeTime: String!
    
    var createTime: String?
    
    var customers: [MsgKH] = []
    
    var userSign:String = ""
    
    var count: Int?
    
    var cw:String?
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        self.id = json["id"].stringValue
        self.userId = json["userId"].stringValue
        self.content = json["content"].stringValue
        self.type = json["planType"].stringValue
        self.executeTime = json["dateExecuteYj"].stringValue
        self.createTime = json["dateCreate"].stringValue
        self.count = json["sendDxts"].int
        if let cust = json["xzkh"].string  {
            if cust.isEmpty {return}
            let obj = JSON.parse(cust).arrayValue
            for  o in obj {
                self.customers.append(MsgKH(json: o))
            }
        }
    }
    
    public func addCustomer(customer: Customer) {
        self.customers.append(MsgKH(customer: customer))
    }
    
    public func addCustomer(json: JSON) {
        self.customers.append(MsgKH(json: json))
    }
    
    public func addCustomer(kh: MsgKH) {
        self.customers.append(kh)
    }
    
    static func loadMySchedules(_ completion: @escaping (([MessageSchedule]) -> Void)) -> DataRequest? {
        if APP_USER_ID == nil {return nil}
        let user = APP_USER_ID!
        let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_DXJH", body: ["userId": user, "pageSize": 300]) {
            json in
            let data = json["body"]
            var msgs: [MessageSchedule] = []
            if let array:[JSON] = data["obj"].array {
                for a in array {
                    msgs.append(MessageSchedule(json: a))
                }
            }
            completion(msgs)
        }
        return request
    }
    
    func update(_ completion: @escaping ((JSON) -> Void)) -> DataRequest? {
        var body:[String: Any] = [:]
        body["userId"] = APP_USER_ID
        body["planType"] = "0"
        body["content"] = self.content
        body["dateExecuteYj"] = self.executeTime
        body["autograph"] = AppUser.currentUser?.name
        body["id"] = self.id
        body["dxtdId"] = ""
        var yld:[[String:String]] = []
        for c in self.customers {
            yld.append(["sjhm": c.sjhm, "cw": c.cw, "qm": userSign])
        }
        let yl = JSON(yld)
        let str = yl.rawString(.utf8, options: .init(rawValue: 0))
        body["yl"] = str
        let request = NetworkUtils.postBackEnd("U_DXJH", body: body, handler: {json in
            completion(json["body"])
        })
        return request
    }
    
    func delete(_ completion: @escaping ((JSON) -> Void)) -> DataRequest? {
        var body:[String: Any] = [:]
        body["ids"] = self.id
        let request = NetworkUtils.postBackEnd("D_DXJH", body: body, handler: {json in
            completion(json["body"])
        })
        return request
    }
    
    
    func save(_ completion: @escaping ((JSON) -> Void)) -> DataRequest? {
        var body:[String: Any] = [:]
        body["userId"] = APP_USER_ID
        body["planType"] = self.type
        body["content"] = self.content
        body["dateExecuteYj"] = self.executeTime
        // 使用统一签名
        if let _cw = self.cw {
            body["autograph"] = _cw
        }
        body["dxtdId"] = ""
        var yld:[[String:String]] = []
        for c in self.customers {
            yld.append(["sjhm": c.sjhm, "cw": c.cw, "qm": self.userSign])
        }
        let yl = JSON(yld)
        let str = yl.rawString(.utf8, options: .init(rawValue: 0))
        body["yl"] = str
        let request = NetworkUtils.postBackEnd("C_DXJH", body: body, handler: {json in
            completion(json["body"])
        })
        return request
    }
    
//static
    
    
}
