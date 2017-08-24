//
//  ChangePwdController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/24.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ChangePwdController: UIViewController {
    @IBOutlet weak var oldpwd: UITextField!
    @IBOutlet weak var newpwd: UITextField!
    @IBOutlet weak var newpwd2: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        oldpwd.borderStyle = .none
        newpwd.borderStyle = .none
        newpwd2.borderStyle = .none
        
        oldpwd.placeholder = "请输入旧密码"
        newpwd.placeholder = "请输入新密码"
        newpwd2.placeholder = "请再一次输入新密码"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            oldpwd.resignFirstResponder()
            newpwd.resignFirstResponder()
            newpwd2.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func clickSaveBtn(){
        print("====save======")
    }
}

