//
//  Month.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation


let chineseNumbers = ["一", "二",  "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"]
let yue = "月"

class Month {
    
    var chinese: String!
    
    var int: Int!
    
    var season: Int! {
        get {
            return Int((int - 1) / 4) + 1
        }
    }
    
    public init(_ int: Int, chinese: String ) {
        self.int = int
        self.chinese = chinese
    }
    
    
    
    public static func allYear() -> [Month] {
        var all: [Month] = []
        for i in 1...12 {
            all.append(Month(i, chinese: chineseNumbers[i - 1] + yue))
        }
        return all
    }
    
}
