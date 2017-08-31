//
//  EmptyContentView.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/31.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit

class EmptyContentView: UIView {
    
    
    var textLabel: UILabel!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.textLabel = UILabel(frame: CGRect(x: frame.origin.x + 20, y: frame.origin.y + 15 , width: frame.width - 40, height:  40))
        self.textLabel.textAlignment = .center
        self.textLabel.font = UIFont.systemFont(ofSize: 15)
        self.textLabel.textColor = APP_DETAIL_TEXT_COLOR
        self.textLabel.text = "空空如也  😭😭😭"
        self.addSubview(textLabel)
    }
    
    func showInView(_ parentView: UIView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            parentView.addSubview(self)
        })
    }
    
    func dismiss() -> Void {
        UIView.animate(withDuration: 0.3, animations: {}, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}
