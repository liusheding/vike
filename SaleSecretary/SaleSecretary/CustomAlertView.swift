//
//  CustomAlert.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
// import RxCocoa

private let kActionViewWidth: CGFloat = 140   //container view width
private let kActionViewHeight: CGFloat = 116    //container view height
private let kActionButtonHeight: CGFloat = 34   //button height
private let kFirstButtonY: CGFloat = 12 //the first button Y value

private let widthPercent : Float = 0.6
private let heightPercent : Float = 0.5

let viewBounds:CGRect = UIScreen.main.bounds

private let widthAlert = viewBounds.width

class CustomAlertView: UICollectionViewCell {
    weak var delegate: ActionFloatViewDelegate?
    let disposeBag = DisposeBag()

    let defaultArray : [Group] = [ ]
    
    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initContent(dfArr: self.defaultArray)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initContent(dfArr: self.defaultArray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder )
        self.initContent( dfArr: self.defaultArray )
    }
    
    convenience init(groups : [Group]) {
        self.init(frame:CGRect.zero)
        self.initContent(dfArr: groups)
    }
    
    fileprivate func initContent(dfArr : [Group]) {
        self.backgroundColor = UIColor.clear
        
        //Init containerView
        let containerView : UIView = UIView()
        containerView.backgroundColor = UIColor.clear
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(250)
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
        for index in 0 ..< dfArr.count {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            itemButton.setTitleColor(UIColor.white, for: UIControlState())
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(dfArr[index].group_name, for: .normal)
            itemButton.setTitle(dfArr[index].group_name, for: .highlighted)
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
        tap.addTarget(self, action: #selector(tapedBackgroud(_:)))
//        tap.rx.event.subscribe { _ in
//            self.hide(true)
//            }.addDisposableTo(self.disposeBag)
        
        self.isHidden = true
        
    }
    
    func tapedBackgroud(_ sender: UITapGestureRecognizer) {
        self.hide(true)
    }
    
    
    
    func buttonTaped(_ sender: UIButton!) {
        guard let delegate = self.delegate else {
            self.hide(true)
            return
        }
        let type = ActionFloatViewItemType(rawValue:sender.tag)!
        delegate.floatViewTapItemIndex(type)
        self.hide(true)
    }
    /**
     Hide the float view
     
     - parameter hide: is hide
     */
    func hide(_ hide: Bool) {
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
