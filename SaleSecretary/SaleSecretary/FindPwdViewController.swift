//
//  FindPwdViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/16.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class FindPwdViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    @IBOutlet weak var smsCheck: UITextField!
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.clickCancelBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
        phone.borderStyle = .none
        phone.placeholder = "手机号"
        password.borderStyle = .none
        password.placeholder = "重置密码"
        confirmPwd.borderStyle = .none
        confirmPwd.placeholder = "确认密码"
        password.isSecureTextEntry=true
        confirmPwd.isSecureTextEntry=true
        smsCheck.borderStyle = .none
        smsCheck.placeholder = "短信验证码"
        
        phone.delegate = self
        smsCheck.delegate = self
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phone.resignFirstResponder()
            password.resignFirstResponder()
            confirmPwd.resignFirstResponder()
            smsCheck.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        if phone == textField{
            //限制只能输入数字，不能输入特殊字符
            for loopIndex in 0..<length {
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 { return false }
                if char > 57 { return false }
            }
            //限制长度11
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            if proposeLength > 11 { return false }
            return true
        }
        else if smsCheck == textField{
            //限制只能输入数字，不能输入特殊字符
            for loopIndex in 0..<length {
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 { return false }
                if char > 57 { return false }
            }
            //限制长度6
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            if proposeLength > 6 { return false }
            return true
        }
        return true
    }
    
    func clickCancelBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
