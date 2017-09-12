//
//  WalletViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class WalletViewController: UIViewController {
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var award: UILabel!
    @IBOutlet weak var getout: UILabel!
    
    @IBAction func takeoutbtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "MineView", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "takeoutID")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                self.remain.text = "￥" + jsondata["bonusKy"].stringValue
                self.award.text = "￥" + jsondata["bonusLj"].stringValue
                self.getout.text = "￥" + jsondata["bonusLjtx"].stringValue
            }
            request.response(completionHandler: { _ in
                hud.hide(animated: true)
            })
        }
    }
}
