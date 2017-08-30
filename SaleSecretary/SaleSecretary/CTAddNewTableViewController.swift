//
//  CTAddNewTableViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/9.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTAddNewTableViewController: UITableViewController {

    let cellId = "addCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        self.tableView.register( UINib(nibName: "AddNewCustomerCell", bundle: nil) , forCellReuseIdentifier: cellId)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("create dyn table")
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier:  cellId)
        cell.textLabel?.text = "新的客户"
        cell.imageView?.image = UIImage(named: "pic_xkh")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailPage = self.storyboard?.instantiateViewController(withIdentifier: "newAddCustomer") as! CTChooseNewerController
        
//        detailPage.tableText = indexPath.row
        tableView.deselectRow(at: indexPath, animated: false)
        self.navigationController?.pushViewController(detailPage, animated: true)
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
