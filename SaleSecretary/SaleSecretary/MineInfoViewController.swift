//
//  MineInfoViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/24.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class MineInfoViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var job: UITextField!
    @IBOutlet weak var invite: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        name.borderStyle = .none
        phone.borderStyle = .none
        job.borderStyle = .none
        
        name.textColor = UIColor.darkGray
        phone.textColor = UIColor.darkGray
        job.textColor = UIColor.darkGray
        
        phone.isEnabled = false
        job.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = AppUser.currentUser
        phone.text = user?.cellphoneNumber
        job.text = user?.role?.rawValue
        invite.text = user?.referralCode
        loading()
        
    }
    
    func loading(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载中..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let body = ["busi_scene":"USER_INFO", "id": APP_USER_ID]
            let request = NetworkUtils.postBackEnd("R_BASE_USER", body: body) {
                json in
                let jsondata = json["body"]
                self.name.text = jsondata["name"].stringValue
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            name.resignFirstResponder()
            phone.resignFirstResponder()
            job.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func clickSaveBtn(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let nametext = name.text!
        let body = ["busi_scene":"USERINFO_MDF", "id": APP_USER_ID, "name":nametext]
        let request = NetworkUtils.postBackEnd("U_USER", body: body , handler: {[weak self] (val ) in
            let hub = MBProgressHUD.showAdded(to: (self?.view)!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "资料修改成功"
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                hub.hide(animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
        })
        request.response(completionHandler: {_ in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })
    }

}
