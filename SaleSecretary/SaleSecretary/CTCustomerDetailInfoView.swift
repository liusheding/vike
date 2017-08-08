//
//  CTCustomerDetailInfoView.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/7.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

//let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//let TABLE_HEITGHT = SCREEN_WIDTH * 0.618

class CTCustomerDetailInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initContent(){
        self.backgroundColor = UIColor.red
        
        //Init containerView
//        let tableView : UITableView = UITableView()
//        let head = tableView.headerView(forSection: 0)
//        self.addSubview(containerView)
//        containerView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(self.snp.top).offset(0)
//            make.right.equalTo(self.snp.right).offset(0)
//            make.width.equalTo( SCREEN_WIDTH )
//            make.height.equalTo(kActionViewHeight)
//        }
//        //Init bgImageView
//        let stretchInsets = UIEdgeInsetsMake(14, 6, 6, 34)
//        let bubbleMaskImage = UIImage(imageLiteralResourceName: "MessageRightTopBg").resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
//        let bgImageView: UIImageView = UIImageView(image: bubbleMaskImage)
//        containerView.addSubview(bgImageView)
//        bgImageView.snp.makeConstraints { (make) -> Void in
//            make.edges.equalTo(containerView)
//        }
//        
//        //init custom buttons
//        var yValue = kFirstButtonY
//        for index in 0 ..< actionImages.count {
//            let itemButton: UIButton = UIButton(type: .custom)
//            itemButton.backgroundColor = UIColor.clear
//            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
//            itemButton.setTitleColor(UIColor.white, for: UIControlState())
//            itemButton.setTitleColor(UIColor.white, for: .highlighted)
//            itemButton.setTitle(actionTitles[index], for: .normal)
//            itemButton.setTitle(actionTitles[index], for: .highlighted)
//            itemButton.setImage(actionImages[index], for: .normal)
//            itemButton.setImage(actionImages[index], for: .highlighted)
//            itemButton.addTarget(self, action: #selector(CustomerPopUpView.buttonTaped(_:)), for: UIControlEvents.touchUpInside)
//            itemButton.contentHorizontalAlignment = .left
//            itemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
//            itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//            itemButton.tag = index
//            containerView.addSubview(itemButton)
//            
//            itemButton.snp.makeConstraints { (make) -> Void in
//                make.top.equalTo(containerView.snp.top).offset(yValue)
//                make.right.equalTo(containerView.snp.right)
//                make.width.equalTo(containerView.snp.width)
//                make.height.equalTo(kActionButtonHeight)
//            }
//            yValue += kActionButtonHeight
//        }
       
        
    }
}
