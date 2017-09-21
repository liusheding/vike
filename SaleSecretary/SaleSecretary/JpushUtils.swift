//
//  JpushUtils.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/9/21.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


struct JpushUtils {
    
    static func addTags(tags: Set<String>) {
        let now = Date()
        let time = Int(now.timeIntervalSince1970 * 1000)
        JPUSHService.addTags(tags, completion: { (code, tags, seq) in
            print(code)
        }, seq: time)
    }
    
}
