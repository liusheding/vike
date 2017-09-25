//
//  UserProtocolController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/19.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class UserProtocolController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.clickCancelBtn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置访问资源
        let url = URL(string: "http://xm.zj.vc/privacy");
        
        // 2.建立网络请求
        let request = URLRequest(url: url!);
        
        // 3.加载网络请求
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickCancelBtn(){
        self.dismiss(animated: true, completion: nil)
    }

}
