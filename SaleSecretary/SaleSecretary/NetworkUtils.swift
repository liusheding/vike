//
//  NetworkUtils.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/9.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


let ZJKJ_API_URL = "http://112.74.110.182:8080/zjkj-scrm-v1707/api/service.shtml"


let HEAD = "head"
let BODY = "body"

let H_AGENT_NO = "agent_no"
let H_INTF_NO = "intf_no"
let H_REQ_TIME = "req_time"
let H_REQ_TRANS_NO = "req_trans_no"
let H_USER = "username"
let H_SIGN = "signature"

let H_SIGN_FILEDS = [H_AGENT_NO, H_USER, H_REQ_TIME, H_REQ_TRANS_NO]

let C_USER = "zjkj_android"
let C_SK = "123456"
let C_AGENT_NO = "app"


let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();@&=+$,/?%#[]{}:\" ").inverted)

extension String {
    
    // 作者：Jiubao
    // 链接：http://www.jianshu.com/p/a832dc2e7000
    // 來源：简书
    // 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}


struct NetworkUtils {
    
    static func postBackEnd(_ method: String, body: [String: Any], handler: ((_ json : JSON) -> Void)?) {
        let bodyStr = createBody(method, body: body)
        print(bodyStr)
        var req = URLRequest(url: URL(string: ZJKJ_API_URL)!)
        req.httpMethod = HTTPMethod.post.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = bodyStr.data(using: .utf8)! as Data
        Alamofire.request(req).responseJSON {
            response in
            let result = response.result
            switch result  {
            case .success(let value):
                guard response.result.value != nil else {return }
                if handler != nil {
                    handler!(JSON(value))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private static func createBody(_ method: String, body: [String: Any]) -> String {
        var params: [String:Any] = [:]
        var head: [String:String] = [:]
        let now = Date()
        let time = "\(Int(now.timeIntervalSince1970 * 1000))"
        head[H_AGENT_NO] = "app"
        head[H_INTF_NO] = method
        head[H_REQ_TIME] = time
        // UIDevice.current.identifierForVendor?.uuidString
        head[H_REQ_TRANS_NO] = time
        head[H_USER] = C_USER
        params[BODY] = body
        params[HEAD] = head
        head[H_SIGN] = generateSign(params: params)
        params[HEAD] = head
        let str = JSON(params).rawString(.utf8, options: JSONSerialization.WritingOptions.init(rawValue: 0))!
        return str
    }
    
    private static func generateSign(params: [String: Any]) -> String {
        let bodyStr = JSON(params[BODY] ?? [:]).rawString(.utf8, options: JSONSerialization.WritingOptions.init(rawValue: 0))!
        let head:[String:String] = params[HEAD] as! [String : String]
        var str = ""
        for h in H_SIGN_FILEDS {
            str = str + h + head[h]!
        }
        str += BODY
        str += bodyStr
        str += C_SK
        print(str)
        // print(str.addingPercentEscapes(using: .utf8)!)
        let encodedStr = str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        // let encodedStr = str.addingPercentEscapes(using: .utf8)!
        print(encodedStr ?? "")
        return encodedStr!.md5().uppercased()
    }
    
}


