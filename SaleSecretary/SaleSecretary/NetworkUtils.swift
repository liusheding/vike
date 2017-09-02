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
import AipOcrSdk
import AipBase
import MBProgressHUD


let ZJKJ_API_URL = "http://xm.malaoduan.com/api/service.shtml"

let AIP_NPL_LEXER = "https://aip.baidubce.com/rpc/2.0/nlp/v1/lexer?access_token="

let AIP_TOKEN_URL = "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials"

var AIP_ACCESS_TOKEN:String?

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

let AIP_TOKEN_URL_FULL = "\(AIP_TOKEN_URL)&client_id=\(AIP_APP_KEY)&client_secret=\(AIP_APP_SK)"



let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))


let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();@&=+$,/?%#[]{}:\"\\ ").inverted)

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
    
    static func postBackEnd(_ method: String, body: [String: Any], handler: ((_ json : JSON) -> Void)?) -> DataRequest {
        let bodyStr = createBody(method, body: body)
        var req = URLRequest(url: URL(string: ZJKJ_API_URL)!)
        req.httpMethod = HTTPMethod.post.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = bodyStr.data(using: .utf8)! as Data
        req.timeoutInterval = 10
        return Alamofire.request(req).responseJSON {
            response in
            let result = response.result
            switch result  {
            case .success(let value):
                guard response.result.value != nil else {return }
                let json = JSON(value)
                print(json)
                let code = json["head"]["error_code"].string
                if code != "0" {
                    defaultFailureHandler(json["head"]["error_msg"].string)
                    return
                }
                if handler != nil {
                    handler!(json)
                }
            case .failure(_):
                defaultFailureHandler()
            }
        }
    }
    
    static func postBackEnd(_ method: String, body: [String: Any], successHandler: ((_ json : JSON) -> Void)?,
                            failedHandler: ((_ result: Error) -> Void)? ) {
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
                if successHandler != nil {
                    successHandler!(JSON(value))
                }
            case .failure(let error):
                failedHandler!(error)
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
        let str = JSON(params).rawString(.utf8, options: .init(rawValue: 0))!
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
    
 
    static func requestNLPLexer(_ text: String, successHandler:  ((_ json : JSON) -> Void)?) {
        if AIP_ACCESS_TOKEN == nil {
            refreshAipAccessToken()
        }
        var req = URLRequest(url: URL(string: AIP_NPL_LEXER + AIP_ACCESS_TOKEN!)!)
        req.httpMethod = HTTPMethod.post.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyStr:String = JSON(["text":  text]).rawString()!
        print("lexer text is \(bodyStr)")
        req.httpBody = NSString(string: bodyStr).data(using: gbkEncoding)!
        Alamofire.request(req).responseData(completionHandler: {
            response in
            let result = response.result
            switch result  {
            case .success(let value):
                guard response.result.value != nil else {return }
                let uf8 = NSString(data: value, encoding: gbkEncoding)
                let json = JSON.parse(uf8! as String)
                print(json.rawString(.utf8, options: .init(rawValue: 0)) ?? "")
                if successHandler != nil {
                    successHandler!(json)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    public static func refreshAipSession() {
        do {
            let license = Bundle.main.path(forResource: "aip", ofType: "license")
            let data = try Data(contentsOf: URL(fileURLWithPath: license!))
            AipOcrService.shard().auth(withLicenseFileData: data)
            // AipOcrService.shard().auth(withAK: AIP_APP_KEY, andSK: AIP_APP_SK)
//            AipOcrService.shard().getTokenSuccessHandler({
//                (token) in
//                print("get aip session token: \(token ?? "")")
//            }, failHandler: {
//                (error) in
//                print("could not get accesstoken, \(String(describing: error))")
//            })
        } catch {
            print("could not find aip.license")
        }
    }
    
    public static func refreshAipAccessToken() {
        let req = URLRequest(url: URL(string: AIP_TOKEN_URL_FULL)!)
        Alamofire.request(req).responseJSON {
            response in
            let result = response.result
            switch result  {
            case .success(let value):
                guard response.result.value != nil else {return }
                if let aat = JSON(value)["access_token"].string {
                    AIP_ACCESS_TOKEN = aat
                    print("access_toen: \(aat)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //
    public static func defaultFailureHandler(_ msg: String? = "非常抱歉，网络发生错误了,请您稍后再试@~@,") {
        let vc = UIApplication.topViewController()
        let uc = UIAlertController(title: "", message: msg ?? "非常抱歉，网络发生错误了,请您稍后再试@~@,", preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        vc?.present(uc, animated: true, completion: nil)
    }
    
    
    public static func requestDictionary() {
        let _ = postBackEnd("R_BASE_DATA_DIC", body: ["code": "SYS_CONSTANT"], handler: {
            value in
            SYS_DATA_DICTIONARY = value["body"]["data"].arrayValue
        })
    }
    
    
    public static func getDictionary(key: String) -> JSON? {
        if SYS_DATA_DICTIONARY == nil {return nil}
        let dictionary = SYS_DATA_DICTIONARY!
        for data in dictionary {
            let k = data["key"].stringValue
            if k == key {
                return JSON.parse(data["val"].stringValue)
            }
        }
        return nil
    }
}

var SYS_DATA_DICTIONARY: [JSON]?

