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
        
        oldpwd.isSecureTextEntry = true
        newpwd.isSecureTextEntry = true
        newpwd2.isSecureTextEntry = true
        
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
        let oldpwdtext = oldpwd.text
        if oldpwdtext == ""{
            showAlert("请输入原始密码")
            return
        }
        let newpwdtext = newpwd.text
        let newpwd2text = newpwd2.text
        if newpwdtext == "" || newpwd2text == ""{
            showAlert("请输入新密码")
            return
        }
        if newpwd.text != newpwd2.text{
            showAlert("两次输入密码不一致")
            return
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let body = ["busi_scene":"MODIFY_PWD", "id": APP_USER_ID, "originalPwd":oldpwdtext, "loginPwd":newpwdtext]
        let request = NetworkUtils.postBackEnd("U_USER", body: body , handler: {[weak self] (val ) in
            self?.showAlert("密码修改成功，请重新登录")
            AppUser.logout()
        })
        request.response(completionHandler: {_ in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
