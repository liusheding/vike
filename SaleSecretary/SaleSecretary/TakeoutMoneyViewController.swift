//
//  TakeoutMoneyViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class TakeoutMoneyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastmoney: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var banknum: UITextField!
    @IBAction func clickTakeAll(_ sender: UIButton) {
        textfield.text = lastmoney.text
    }
    @IBAction func clickSubmit(_ sender: UIButton) {
        let bankstr = banknum.text!
        if bankstr == ""{
            showAlert("请填写本人银行卡号")
            return
        }
        let bankarray = bankstr.components(separatedBy: ".")
        if bankarray.count != 0{
            showAlert("请填写正确的银行卡号")
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
        
        banknum.borderStyle = .none
        banknum.keyboardType = .decimalPad
        banknum.becomeFirstResponder()
        banknum.placeholder = "请输入本人银行卡号"
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension TakeoutMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "payCell")
        cell.textLabel?.text = "仅限使用本人银行卡提现"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.text = "查看可支持银行"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}
