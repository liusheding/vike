//
//  ContactTableViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ContactTableViewController: UIViewController {

    let headIdentifier = "headView"
    let cellId = "TableViewCell"
    
    let sectionOne = ["name": "新的客户", "icon": "pic_xkh", "id":"dxjg" , "count" : "0"]
//    let sectionOne = ["name": "新的客户", "friends": "" , "count" : "0" , "isOpen": false] as [String : Any]
    let sectionTwo = [ ["name": "默认" , "friends":[["name": "刘一斌", "icon": "icon_gj_mpsm", "id":"mpsm" , "phone_number":"13899936668"],
                                                      ["name": "刘总", "icon": "icon_gj_ewmmp", "id":"ewmmp" , "phone_number":"13899936556"]],
                        "count": 2 ,  "isOpen": false ] ,
                       ["name": "意向客户" , "friends":[["name": "马云", "icon": "icon_gj_mpsm", "id":"mpsm" , "phone_number":"13899936668"],
                                                            ["name": "马总","icon": "icon_gj_ewmmp", "id":"ewmmp","phone_number":"13899936556"]],
                        "count": 2 ,  "isOpen": false]
    ]
    
    
    /*
     * 构造数据 [ 0 : A , 1: B ] B:[ 0: a , 1: b ]
     */
    lazy var contactsCells:[CustomerGroup] =  {
//        var array = [CustomerGroup]()
//        let p : CustomerGroup = CustomerGroup.init(dict: self.sectionOne as [String : AnyObject])
//        array.append(p)
//        
//        // init group array
//        let tmp = self.sectionTwo as NSArray
//        for item in tmp  {
//            let i : CustomerGroup = CustomerGroup.init( dict: item as! [String : AnyObject] )
//            array.append(p)
//        }
//        return array
        var friendsModelArray = [CustomerGroup]()
        friendsModelArray = CustomerGroup.dictModel()
        return friendsModelArray
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NSLog("ContactTableviewController init !")
        self.tableView.register( TableViewCell.self , forCellReuseIdentifier: cellId)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ContactTableViewController : UITableViewDataSource, UITableViewDelegate , LSHeaderViewDelegate {

   
    // 每次点击headerView时，改变group的isOpen参数，然后刷新tableview，显示或者隐藏好友信息
    func headerViewDidClickedNameView(headerView: CustomerHeaderView) {
        self.tableView.reloadData()
    }
 
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(60)
//    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.contactsCells.count
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let group = self.contactsCells[section]
        NSLog("numberOfRowsInSection \(String(describing: group.name))")
    
        if group.isOpen! {
            return (group.friends?.count)!
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let secNum = indexPath.section
        let rowNo = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
        NSLog("---------\(indexPath)")
        let group = self.contactsCells[ secNum ]
        let customer = group.friends?[ rowNo ] as? Customer
        
        cell.textLabel?.text = customer?.name
        cell.detailTextLabel?.text = customer?.phone_number
        cell.imageView?.image = UIImage(named: (customer?.icon)!)
            
        return cell
    }
    
    func clickedGroupTitle(headerView: CustomerHeaderView) {
        NSLog(" clickGroupTitle")
        let section = NSIndexSet.init(index: headerView.tag) as IndexSet
        self.tableView.reloadSections(section, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = tableView.cellForRow(at: indexPath)
        print("\(String(describing: selectedRow))")
        // print(selectedRow?.value(forKey: "id"))
        if indexPath.section > 0 {
            // show exist customer current this section
            NSLog("show this section detail customers")
        }else {
            // get new customer page
            self.navigationController?.pushViewController(SMSUIViewController(), animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = CustomerHeaderView.init(reuseIdentifier: headIdentifier)
        let group = self.contactsCells[section]
    
        headView.delegate = self as? LSHeaderViewDelegate
        
        headView.tag = section
        NSLog("-------section" + "\(section)" )
        
        headView.friendGroup = group
        return headView
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
