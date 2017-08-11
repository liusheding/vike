//
//  OnlinePayController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class OnlinePayController: UIViewController {
    @IBAction func clickbutton1(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn1_label1.textColor = UIColor.white
        btn1_label2.textColor = UIColor.white
        changeMoney(0)
    }
    @IBAction func clickbutton2(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn2_label1.textColor = UIColor.white
        btn2_label2.textColor = UIColor.white
        changeMoney(1)
    }
    @IBAction func clickbutton3(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn3_label1.textColor = UIColor.white
        btn3_label2.textColor = UIColor.white
        changeMoney(2)
    }
    @IBAction func clickbutton4(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn4_label1.textColor = UIColor.white
        btn4_label2.textColor = UIColor.white
        changeMoney(3)
    }
    @IBAction func clickbutton5(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn5_label1.textColor = UIColor.white
        btn5_label2.textColor = UIColor.white
        changeMoney(4)
    }
    @IBAction func clickbutton6(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn6_label1.textColor = UIColor.white
        btn6_label2.textColor = UIColor.white
        changeMoney(5)
    }
    @IBAction func clickConfirm(_ sender: UIButton) {
        print("=====\(self.currentSel)")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var btn1_label1: UILabel!
    @IBOutlet weak var btn1_label2: UILabel!
    @IBOutlet weak var btn2_label1: UILabel!
    @IBOutlet weak var btn2_label2: UILabel!
    @IBOutlet weak var btn3_label1: UILabel!
    @IBOutlet weak var btn3_label2: UILabel!
    @IBOutlet weak var btn4_label1: UILabel!
    @IBOutlet weak var btn4_label2: UILabel!
    @IBOutlet weak var btn5_label1: UILabel!
    @IBOutlet weak var btn5_label2: UILabel!
    @IBOutlet weak var btn6_label1: UILabel!
    @IBOutlet weak var btn6_label2: UILabel!
    
    var buttons:[UIButton]!
    var labels:[UILabel]!
    var currentSel:Int = 0
    let PayCells = ["支付金额","支付方式"]
    let PayCount = [0:"￥10.00",1:"￥20.00",2:"￥30.00",3:"￥49.00",4:"￥95.00",5:"￥188.00"]
    
    func changeButtonColor(_ color:CGColor){
        for btn in buttons{
            btn.layer.backgroundColor = color
        }
        for label in labels{
            label.textColor = APP_THEME_COLOR
        }
    }
    
    
    func changeMoney(_ index:Int){
        self.currentSel = index
        let cell = self.tableView.cellForRow(at: [0, 0])
        cell?.detailTextLabel?.text = self.PayCount[index]
        cell?.detailTextLabel?.textColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button1, button2, button3, button4, button5, button6]
        labels = [btn1_label1, btn1_label2, btn2_label1, btn2_label2, btn3_label1, btn3_label2, btn4_label1, btn4_label2, btn5_label1, btn5_label2, btn6_label1, btn6_label2]
        
        for btn in buttons{
            (btn as AnyObject).layer.borderColor = APP_THEME_COLOR.cgColor
        }
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OnlinePayController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PayCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "payCell")
        cell.textLabel?.text = self.PayCells[indexPath.row]
        if indexPath.row == 0{
            cell.detailTextLabel?.text = "￥0.00"
            cell.detailTextLabel?.textColor = UIColor.red
        }else{
            cell.detailTextLabel?.text = "微信支付"
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
}
