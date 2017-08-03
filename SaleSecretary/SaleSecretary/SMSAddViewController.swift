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
    
    @IBOutlet weak var previewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setUpTextFields()
        setUpTableView()
        previewBtn.layer.cornerRadius = 5.0
        // previewBtn.layer.borderColor = 5.0f
    }
    
    fileprivate var cellId : String  = "smsTmpleteCellId"
    
    fileprivate var cellIdforInscribe: String  = "cellIdforInscribe"
    
    fileprivate let planDatePickerId = "planDatePicker"
    
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


extension SMSTemplateViewController : UITableViewDataSource, UITableViewDelegate, CustomerSelectDelegate {
   
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "AppellationCellView", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.register(UINib(nibName: "InscribeViewCell", bundle: nil), forCellReuseIdentifier: cellIdforInscribe)
        self.tableView.register(UINib(nibName: "PlanExecTimeCellView", bundle: nil), forCellReuseIdentifier: planDatePickerId)
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
               // self.tableView.ti
        self.tableView.backgroundColor = UIColor.white
        self.tableView.sectionIndexBackgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 120
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        
        return CGFloat(10)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return createCustomerCell()
        case 1:
            return createTemplateCell()
        case 2:
            return createAppellationCell()
        case 3:
            return createInscribeCell()
        case 4:
            return createPlanDatePickerCell()
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    func createAccessoryButton() -> UIButton {
        let btn = UIButton(type : UIButtonType.custom)
        btn.frame = CGRect(x:0, y:0, width: 32, height:32)
        let image = UIImage(named: "icon_tj")
        btn.setImage(image, for: UIControlState.normal)
        return btn
    }
    
    
    open func createCustomerCell() -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_kh")
        cell.textLabel?.text = "请选择客户..."
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.textColor = UIColor.lightGray
        // cell.accessoryView = UIImageView(image: UIImage(named: "icon_tj"))
        // cell.addConstraint(NSLayoutConstraint)
        cell.accessoryView = createAccessoryButton()
        return cell
    }
    
    private func createTemplateCell() -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        cell.imageView?.image = UIImage(named: "icon_nr")
        cell.textLabel?.text = "短信模版内容"
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        cell.textLabel?.numberOfLines = 5
       
        // btn.setImage(image, for: UIControlState.highlighted)
        // cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        // cell.accessoryView = UIImageView(image: image)
        // cell.accessoryType = UITableViewCellAccessoryType.detailButton
        cell.accessoryView = createAccessoryButton()
        return cell
    }
    
    private func createInscribeCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdforInscribe) as! InscribeViewCell
        return cell
    }
    
    private func createAppellationCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as! AppellationCellView
        return cell
    }
    
    private func createPlanDatePickerCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: planDatePickerId) as! PlanExecTimeCellView
        return cell
    }
    
    
    func selectedRecipients(rec: [Recipient]) {
        let idx = self.tableView.indexPathForSelectedRow
        if idx != nil {
            let cell = self.tableView.cellForRow(at: idx!)
            let names = rec.flatMap({$0.name}).joined(separator: "、")
            cell?.textLabel?.text = names
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
            custSelectVC.delegate = self
            present(custSelectVC, animated: true) {}
        default:
            return
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // self.tableView.scrollsToTop = true
        // print("\(self.tableView.frame)")
        // print("\(self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))")
    }
    
}








