//
//  NewUserHelpController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/19.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class NewUserHelpController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置访问资源
        let url = URL(string: "http://xm.zj.vc/guide");
        
        // 2.建立网络请求
        let request = URLRequest(url: url!);
        
        // 3.加载网络请求
        webView.loadRequest(request)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
