//
//  QRCode.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/9/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class QRCode: NSObject{
    
    var name: String!
    
    var cellphoneNumber: String!
    
    var company: String!
    
    var position: String?
    
    var companyAddress: String?
    
    var companyTel: String?
    
    var email: String?
    
    var userId: String!
    
    var qrCodeLinkurl: String?
    
    var qrCodeSrc: String?
    
    override init() {
        super.init()
    }
    
    public init(json: JSON) {
        super.init()
        self.name = json["name"].stringValue
        self.cellphoneNumber = json["cellphoneNumber"].stringValue
        self.company = json["company"].stringValue
        self.userId = json["userId"].stringValue
        self.position = json["position"].string
        self.companyAddress = json["companyAddress"].string
        self.companyTel = json["companyTel"].string
        self.email = json["email"].string
        self.qrCodeSrc = json["qrCodeSrc"].string
        self.qrCodeLinkurl = json["qrCodeLinkurl"].string
    }
    

    public func save(_ callback: ((JSON) -> Void)?) -> DataRequest {
        var body: [String:String] = [:]
        body["userId"] = self.userId
        body["name"] = self.name
        body["cellphoneNumber"] = self.cellphoneNumber
        body["company"] = self.company
        body["position"] = self.position ?? ""
        body["companyAddress"] = self.companyAddress ?? ""
        body["companyTel"] = self.companyTel ?? ""
        body["email"] = self.email ?? ""
        let requset = NetworkUtils.postBackEnd("C_BUSI_CRAD", body: body, handler: callback)
        return requset
    }
    
    
    static func getUserQRCodes(_ callback: ((JSON) -> Void)?) -> DataRequest {
        var body: [String:String] = [:]
        body["userId"] = APP_USER_ID
        body["pageSize"] = "99"
        return NetworkUtils.postBackEnd("R_PAGED_QUERY_BUSI_CRAD", body: body, handler: callback)
    }
}

