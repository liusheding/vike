//
//  RegisterViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/16.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var smsCheck: UITextField!
    @IBOutlet weak var recommendCode: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var smsBtn: UIButton!
    
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
        name.borderStyle = .none
        name.placeholder = "姓名"
        password.borderStyle = .none
        password.placeholder = "密码"
        password.isSecureTextEntry=true
        smsCheck.borderStyle = .none
        smsCheck.placeholder = "短信验证码"
        recommendCode.borderStyle = .none
        recommendCode.placeholder = "推荐码"
        
        phone.delegate = self
        smsCheck.delegate = self
        
        // 创建一个导航栏
        let navBar = UINavigationBar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:60))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.groupTableViewBackground
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "注册"
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
       
        // 创建左侧按钮
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(clickCancelBtn))
        leftButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName: UIColor.darkGray],for: .normal)
        
        // 添加左侧按钮
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phone.resignFirstResponder()
            name.resignFirstResponder()
            password.resignFirstResponder()
            smsCheck.resignFirstResponder()
            recommendCode.resignFirstResponder()
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
    
    @IBAction func registerUser(_ sender: UIButton) {
        sender.isEnabled = false
        let phoneValue = phone.text!
        let pwdValue = password.text!
        let nameValue = name.text!
        let sms = smsCheck.text!
        if !Utils.isTelNumber(num: phoneValue) || pwdValue == "" || nameValue == "" {
            alert("请填写正确的手机号、姓名及密码")
            sender.isEnabled = true
            return
        }
        // 校验短信
        if sms.characters.count != 6 {
            alert("请输入6位短信校验码长")
            sender.isEnabled = true
            return
        }
        
        let checkBody = ["busi_code": "REGISTER", "cellphone_number": phoneValue, "sms_code": sms]
        let checkReq = NetworkUtils.postBackEnd("R_SMSCODE_CHECK", body: checkBody, handler: {
            json in
            print(json)
        })
        let body = ["busi_scene": "REGISTER", "cellphoneNumber": phoneValue, "loginPwd": pwdValue, "name": nameValue]
        
        let request = NetworkUtils.postBackEnd("C_USER", body: body , handler: {[weak self] (val ) in
            let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "注册成功，正在登录中"
            let id = val["body"]["id"].stringValue
            APP_USER_ID = id
            UserDefaults.standard.setValue(id, forKey: "APP_USER_ID")
            UserDefaults.standard.synchronize()
            
            let r = AppUser.loadFromServer() { (user) in
                AppUser.currentUser = user
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainID")
                do {
                    UIApplication.shared.delegate?.window??.rootViewController = mainVC
                } catch {
                    print(error)
                }
            }
            r?.response(completionHandler: {_ in
                hub.hide(animated: true)
            })
        })
        request.response(completionHandler: {_ in
            sender.isEnabled = true
            
        })
    }
    
    @IBAction func smsCode(_ sender: UIButton) {
        let phoneValue:String = phone.text!
        if !Utils.isTelNumber(num: phoneValue) {
            self.alert("请填写正确的手机号")
            return
        }
        // 短信发送
        let _ = NetworkUtils.postBackEnd("C_SMSCODE_SEND", body: ["busi_code": "REGISTER", "cellphone_number": phoneValue], handler: {
            json in
            self.isCounting = true
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alert(_ msg: String) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        self.present(uc, animated: true, completion: nil)
        return
    }
    
    func countingDown() {
        self.remaining -= 1
    }
}
