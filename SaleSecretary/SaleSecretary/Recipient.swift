//
//  Recipient.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


class Recipient {
    
    var imageStr : String!
    
    var name : String!
    
    var title : String! = ""
    
    var phone : String! = "" {
    
        didSet {
            func check() ->Bool {
                return true
            }
            self.phone = "12"
        }
    }
    
}
