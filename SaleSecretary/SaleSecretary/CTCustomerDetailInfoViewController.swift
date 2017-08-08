//
//  CTCustomerDetailInfoViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTCustomerDetailInfoViewController: UIViewController {

    var userInfo = Customer.init()
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    @IBOutlet weak var customerInfo: UIView!
    
    @IBOutlet weak var customerTrail: UIView!
    
    var segmentView : [UIView] = []
    
    @IBAction func changeSegment(_ sender: Any) {
        
        let idx = (sender as AnyObject).selectedSegmentIndex
        NSLog("select \(String(describing: idx)) segment")
        if idx! >= segmentView.count {
            NSLog("unexcepted idx, please check code or storyboard")
            return
        }
        showSelectedView(idx!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentView = [ customerTrail , customerInfo]
        self.navigationItem.title = "详细资料"
        self.view.backgroundColor = UIColor.white
        self.name.text = userInfo.name
        
        // choose segment uiview
        showSelectedView(0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showSelectedView(_ idx : Int) {
        for (i, e) in segmentView.enumerated() {
            if i == idx {
                e.isHidden = false
            } else {
                e.isHidden = true
            }
            NSLog(" segment view hide \(i) --\(idx)-- \(e.isHidden)------")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.segments.frame)
    }

}

