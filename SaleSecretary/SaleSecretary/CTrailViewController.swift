//
//  CTrailViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTrailViewController: UIViewController {

    @IBOutlet weak var trailTableView: UITableView!
    
    
    let trailCell = "trailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailTableView.delegate = self
        self.trailTableView.dataSource = self
        
        self.trailTableView.register( UINib(nibName: String(describing: PersonContactCell.self ), bundle: nil) , forCellReuseIdentifier: self.trailCell )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension CTrailViewController : UITableViewDelegate , UITableViewDataSource {
    
    // required
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let parentView = self.parent as! CTCustomerDetailInfoViewController
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        return cell
    }
    
    func createCTInfoCell(indexPath:IndexPath , data : CTCustomerDetailInfoViewController ) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 5
        }else {
            return 1
        }
    }
    // end of required
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 4
    }
}

