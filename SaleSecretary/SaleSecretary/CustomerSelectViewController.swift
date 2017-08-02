//
//  CustomerSelectViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CustomerSelectViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true) { 
            [weak self] in {} ()
        }
        
    }
    
    
}
