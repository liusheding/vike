//
//  WeixinPayModel.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/18.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class WeixinPayModel: NSObject {
    let appID: String
    let noncestr: String
    let package: String
    let partnerID: String
    let prepayID: String
    let sign: String
    let timestamp: Int
        
    init(appID: String, noncestr: String, package: String, partnerID: String, prepayID: String, sign: String, timestamp: Int) {
        self.appID = appID
        self.noncestr = noncestr
        self.package = package
        self.partnerID = partnerID
        self.prepayID = prepayID
        self.sign = sign
        self.timestamp = timestamp
    }
}
