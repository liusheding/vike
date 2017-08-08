//
//  CustomerPopUpView.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/4.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let kActionViewWidth: CGFloat = 140   //container view width
private let kActionViewHeight: CGFloat = 116    //container view height
private let kActionButtonHeight: CGFloat = 34   //button height
private let kFirstButtonY: CGFloat = 12 //the first button Y value

class CustomerPopUpView: UIView {
    weak var delegate: ActionFloatViewDelegate?
    let disposeBag = DisposeBag()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initContent()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initContent() {
        self.backgroundColor = UIColor.clear
        let actionImages = [
            UIImage(imageLiteralResourceName: "contacts_add_friend"),
            UIImage(imageLiteralResourceName: "contacts_add_friend"),
            UIImage(imageLiteralResourceName: "contacts_add_groupmessage")
        ]
        
        let actionTitles = [
            "同步通讯录",
            "分组管理",
            "批量处理"
        ]
        
        //Init containerView
        let containerView : UIView = UIView()
        containerView.backgroundColor = UIColor.clear
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(3)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo(kActionViewWidth)
            make.height.equalTo(kActionViewHeight)
        }
        //Init bgImageView
        let stretchInsets = UIEdgeInsetsMake(14, 6, 6, 34)
        let bubbleMaskImage = UIImage(imageLiteralResourceName: "MessageRightTopBg").resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        let bgImageView: UIImageView = UIImageView(image: bubbleMaskImage)
        containerView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containerView)
        }
        
        //init custom buttons
        var yValue = kFirstButtonY
        for index in 0 ..< actionImages.count {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            itemButton.setTitleColor(UIColor.white, for: UIControlState())
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(actionTitles[index], for: .normal)
            itemButton.setTitle(actionTitles[index], for: .highlighted)
            itemButton.setImage(actionImages[index], for: .normal)
            itemButton.setImage(actionImages[index], for: .highlighted)
            itemButton.addTarget(self, action: #selector(CustomerPopUpView.buttonTaped(_:)), for: UIControlEvents.touchUpInside)
            itemButton.contentHorizontalAlignment = .left
            itemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
            itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            itemButton.tag = index
            containerView.addSubview(itemButton)
            
            itemButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(containerView.snp.top).offset(yValue)
                make.right.equalTo(containerView.snp.right)
                make.width.equalTo(containerView.snp.width)
                make.height.equalTo(kActionButtonHeight)
            }
            yValue += kActionButtonHeight
        }
        //add tap to view
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.subscribe { _ in
            self.hide(true)
            }.addDisposableTo(self.disposeBag)
        
        self.isHidden = true
       
    }
    
    func buttonTaped(_ sender: UIButton!) {
        guard let delegate = self.delegate else {
            self.hide(true)
            return
        }
        NSLog("======")
        let type = ActionFloatViewItemType(rawValue:sender.tag)!
        delegate.floatViewTapItemIndex(type)
        self.hide(true)
    }
    
    /**
     Hide the float view
     
     - parameter hide: is hide
     */
    func hide(_ hide: Bool) {
//        NSLog("customerPopUpview  hide \(hide)")
        if hide {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.2 ,
                           animations: {
                            self.alpha = 0.0
            },
                           completion: { finish in
                            self.isHidden = true
                            self.alpha = 1.0
            })
        } else {
            self.alpha = 1.0
            self.isHidden = false
        }
    }
}


/**
 *  TSMessageViewController Float view delegate methods
 */
protocol ActionFloatViewDelegate: class {
    /**
     Tap the item with index
     */
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType)
}

enum ActionFloatViewItemType: Int {
    case synContacts, managerGroup , batchOperate
}
