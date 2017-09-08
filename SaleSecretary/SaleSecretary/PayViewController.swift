//
//  PayViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/12.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class PayViewController: UIViewController {
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
    var PayCount = [1:"￥0.00",2:"￥0.00",3:"￥0.00",4:"￥0.00",5:"￥0.00",6:"￥0.00"]
    let smsCount = [1:"100条",2:"200条",3:"500条",4:"1000条",5:"1500条",6:"2000条"]
    var TaocanId = [1:"",2:"",3:"",4:"",5:"",6:""]
    
    @IBAction func clickbutton1(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn1_label1.textColor = UIColor.white
        btn1_label2.textColor = UIColor.white
        changeMoney(1)
    }
    @IBAction func clickbutton2(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn2_label1.textColor = UIColor.white
        btn2_label2.textColor = UIColor.white
        changeMoney(2)
    }
    @IBAction func clickbutton3(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn3_label1.textColor = UIColor.white
        btn3_label2.textColor = UIColor.white
        changeMoney(3)
    }
    @IBAction func clickbutton4(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn4_label1.textColor = UIColor.white
        btn4_label2.textColor = UIColor.white
        changeMoney(4)
    }
    @IBAction func clickbutton5(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn5_label1.textColor = UIColor.white
        btn5_label2.textColor = UIColor.white
        changeMoney(5)
    }
    @IBAction func clickbutton6(_ sender: UIButton) {
        changeButtonColor(UIColor.white.cgColor)
        sender.layer.backgroundColor = APP_THEME_COLOR.cgColor
        btn6_label1.textColor = UIColor.white
        btn6_label2.textColor = UIColor.white
        changeMoney(6)
    }
    @IBAction func clickConfirm(_ sender: UIButton) {
        if self.currentSel == 0{
            let alertController = UIAlertController(title: "提示", message: "请选择充值金额", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let ipAddress = getIPAddress()
        if ipAddress == nil{
            let alertController = UIAlertController(title: "提示", message: "网络错误，请稍候再试", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let body = ["dxtcbId":self.TaocanId[self.currentSel]!, "paymentMethod":"0", "userId":APP_USER_ID, "spbillCreateIp":ipAddress!, "tradeType":"APP"]
        let request = NetworkUtils.postBackEnd("C_ME_DXCZ", body: body) {
            json in
            print(json)
            }
        request.response(completionHandler: { _ in
        
        })
        
//        wechatPay(WeixinPayModel(appID: "wx3cd741c2be80a27d", noncestr: "Hk8dsZoMOdTXGjkJ", package: "Sign=WXPay", partnerID: "1220000000", prepayID: "wx2016020000000000000000000000", sign: "B4879FFFA8B65522A04034E2D027A3B8", timestamp: Int(Date().timeIntervalSince1970)))
    }
    
    func changeButtonColor(_ color:CGColor){
        for btn in buttons{
            btn.layer.backgroundColor = color
        }
        for label in labels{
            label.textColor = APP_THEME_COLOR
        }
    }
    
    // 获取IP地址
    func getIPAddress() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
    
    //微信支付
    func wechatPay(_ model:WeixinPayModel)
    {
        let req = PayReq()
        req.partnerId = model.partnerID
        req.prepayId = model.prepayID
        req.nonceStr = model.noncestr
        req.timeStamp = UInt32(model.timestamp)
        req.package = model.package
        req.sign = model.sign
        WXApi.send(req)
        
    }
    
    func changeMoney(_ index:Int){
        self.currentSel = index
        let cell = self.tableView.cellForRow(at: [0, 0])
        cell?.detailTextLabel?.text = self.PayCount[index]
        cell?.detailTextLabel?.textColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = UIView(frame:CGRect(x: 0,y: 65,width: UIScreen.main.bounds.size.width,height: 200))
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        self.view.sendSubview(toBack: bgView)
        
        buttons = [button1, button2, button3, button4, button5, button6]
        labels = [btn1_label1, btn1_label2, btn2_label1, btn2_label2, btn3_label1, btn3_label2, btn4_label1, btn4_label2, btn5_label1, btn5_label2, btn6_label1, btn6_label2]
        
        for (index,btn) in buttons.enumerated(){
            btn.layer.borderColor = APP_THEME_COLOR.cgColor
            btn.setTitle("\(smsCount[index+1]!)", for: .normal)
            btn.setTitleColor(APP_THEME_COLOR, for: .normal)
            btn.isEnabled = false
        }
        
        for label in labels{
            label.isHidden = true
        }
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loading()
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["pageSize": "6"]
            let request = NetworkUtils.postBackEnd("R_PAGED_QUERY_ME_DXTCB", body: body) {
                json in
                let jsondata = json["body"]["obj"]
                self.showLabel(jsondata: jsondata)
                
                for label in self.labels{
                    label.isHidden = false
                }
                for btn in self.buttons{
                    btn.isEnabled = true
                    btn.setTitle("", for: .normal)
                }
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    func showLabel(jsondata:JSON){
        for (idx, data) in jsondata.array!.enumerated(){
            let i = Int(data["numXs"].stringValue)! + Int(data["numZs"].stringValue)!
            labels[idx * 2].text = "\(i)条"
            let f = Float(data["price"].stringValue)!
            labels[idx * 2 + 1].text = "售价\(String(format: "%.2f", f))元"
            self.PayCount[idx+1] = "￥\(String(format: "%.2f", f))"
            self.TaocanId[idx+1] = data["id"].stringValue
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PayViewController: UITableViewDelegate, UITableViewDataSource {
    
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
