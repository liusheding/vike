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
    
    @IBOutlet weak var findBtn: UIButton!
    
    @IBOutlet weak var smsBtn: UIButton!
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.clickCancelBtn()
    }
    
    var timer: Timer?
    
    var remaining: Int = 0 {
        
        willSet {
            if newValue <= 0 {
                self.smsBtn.isEnabled = true
                self.smsBtn.setTitle("获取验证码", for: .normal)
                self.isCounting = false
            } else {
                self.smsBtn.isEnabled = false
                // self.smsBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                self.smsBtn.titleLabel?.text = "剩余\(newValue)秒"
                self.smsBtn.setTitle("剩余\(newValue)秒", for: .disabled)
            }
        }
    }
    
    var isCounting: Bool = false {
        
        willSet {
            if newValue {
                // 计时器
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("countingDown")), userInfo: nil, repeats: true)
                remaining = 60
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
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
        findBtn.isEnabled = false
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func resignFirstResponders() {
        phone.resignFirstResponder()
        password.resignFirstResponder()
        confirmPwd.resignFirstResponder()
        smsCheck.resignFirstResponder()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.resignFirstResponders()
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func sendSMS(_ sender: UIButton) {
        let vals = [phone, password, confirmPwd, smsCheck].flatMap({$0?.text!.trimmingCharacters(in: .whitespaces)})
        if !Utils.isTelNumber(num: vals[0]) {
            Utils.alert("手机号码非法")
            return
        }
        // 短信发送
        let _ = NetworkUtils.postBackEnd("C_SMSCODE_SEND", body: ["busi_code": "RETRIEVE_PWD", "cellphone_number": vals[0]], handler: {
            json in
            
            self.isCounting = true
        })
        self.findBtn.isEnabled = true
    }
    
    @IBAction func findBtnAction(_ sender: UIButton) {
        self.resignFirstResponders()
        let vals = [phone, password, confirmPwd, smsCheck].flatMap({$0?.text!.trimmingCharacters(in: .whitespaces)})
        if !self.checkVal(vals: vals) {return}
        let checkBody = ["busi_code": "RETRIEVE_PWD", "cellphone_number": vals[0], "sms_code": vals[3]]
        self.findBtn.isEnabled = false
        let r = NetworkUtils.postBackEnd("R_SMSCODE_CHECK", body: checkBody, handler: {
            json in
            let req = AppUser.findPassword(phone: vals[0], password: vals[1], callback: {[weak self]
                _ in
                self?.dismiss(animated: true, completion: {
                     Utils.alert("修改密码成功")
                })
            })
        })
        r.response(completionHandler: { _ in
            self.findBtn.isEnabled = true
        })
        
    }
    
    func checkVal(vals: [String]) -> Bool {
        if vals.contains("") {
            Utils.alert("手机号、密码、确认密码及验证码，不能为空")
            return false
        }
        if !Utils.isTelNumber(num: vals[0]) {
            Utils.alert("手机号码非法")
            return false
        }
        if vals[1] != vals[2] {
            Utils.alert("请输入相同的密码")
            return false
        }
        return true
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
    
    func countingDown() {
        self.remaining -= 1
    }
}
