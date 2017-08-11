//
//  Extensions.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}



