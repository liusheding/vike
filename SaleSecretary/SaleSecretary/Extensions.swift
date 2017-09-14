//
//  Extensions.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/11.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD


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

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

struct Utils {
    
    static func isTelNumber(num: String) -> Bool {
    
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true)) {
            return true
        } else {
            return false
        }
    }
    
    static func matchsMobile(str: String) -> [String]? {
        do {
            let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
            let regex =  try NSRegularExpression(pattern: mobile, options: .caseInsensitive)
            return Utils.matchesRegx(str: str, regx: regex)
        } catch {
            return nil
        }

    }
    
    static func matchesRegx(str: String, regx: NSRegularExpression) -> [String]? {
        let matchs = regx.matches(in: str, options: .init(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        let nstr = NSString(string: str)
        if matchs == nil || matchs.count == 0 {return nil}
        var result: [String] = []
        for m in matchs {
            result.append(nstr.substring(with: m.range))
        }
        return result
    }
    
    static func matchesJob(str: String) -> [String]? {
        do {
            let pat = "董事|经理|秘书|工人|CEO|CFO|CTO|总监|会计|主管|助理|出纳|文员|销售人员|工程师|科长|书记|主任|处长|局长|厂长|市长|县长|省长"
            let regex = try NSRegularExpression(pattern: pat, options: .caseInsensitive)
            return Utils.matchesRegx(str: str, regx: regex)
        } catch {
            return nil
        }
        
    }
    
    static func inputOnlyNumbers(str: String) -> Bool {
        let reg = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
        return predicate.evaluate(with: str)
    }
    
    static func showLoadingHUB(view: UIView?, msg: String = "正在加载中...", completion: ((MBProgressHUD)-> Void)?) {
        var v = view
        if v == nil {
            v = UIApplication.topViewController()?.view
        }
        let hub = MBProgressHUD.showAdded(to: v!, animated: true)
        hub.label.text = msg
        if completion != nil {
             completion!(hub)
        } else {
            hub.hide(animated: true, afterDelay: 1.5)
        }
       
    }
    
    static func alert(_ msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let uc = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: handler))
        let vc = UIApplication.topViewController()
        vc?.present(uc, animated: true, completion: nil)
        return
    }
    
}

