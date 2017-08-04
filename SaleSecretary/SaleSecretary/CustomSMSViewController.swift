//
//  CustomSMSViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/4.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


class CustomSMSViewController : UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previewBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewBtn.layer.cornerRadius = 5.0
    }
}


extension CustomSMSViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
