//
//  MessageCache.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/6.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Foundation

class MessageCache: NSObject {
    // 写缓存
    func writeLocalCacheData(data:String, withKey key:String) {
        
        // 设置存储路径
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0].appending("/\(key).txt")
        // 判读缓存数据是否存在
        if !FileManager.default.fileExists(atPath: cachesPath) {
            FileManager.default.createFile(atPath: cachesPath, contents: nil, attributes: nil)
        }
        // 追加存储新的缓存数据 分割符$
        let data = data + "|&|"
        let appendedData = data.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = FileHandle(forWritingAtPath: cachesPath)
        writeHandler!.seekToEndOfFile()
        writeHandler!.write(appendedData!)
        writeHandler!.closeFile()
    }
    
    // 读缓存
    func readLocalCacheDataWithKey(key:String) -> String? {
        
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            .appending("/\(key).txt")
        
        // 判读缓存数据是否存在
        if FileManager.default.fileExists(atPath: cachesPath) {
            
            // 读取缓存数据
            do{
                return try String(contentsOfFile: cachesPath)
            }catch let error as NSError{
                print("读取数据错误-->\(error)")
                return ""
            }
        }
        
        return ""
    }
    
    // 删缓存
    func deleteLocalCacheDataWithKey(key:String) {
        
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            .appending("/\(key).txt")
        
        // 判读缓存数据是否存在
        if FileManager.default.fileExists(atPath: cachesPath) {
            
            // 删除缓存数据
            try! FileManager.default.removeItem(atPath: cachesPath)
        }
    }
}
