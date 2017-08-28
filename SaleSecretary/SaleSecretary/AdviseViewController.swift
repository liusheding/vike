//
//  AdviseViewController.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/25.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class AdviseViewController: UIViewController {
    var textView:UITextView!
    let placeholderLabel = UILabel.init()
    let wordcount = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIView(frame:CGRect(x: 0,y: 75,width: UIScreen.main.bounds.size.width,height: 160))
        bgView.backgroundColor = UIColor.white
        
        let textView = UITextView(frame:CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 130))
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.returnKeyType = UIReturnKeyType.send
        
        textView.delegate = self
        textView.isScrollEnabled = true
        
        self.placeholderLabel.frame = CGRect(x:5, y:5, width:UIScreen.main.bounds.size.width, height:20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        self.placeholderLabel.text = "描述问题出现的情况或者操作步骤"
        self.placeholderLabel.textColor = UIColor.darkGray
        textView.addSubview(self.placeholderLabel)
        bgView.addSubview(textView)
        
        self.wordcount.frame = CGRect(x:UIScreen.main.bounds.size.width - 80, y:140, width:70, height:10)
        self.wordcount.font = UIFont.systemFont(ofSize: 13)
        self.wordcount.text = "0/1000"
        self.wordcount.textColor = UIColor.darkGray
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
        let textView:UITextView! = notification.object as! UITextView
        if (textView != nil)
        {
            let text:String! = textView.text
            let length = text.characters.count
            self.wordcount.text = "\(length)/1000"
            if (length > 1000)
            {
                let index = text.index(text.startIndex, offsetBy:1000)
                textView.text = text.substring(to: index)
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
        print("====Submit======")
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
