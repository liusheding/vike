//
//  CTCustomerDetailInfoViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MessageUI

class CTCustomerDetailInfoViewController: UIViewController {

    var userInfo = Customer.init()
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    @IBOutlet weak var customerInfo: UIView!
    
    @IBOutlet weak var customerTrail: UIView!
    
    var messageVC: MFMessageComposeViewController?
    var segmentView : [UIView] = []
    
    @IBAction func changeSegment(_ sender: Any) {
        
        let idx = (sender as AnyObject).selectedSegmentIndex
//        NSLog("select \(String(describing: idx)) segment")
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
        self.hidesBottomBarWhenPushed=true
        
        // choose segment uiview
        showSelectedView(0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickCallPhone(_ sender: Any) {
    
//        let callWebView = UIWebView()
//        callWebView.loadRequest(URLRequest(url:URL(string: "tel:\(10086)")!))
//        self.view.addSubview(callWebView)
        //2.有提示
        UIApplication.shared.open(URL(string: "telprompt://"+(self.userInfo.phone_number?[0])!)! , options: [:], completionHandler: nil)
        
    }
    
    @IBAction func clickMessageButton(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            self.messageVC = MFMessageComposeViewController()
            self.messageVC?.recipients = [(self.userInfo.phone_number?[0])!]
            self.messageVC?.messageComposeDelegate = self
            self.present(messageVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickAddTrail(_ sender: Any) {
        
        let storyboardLocal = UIStoryboard(name: "ContactStoryboard" , bundle: nil)
        let detail = storyboardLocal.instantiateViewController(withIdentifier: "addingMessageView") as! CTAddMessageController
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func showSelectedView(_ idx : Int) {
        for (i, e) in segmentView.enumerated() {
            if i == idx {
                e.isHidden = false
            } else {
                e.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.segments.frame)
    }

}

extension CTCustomerDetailInfoViewController : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.messageVC?.dismiss(animated: true, completion: nil)
    }
}

