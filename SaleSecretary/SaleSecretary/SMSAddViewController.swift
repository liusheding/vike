//
//  SMSAddViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit

class SMSAddViewController : UIViewController {
    
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    
    var segmentedViews : [UIView]!
    
    
    @IBOutlet weak var shareView: UIView!
    
    
    @IBOutlet weak var templeteView: UIView!
    
    
    @IBOutlet weak var customerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedViews = [templeteView, customerView]
        // self.addChildViewController(<#T##childController: UIViewController##UIViewController#>)
        showSelectedView(0)
    }
    
    
    @IBAction func onSegmChange(_ sender: UISegmentedControl) {
        
        
        let idx = sender.selectedSegmentIndex
        print("select \(idx) segment")
        if idx >= segmentedViews.count {
            print("unexcepted idx, please check code or storyboard")
            return
        }
        
        showSelectedView(idx)
    }
    
    
    func showSelectedView(_ idx : Int) {
        for (i, e) in segmentedViews.enumerated() {
            if i == idx {
                // e.show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
                e.isHidden = false
            } else {
                e.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.segmentCtrl.frame)
    }
}



class SMSTemplateViewController : UIViewController {
    
//    @IBOutlet weak var customerField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setUpTextFields()
        setUpTableView()
    }
    
    fileprivate var cellId : String  = "smsTmpleteCellId"
    
//    func setUpTextFields() {
//        print("setUpTextFields ")
//        customerField.borderStyle = UITextBorderStyle.roundedRect
//        let leftImage = UIImageView(image: UIImage(named: "icon_kh"))
//        let rightImage = UIImageView(image : UIImage(named: "icon_tjfz"))
//        rightImage.isUserInteractionEnabled = true
//        let recog = UIGestureRecognizer()
//        recog.addTarget(self, action: Selector(("touched")))
//        rightImage.addGestureRecognizer(recog)
//        customerField.leftView = leftImage
//        customerField.rightView = rightImage
//        customerField.leftViewMode = UITextFieldViewMode.always
//        customerField.rightViewMode = UITextFieldViewMode.always
//        
//        func touched () {
//            
//            print("toeched")
//        }
//        
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // customerField.isHidden = true
    }
}


extension SMSTemplateViewController : UITableViewDataSource, UITableViewDelegate {
   
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        print(self.bottomLayoutGuide)
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
               // self.tableView.ti
        self.tableView.backgroundColor = UIColor.white
        self.tableView.sectionIndexBackgroundColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            cell.imageView?.image = UIImage(named: "icon_kh")
            cell.textLabel?.text = "请选择客户...刘总、张总、刘总、张总、刘总、张总、刘总、张总、刘总、张总刘总、张总、刘总、张总、刘总、张总、刘总、张总、刘总、张总、刘总、张总"
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.textColor = UIColor.lightGray
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            // cell.addConstraint(NSLayoutConstraint)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
        present(custSelectVC, animated: true) {
            [weak self] in {
                print(self)
            }()
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // self.tableView.scrollsToTop = true
        // print("\(self.tableView.frame)")
        // print("\(self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))")
    }
    
}








