//
//  AddCardController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/9/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddCardController: UIViewController, UITextFieldDelegate {
    var isadd:Bool? //true:添加银行卡 false:修改银行卡
    var cardid:String?
    
    @IBOutlet weak var bankbranch: UITextField!
    @IBOutlet weak var cardphone: UITextField!
    @IBOutlet weak var bankname: UITextField!
    @IBOutlet weak var cardname: UITextField!
    @IBOutlet weak var cardnum: UITextField!
    @IBAction func clickSubmitBtn(_ sender: UIButton) {
        let cardnumtext = cardnum.text!
        let cardnametext = cardname.text!
        let banknametext = bankname.text!
        let bankbranchtext = bankbranch.text!
        let cardphonetext = cardphone.text!
        
        if cardnumtext == ""{
            self.showAlert("银行卡号不能为空")
            return
        }
        
        if cardnumtext.characters.count < 16{
            self.showAlert("银行卡号不合法")
            return
        }
        
        if cardnametext == ""{
            self.showAlert("持卡人姓名不能为空")
            return
        }

        if banknametext == ""{
            self.showAlert("开户银行不能为空")
            return
        }
        
        if bankbranchtext == ""{
            self.showAlert("开户支行不能为空")
            return
        }

        if cardphonetext == ""{
            self.showAlert("银行预留电话不能为空")
            return
        }
        if self.isadd == true{
            let body = ["type":"2", "cardNumber":cardnumtext, "cardholder":cardnametext, "cellphoneNumber":cardphonetext, "bankName":banknametext, "bankBranch":bankbranchtext, "userId":APP_USER_ID]
            
            let request = NetworkUtils.postBackEnd("C_ME_KB", body: body , handler: {[weak self] (val ) in
                let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
                hub.mode = MBProgressHUDMode.text
                hub.label.text = "绑定银行卡成功"
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    hub.hide(animated: true)
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            request.response(completionHandler: {_ in
            })
        }else{
            let body = ["type":"2", "cardNumber":cardnumtext, "cardholder":cardnametext, "cellphoneNumber":cardphonetext, "bankName":banknametext, "bankBranch":bankbranchtext, "id":cardid]
            
            let request = NetworkUtils.postBackEnd("U_ME_KB", body: body , handler: {[weak self] (val ) in
                let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
                hub.mode = MBProgressHUDMode.text
                hub.label.text = "修改银行卡成功"
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    hub.hide(animated: true)
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            request.response(completionHandler: {_ in
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cardnum.borderStyle = .none
        cardname.borderStyle = .none
        bankname.borderStyle = .none
        bankbranch.borderStyle = .none
        cardphone.borderStyle = .none
        
        cardphone.delegate = self
        cardnum.delegate = self
        
        cardnum.keyboardType = .decimalPad
        cardphone.keyboardType = .decimalPad
        
        if self.isadd == true{
            self.navigationItem.title = "添加银行卡"
        }else{
            self.navigationItem.title = "修改银行卡"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isadd == true{
            cardnum.placeholder = "卡号"
            cardname.placeholder = "持卡人"
            bankname.placeholder = "开户银行"
            bankbranch.placeholder = "开户分行"
            cardphone.placeholder = "银行预留手机号"
        }else{
            loading()
        }
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["id": self.cardid]
            let request = NetworkUtils.postBackEnd("R_BASE_ME_KB", body: body) {
                json in
                let jsondata = json["body"]
                // 构造数据
                self.cardnum.text = jsondata["cardNumber"].stringValue
                self.cardname.text = jsondata["cardholder"].stringValue
                self.bankname.text = jsondata["bankName"].stringValue
                self.bankbranch.text = jsondata["bankBranch"].stringValue
                self.cardphone.text = jsondata["cellphoneNumber"].stringValue
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(_ msg: String) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
        self.present(uc, animated: true, completion: nil)
        return
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        if cardphone == textField {
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
        }else if cardnum == cardnum{
            //限制只能输入数字，不能输入特殊字符
            for loopIndex in 0..<length {
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 { return false }
                if char > 57 { return false }
            }
            return true
        }
        return true
    }

}
