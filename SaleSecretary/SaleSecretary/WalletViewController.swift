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
        self.present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.remain.text = "￥580"
        self.award.text = "￥100"
        self.getout.text = "￥50"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
