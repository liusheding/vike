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
    

    @IBOutlet weak var phoneView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedViews = [templeteView, customerView, phoneView]
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
    
    
    lazy var datePicker : PlanExecTimeCellView = {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.planDatePickerId) as! PlanExecTimeCellView
        cell.isHidden = true
        return cell
    }()
    
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
    
    @IBAction func previewContent(_ sender: UIButton) {
        let preVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "SMSPreviewController") as! SMSPreviewController
        self.navigationController?.pushViewController(preVC, animated: true)
        // present(, animated: true, completion: nil)
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
        self.tableView.tableFooterView?.backgroundColor = UIColor.lightGray
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
               // self.tableView.ti
        self.tableView.backgroundColor = UIColor.white
        self.tableView.sectionIndexBackgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 5 {
//            if self.datePicker.isHidden {
//                return 0
//            }
            return 120
        } else  {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
            return CommonTableCell.createCustomerCell(cellId)
        case 1:
            return createTemplateCell()
        case 2:
            return createAppellationCell()
        case 3:
            return createInscribeCell()
        case 4:
            return CommonTableCell.createPlanDateCell(cellId)
        case 5:
            return self.datePicker
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
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
        cell.accessoryView = CommonTableCell.createAccessoryButton()
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
    
    
    
    func selectedRecipients(rec: [Recipient]) {
        // let idx = self.tableView.indexPathForSelectedRow
        let cell = self.tableView.cellForRow(at: [0, 0])
        let names = rec.flatMap({$0.name}).joined(separator: "、")
        cell?.textLabel?.text = names
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let custSelectVC = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
            custSelectVC.delegate = self
            present(custSelectVC, animated: true) {}
        case 4:
            toggleDatePicker()
        default:
            return
        }
        self.tableView.deselectRow(at:indexPath, animated: true)
    }
    
    func toggleDatePicker() {
        self.datePicker.isHidden = !self.datePicker.isHidden
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.tableView.scrollsToTop = true
        // print("\(self.tableView.frame)")
        // print("\(self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))")
    }
    
}








