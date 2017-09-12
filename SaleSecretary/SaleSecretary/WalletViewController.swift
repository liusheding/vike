//
//  WalletViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

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
        self.remain.text = "￥" + (AppUser.currentUser?.body?["bonusKy"].stringValue)!
        self.award.text = "￥" + (AppUser.currentUser?.body?["bonusLj"].stringValue)!
        self.getout.text = "￥" + (AppUser.currentUser?.body?["bonusLjtx"].stringValue)!
    }
}
