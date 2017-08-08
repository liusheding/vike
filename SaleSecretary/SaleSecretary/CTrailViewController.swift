//
//  CTrailViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTrailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        NSLog("This is trailview")
        // Do any additional setup after loading the view.
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
//        let dataCell = [data.userInfo.name , data.userInfo.phone_number , data.userInfo.icon , data.userInfo.nick_name , data.userInfo.time]
//        switch indexPath.section {
//        case 0:
//            let i = indexPath.row
//            cell.textLabel?.text = self.infoPate[i]
//            cell.detailTextLabel?.text = dataCell[i]
//        case 1:
//            cell.textLabel?.text = "称谓"
//            cell.detailTextLabel?.text = "xxxx"
//        case 2:
//            cell.textLabel?.text = "分组"
//            cell.detailTextLabel?.text = "9999"
//        case 3:
//            cell.textLabel?.text = "删除"
//            cell.detailTextLabel?.text = "delete"
//        default:
//            cell.textLabel?.text = "ssss"
//        }
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

