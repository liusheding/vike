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
    
    
    static func loadMySchedules(_ completion: @escaping ((JSON) -> Void)) -> DataRequest? {
        if APP_USER_ID == nil {return nil}
        let user = APP_USER_ID!
        let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_DXJH", body: ["userId": user, "pageSize": 300]) {
            json in
            let data = json["body"]
            
        }
        return request
    }
    
    
}
