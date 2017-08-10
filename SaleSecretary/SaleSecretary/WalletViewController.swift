//
//  WalletViewController.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var award: UILabel!
    @IBOutlet weak var getout: UILabel!
    
    @IBAction func takeoutbtn(_ sender: UIButton) {
        print("22222222")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.remain.text = "￥580"
        self.award.text = "￥100"
        self.getout.text = "￥50"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
