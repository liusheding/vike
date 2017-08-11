//
//  CTChooseNewerController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/9.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
//contact frame
//import AddressBook  ios 9 below
//import AddressBookUI
import Contacts

class CTChooseNewerController: UITableViewController {
    
    let store = CNContactStore()
    
    lazy var contactDt : [Customer] =  { [unowned self] in
        print("loading contact")
        var cust : [Customer] = []
        self.store.requestAccess(for: .contacts ) {
            (isRight , error) in
            if isRight {
                self.loadContactData()
                
            } else {
                print("no right")
            }
        }
        return cust
    }()
    
    let cellId = "contactsCell"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "新的客户"
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        self.tableView.register( TableViewCell.self , forCellReuseIdentifier: cellId)
        
//        self.tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: cellId)
        // init contacts data
        
    }
    
    func loadContactData() -> Void {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized else {
            NSLog(" auth failed !")
            return
        }
        var dt : [Customer] = []
        let keys = [ CNContactFamilyNameKey,CNContactGivenNameKey, CNContactJobTitleKey , CNContactDepartmentNameKey,CNContactNoteKey, CNContactPhoneNumbersKey,
                     CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                     CNContactDatesKey, CNContactInstantMessageAddressesKey ,
                     CNContactNicknameKey , CNContactOrganizationNameKey , ]
        
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try store.enumerateContacts(with: request, usingBlock: {
                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in                let firstName = contact.givenName
                let lastName = contact.familyName
                let nickName = contact.nickname
                let org = contact.organizationName
//                let jobTitle = contact.jobTitle
                var pNumber : [String] = []
//                NSLog("[\(firstName),\(lastName),\(nickName),\(org),\(jobTitle)]")
                for phone in contact.phoneNumbers {
                    if phone.label != nil {
//                        let label = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
                        let value = phone.value.stringValue
                        pNumber.append(value)
//                        NSLog("\(label):\(value)")
                    }
                }
                let tmpDetail = ["name" : lastName+firstName , "phone_number" :pNumber , "icon" : lastName , "nick_name" : nickName , "time" : org] as [String : Any]
                dt.append(Customer.init(dict: tmpDetail as [String : AnyObject] ))
            })
        } catch {
            NSLog(error as! String)
        }
        self.contactDt = dt
        self.tableView.reloadData()
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
        return contactDt.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! TableViewCell
        NSLog("----\(contactDt)")
        cell.textLabel?.text = self.contactDt[indexPath.row].name
        cell.detailTextLabel?.text = self.contactDt[indexPath.row].phone_number?[0]
        return cell
    }

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
