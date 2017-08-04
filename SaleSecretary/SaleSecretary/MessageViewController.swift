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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    //处理选中事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        print("选中的Cell 为\(indexPath.row)")
        self.hidesBottomBarWhenPushed = true
        let cell = self.tableView.cellForRow(at: indexPath) as! MessageListCell
        print("\(cell.cellname.text!)")
        
        if (cell.cellname.text! == "指尖刘总"){
            self.navigationController?.pushViewController(MessageChatController(), animated: true)
            self.hidesBottomBarWhenPushed = false
            return
        }
       
        let controller = MessageDetailController()
        controller.aa = indexPath.row
        self.navigationController?.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    //返回编辑类型，滑动删除
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //修改删除按钮的文字
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //点击删除按钮的响应方法，处理删除的逻辑
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.Names.remove(at: indexPath.row)
            self.Phones.remove(at: indexPath.row)
            self.Times.remove(at: indexPath.row)
            self.Images.remove(at: indexPath.row)
            self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }

    }

}
