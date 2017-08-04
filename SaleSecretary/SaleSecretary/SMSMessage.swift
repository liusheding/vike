//
//  SMSMessage.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


class SMSMessage {
    
    var content : String!
    
    var time : Date!
    
    var reps : [Recipient]
    
    public init() {
        content = ""
        time = Date()
        reps = []
    }
    
    public init(_ content : String, time: Date, reps : [Recipient]) {
        self.content = content
        self.time = time
        self.reps = reps
    }
    
}
