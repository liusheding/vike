//
//  SMSContentTextCell.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/4.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit


protocol SMSContentChangeDelegate {
    func textChanged(_ text: String!)
}

class SMSContentTextCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var placeHolder: UILabel!
    
    var delegte: SMSContentChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }
    
}

extension SMSContentTextCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeHolder.isHidden = false
        } else {
            self.placeHolder.isHidden = true
        }
        self.delegte?.textChanged(textView.text)
    }
    
}
