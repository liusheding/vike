//
//  UserManageHeaderView.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Foundation

// 自定义section的headerView
// 协议，点击headerView的回调
protocol UMHeaderViewDelegate: NSObjectProtocol {
    func clickedGroupTitle(headerView: UserManageHeaderView)
}

class UserManageHeaderView: UITableViewHeaderFooterView {
    var groupTitle =  UIButton()
    
    weak var delegate: UMHeaderViewDelegate?
    
    var friendGroup: UserGroup! {
        didSet {
            self.groupTitle.setTitle(friendGroup.name!, for: UIControlState.normal)
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.groupTitle)
        self.groupTitle.setImage(UIImage.init(named: "buddy_header_arrow"), for: UIControlState.normal)
        
        self.groupTitle.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.groupTitle.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        self.groupTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.groupTitle.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        
        
        self.groupTitle.imageView?.contentMode = UIViewContentMode.center
        self.groupTitle.imageView?.clipsToBounds = false
        
        self.groupTitle.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 0)
        self.groupTitle.imageEdgeInsets = UIEdgeInsets(top: 15, left: -15, bottom: 15, right: 20)
        self.groupTitle.backgroundColor = UIColor.white
        
        self.groupTitle.addTarget(self, action: #selector(clickGroupTitle), for: .touchUpInside)
        
    }
    
    func clickGroupTitle() {
        self.friendGroup.isOpen = !(self.friendGroup.isOpen!)
        delegate?.clickedGroupTitle(headerView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.groupTitle.frame = self.bounds
        if friendGroup.isOpen! {
            self.groupTitle.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            self.groupTitle.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        }
    }
}
