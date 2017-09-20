//
//  SMSTemplate.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


class SMSTemplate {
    
    var id:String?
    
    var content: String
    
    var dxtd:String?
    
    init(_ id: String?, content: String) {
        self.id = id
        self.content = content
    }
}
