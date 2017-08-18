//
//  ShareViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

let UMENG_SHARE_TEXT = "点帮帮里程碑"
let UMENG_MILESTONE_SHARE_TEXT = "点帮帮里程碑"
let UMENG_INVITE_SHARE_TEXT = "发现一款好玩的APP,点帮帮，快来下载吧，下载地址是http://bangbang.pointgongyi.com"
let ABOUT_US_URL = "http://bangbang.pointgongyi.com"

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createBtn();
        
    }
    func createBtn(){
        let btn             = UIButton(type:.custom)
        let btn_frame       = CGRect(x: 0, y: 0, width: 100,height: 44)
        btn.frame           = btn_frame
        btn.center          = self.view.center
        btn.backgroundColor = UIColor.red
        btn.setTitle("点击", for: UIControlState())
        btn.addTarget(self, action: #selector(self.handleBtnAction), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    func handleBtnAction(_ sender:UIButton ){
        
        //To  Do
        
        let shareView = ShareView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        shareView.setShareModel(UMENG_INVITE_SHARE_TEXT, image: UIImage(named: "share_logo")!, url: ABOUT_US_URL, title: UMENG_SHARE_TEXT)
        
        shareView.showInViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
