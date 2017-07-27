//
//  MessageViewController.swift
//  SaleSecretary
//
//  Created by 肖强 on 2017/7/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {
    var Names:[String] = ["指尖刘总","待执行计划","消息通知"]
    var Phones:[String] = ["12345678901","还有3个计划等待您执行","您有1条通知消息等待查看"]
    var Times:[String] = ["2017-7-24 12:45","2017-7-23 09:30","2017-7-22 23:09"]
    var Images:[String] = ["pic_xx_hf.png","pic_xx_dzx.png","pic_xx_tz.png"]
    
    let cellId = "MessageListID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: MessageListCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        
//        self.tableView.register(MessageListCell.self, forCellReuseIdentifier: "MessageListID")
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageListCell
        cell.cellname.text = self.Names[indexPath.row]
        cell.cellphone.text = self.Phones[indexPath.row]
        cell.celltime.text = self.Times[indexPath.row]
        cell.cellimage.image = UIImage(named: self.Images[indexPath.row])
        return cell
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
