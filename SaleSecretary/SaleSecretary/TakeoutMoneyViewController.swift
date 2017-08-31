//
//  TakeoutMoneyViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TakeoutMoneyViewController: UIViewController {
    @IBOutlet weak var lastmoney: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBAction func clickTakeAll(_ sender: UIButton) {
        textfield.text = lastmoney.text
    }
    @IBAction func clickSubmit(_ sender: UIButton) {
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
        textfield.becomeFirstResponder()
        
        // 创建一个导航栏
        let navBar = UINavigationBar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:60))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.groupTableViewBackground
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "提现"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        // 创建左侧按钮
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(clickCancelBtn))
        leftButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName: APP_THEME_COLOR],for: .normal)
        
        // 添加左侧按钮
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickCancelBtn(){
        self.dismiss(animated: true, completion: nil)
    }

}
