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



class MessageSchedule: NSObject {
    
    var id: String?
    
    var userId: String!
    
    var type: String!
    
    var content: String!
    
    var executeTime: String!
    
    var createTime: String?
    
 
    
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
    
    
}
