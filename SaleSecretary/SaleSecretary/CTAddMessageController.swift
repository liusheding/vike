//
//  CTAddMessageController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/9/5.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class CTAddMessageController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
   
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var backView: UIView!
    
    
    
    let db = CustomerDBOp.defaultInstance()
    
    let placeholderLabel = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backView.backgroundColor = UIColor.groupTableViewBackground
        self.content.delegate = self
        self.titleText.delegate = self
        
        self.navigationSetting()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.placeholderLabel.frame = CGRect(x : 5 , y: 5, width: UIScreen.main.bounds.size.width, height: 20)
        self.placeholderLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        self.placeholderLabel.text = "记录下轨迹的详细内容（限长1000）"
        self.placeholderLabel.textColor = UIColor.lightGray
        self.content.addSubview(self.placeholderLabel)
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    func navigationSetting()  {
        self.navigationItem.title = "添加轨迹"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(clickSaveBtn))
        
    }
    
    func clickSaveBtn() {
        var msg : String = ""
        let title = self.titleText.text
        let content = self.content.text
        if title?.characters.count == 0 {
            msg = "请输入主题信息！"
        }
        if content?.characters.count == 0 {
            msg = "请输入轨迹内容！"
        }
        if msg.characters.count > 0 {
            let uc = UIAlertController(title: "警告", message: msg , preferredStyle: UIAlertControllerStyle.alert)
            uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
            self.present(uc, animated: true, completion: nil)
            return
        }
        
        let body : [String : Any] = ["cusInfoId": APP_USER_ID ?? "" , "title" : title ?? "" , "content" : content ?? "" ]
        NetworkUtils.postBackEnd("C_TXL_CUS_GTGJ", body: body, handler: { (val) in
            print(val)
        })
        
//        self.db.storeTrailInfo(trail: TrailMessage.init(title: title!, content: content!))
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.titleText.resignFirstResponder()
            self.content?.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
}

extension CTAddMessageController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLabel.isHidden = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false  // 显示
        }
        else{
            self.placeholderLabel.isHidden = true  // 隐藏
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location >= ContactCommon.trailContentLen {
            return false
        }
        return true
    }
}

extension CTAddMessageController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.characters.count)! > ContactCommon.trailTitltLen {
            return false
        }
        return true
    }
    
}
