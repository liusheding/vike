//
//  ContactViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/7/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {

    @IBOutlet weak var tableViewContent: UITableView!
    
    var tableSource = ["great" , "person"];
    
    let contactsCell = "contactCellId"
    
    private var contactsCells = [
        0: [["label": "短信计划", "image": "icon_gj_dxjh", "id":"dxjg"]],
        1: [["label": "名片扫描", "image": "icon_gj_mpsm", "id":"mpsm"], ["label": "二维码名片", "image": "icon_gj_ewmmp", "id":"ewmmp"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableViewContent.register( UINib(nibName: String(describing: ToolCellView.self), bundle: nil) , forCellReuseIdentifier: contactsCell)
//      NSLog("xxxx")
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        NSLog("cell for row . ")
        let secNum = indexPath.section
        // _ = curIdx(sec: secNum)
        let rowNo = indexPath.row
        let dict = self.contactsCells[secNum]?[rowNo]
        let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell, for: indexPath) as! ToolCellView
        cell.toolImage.image = UIImage(named: (dict!["image"]!))
        cell.toolLabel.text = dict!["label"]
        
        return cell;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = self.tableView.cellForRow(at: indexPath)
        print("\(String(describing: selectedRow))")
        // print(selectedRow?.value(forKey: "id"))
        self.navigationController?.pushViewController(SMSUIViewController(), animated: false)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 20
        }
        
    }


}
