//
//  MineInfoViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/24.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

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
        name.text = "指尖小王"
        phone.text = "12345678901"
        job.text = "业务员"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
        
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
        print("====save======")
    }

}
