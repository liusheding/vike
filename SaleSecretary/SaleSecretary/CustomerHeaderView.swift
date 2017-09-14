//
//  CustomerHeaderView.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/2.
//  Copyright © 2017年 zjjy. All rights reserved.
//
import UIKit
import Foundation

// 自定义section的headerView
// 协议，点击headerView的回调
protocol LSHeaderViewDelegate: NSObjectProtocol {
    func clickedGroupTitle(headerView: CustomerHeaderView)
}

class CustomerHeaderView: UITableViewHeaderFooterView {
    
    var groupTitle =  UIButton()
    var groupOnlineCount = UILabel()
    
    weak var delegate: LSHeaderViewDelegate?
    
    var friendGroup: CustomerGroup! {
        didSet {
            self.groupTitle.setTitle(friendGroup.name!, for: UIControlState.normal)
            //添加好友数量
            self.groupOnlineCount.text = friendGroup.count
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.groupTitle)
        self.groupTitle.setImage(UIImage.init(named: "buddy_header_arrow"), for: UIControlState.normal)
        
        self.groupTitle.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 0)
        self.groupTitle.imageEdgeInsets = UIEdgeInsets(top: 15, left: -15, bottom: 15, right: 20)
        self.groupTitle.backgroundColor = UIColor.white
        self.groupTitle.setTitleColor(UIColor.black , for: UIControlState.normal)
        self.groupTitle.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        self.groupTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.groupTitle.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        
        self.groupTitle.imageView?.contentMode = UIViewContentMode.center
        self.groupTitle.imageView?.clipsToBounds = false
//        self.groupTitle.imageView.
        
        self.groupTitle.addTarget(self, action: #selector(clickGroupTitle), for: .touchUpInside)
        
        contentView.addSubview(self.groupOnlineCount)
        
    }
    
    func clickGroupTitle() {
        self.friendGroup.isOpen = !(self.friendGroup.isOpen!)
        delegate?.clickedGroupTitle(headerView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.groupTitle.frame = self.bounds
        
        let onlineW:  CGFloat = 60
        let onlineH = self.bounds.height
        let onlineX = self.bounds.width - 10 - onlineW
        let onlineY: CGFloat = 0
        
        
        let onlineFrame = CGRect(x: onlineX, y: onlineY, width: onlineW, height: onlineH)
        self.groupOnlineCount.frame = onlineFrame
        
        if friendGroup.isOpen! {
            self.groupTitle.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            self.groupTitle.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        }
    }
    
}
