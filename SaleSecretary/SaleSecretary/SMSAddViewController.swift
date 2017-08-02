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
}



class SMSTemplateViewController : UIViewController {
    
    @IBOutlet weak var customerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
    }
    
    
    func setUpTextFields() {
        print("setUpTextFields ")
        customerField.borderStyle = UITextBorderStyle.roundedRect
        customerField.sizeThatFits(<#T##size: CGSize##CGSize#>)
        let leftImage = UIImageView(image: UIImage(named: "icon_kh"))
        let rightImage = UIImageView(image : UIImage(named: "icon_tjfz"))
        rightImage.isUserInteractionEnabled = true
        let recog = UIGestureRecognizer()
        recog.addTarget(self, action: Selector(("touched")))
        rightImage.addGestureRecognizer(recog)
        customerField.leftView = leftImage
        customerField.rightView = rightImage
        customerField.leftViewMode = UITextFieldViewMode.always
        customerField.rightViewMode = UITextFieldViewMode.always
        
        func touched () {
            
            print("toeched")
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customerField.isHidden = true
    }
}







