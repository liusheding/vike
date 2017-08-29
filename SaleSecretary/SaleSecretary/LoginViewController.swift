//
//  LoginViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/15.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    // @IBOutlet weak var checknum: UITextField!
    
    @IBAction func loginbtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainID")
        sender.isEnabled = false
        if let phoneValue = phone.text, let pwd = password.text {
            let request = AppUser.login(phone: phoneValue, password: pwd) {
                user in
                AppUser.currentUser = user
                UserDefaults.standard.setValue(user.id!, forKey: "APP_USER_ID")
                UserDefaults.standard.synchronize()
                APP_USER_ID = user.id!
                UIApplication.shared.delegate?.window??.rootViewController = mainVC
            }
            request?.response(completionHandler: {_ in sender.isEnabled = true})
        } else {
            return
        }
        // self.present(mainVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        phone.borderStyle = .none
        phone.placeholder = "手机号"
        password.borderStyle = .none
        password.placeholder = "密码"
        password.isSecureTextEntry=true
        // checknum.borderStyle = .none
        
        phone.delegate = self
        password.delegate = self
        // checknum.delegate = self
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phone.resignFirstResponder()
            password.resignFirstResponder()
            // checknum.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        if phone == textField {
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
        } else if password == textField {
            //限制只能输入数字或字母，不能输入特殊字符
//            for loopIndex in 0..<length {
//                let char = (string as NSString).character(at: loopIndex)
//                if char < 48 { return false }
//                if char > 57 && char < 65 { return false }
//                if char >= 91 && char <= 112 {return false }
//                if char >= 123 {return false }
//            }
            return true
//        
//        } else if checknum == textField {
//            //限制只能输入数字或字母，不能输入特殊字符
//            for loopIndex in 0..<length {
//                let char = (string as NSString).character(at: loopIndex)
//                if char < 48 { return false }
//                if char > 57 && char < 65 { return false }
//                if char >= 91 && char <= 112 {return false }
//                if char >= 123 {return false }
//            }
//            //限制长度4
//            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
//            if proposeLength > 4 { return false }
//            return true
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
