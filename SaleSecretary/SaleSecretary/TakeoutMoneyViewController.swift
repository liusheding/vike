//
//  TakeoutMoneyViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class TakeoutMoneyViewController: UIViewController {
    var cardid:String?
    
    @IBOutlet weak var takebtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastmoney: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBAction func clickTakeAll(_ sender: UIButton) {
        textfield.text = lastmoney.text
    }
    @IBAction func clickSubmit(_ sender: UIButton) {
        let cell = self.tableView.cellForRow(at: [0,0])
        let bankstr = cell?.textLabel?.text
        if bankstr == "选择到账银行卡" || cardid == nil || cardid == ""{
            showAlert("请选择到账银行卡")
            return
        }
        
        let str = textfield.text!
        if str == ""{
            showAlert("请填写提现金额")
            return
        }
        let startindex = str.index(str.startIndex, offsetBy: 1)
        let startchar = str.substring(to: startindex)
        
        let endindex = str.index(str.endIndex, offsetBy: -1)
        let endchar = str.substring(from: endindex)
        
        let array = str.components(separatedBy: ".")
        if startchar == "." || endchar == "." || array.count > 2{
            showAlert("请填写正确的金额")
            return
        }
        
        if (str as NSString).floatValue > (lastmoney.text! as NSString).floatValue{
            showAlert("余额不足")
            return
        }
        
        self.checkCodeAlert()
        self.takebtn.isEnabled = false
        let body = ["txje":str, "userId": APP_USER_ID, "kbId":cardid]
        let request = NetworkUtils.postBackEnd("C_ME_TXMX", body: body , handler: {[weak self] (val ) in
            let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "提现申请提交成功"
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                hub.hide(animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
        })
        request.response(completionHandler: {_ in
            self.takebtn.isEnabled = true
        })
        
    }
    
    func checkCodeAlert(){
        let alertController = UIAlertController(title: "系统提示",
                                                message: "已发送短信验证码至银行预留手机号", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请输入短信验证码"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let code = alertController.textFields!.first!
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.borderStyle = .none
        textfield.keyboardType = .decimalPad
        textfield.placeholder = "请输入提现金额"
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
         //创建右侧按钮
        let rightButton = UIBarButtonItem(title: "银行卡管理", style: .plain, target: self, action: #selector(clickCardBtn))
        self.navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastmoney.text = (AppUser.currentUser?.body?["bonusKy"].stringValue)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickCardBtn(){
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "cardmanageID")
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension TakeoutMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "takeCell")
        cell.textLabel?.text = "选择到账银行卡"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.darkGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "choosecardID") as! ChooseCardController
        controller.rootView = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
