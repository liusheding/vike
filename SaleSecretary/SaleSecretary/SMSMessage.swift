//
//  SMSMessage.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


class SMSMessage {
    
    var id : String!
    
    var content : String!
    
    var time : Date!
    
    var recipent : Recipient!
    
    
    var lengths : [Int] {
        get {
            return [title.characters.count, content.characters.count, inscribe.characters.count]
        }
    }
    
    var title : String  {
        get {
            return (recipent.title != nil && recipent.title! != "") ? recipent.title! : recipent.name
        }
    }
    
    var inscribe : String
    
    
    public init(_ content : String, time: Date, recipent : Recipient, inscribe: String) {
        self.content = content
        self.time = time
        self.recipent = recipent
        self.inscribe = inscribe
    }
    
}
