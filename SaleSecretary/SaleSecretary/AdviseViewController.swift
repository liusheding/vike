//
//  AdviseViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/25.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

class AdviseViewController: UIViewController {
    var textView:UITextView!
    let placeholderLabel = UILabel.init()
    let wordcount = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIView(frame:CGRect(x: 0,y: 70,width: UIScreen.main.bounds.size.width,height: 160))
        bgView.backgroundColor = UIColor.white
        
        textView = UITextView(frame:CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 130))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.returnKeyType = UIReturnKeyType.send
        
        textView.delegate = self
        textView.isScrollEnabled = true
        
        self.placeholderLabel.frame = CGRect(x:5, y:5, width:UIScreen.main.bounds.size.width, height:20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        self.placeholderLabel.text = "描述问题出现的情况或者操作步骤"
        self.placeholderLabel.textColor = UIColor.lightGray
        textView.addSubview(self.placeholderLabel)
        bgView.addSubview(textView)
        
        self.wordcount.frame = CGRect(x:UIScreen.main.bounds.size.width - 80, y:140, width:70, height:10)
        self.wordcount.font = UIFont.systemFont(ofSize: 13)
        self.wordcount.text = "0/1000"
        self.wordcount.textColor = UIColor.lightGray
        self.wordcount.textAlignment = .right
        bgView.addSubview(self.wordcount)
        
        self.view.addSubview(bgView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewEditChanged), name: NSNotification.Name.UITextViewTextDidChange, object: textView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(clickSubmitBtn))
        
        //点击空白收起键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 通知响应方法
    func textViewEditChanged(notification:NSNotification)
    {
        let textview:UITextView! = notification.object as! UITextView
        if (textview != nil)
        {
            let text:String! = textview.text
            let length = text.characters.count
            self.wordcount.text = "\(length)/1000"
            if (length > 1000)
            {
                let index = text.index(text.startIndex, offsetBy:1000)
                textview.text = text.substring(to: index)
                self.wordcount.text = "1000/1000"
            }
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.textView?.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func clickSubmitBtn(){
        let content = textView.text!
        if content == ""{
            showAlert("请描述问题出现的情况或者操作步骤")
            return
        }
        let hub = MBProgressHUD.showAdded(to: (self.view)!, animated: true)
        hub.mode = MBProgressHUDMode.text
        hub.label.text = "提交成功"
        hub.detailsLabel.text = "我们会尽快核实处理，感谢您的反馈"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            hub.hide(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(_ message:String){
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension AdviseViewController: UITextViewDelegate {
   
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false  // 显示
        }
        else{
            self.placeholderLabel.isHidden = true  // 隐藏
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{ // 输入换行符时收起键盘
            textView.resignFirstResponder() // 收起键盘
        }
        return true
    }
}
