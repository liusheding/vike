//
//  SMSUIViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/7/28.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Foundation

class SMSUIViewController : UIViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    
    lazy var tableView : UITableView =  {
        var t = UITableView()
        t.dataSource = self
        t.delegate = self
        t.tableFooterView = UIView()
        t.backgroundColor = UIColor.groupTableViewBackground
        return t
    }()
    
}

extension SMSUIViewController  {
    fileprivate  func setUp() {
        
    }
}

extension SMSUIViewController : UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
