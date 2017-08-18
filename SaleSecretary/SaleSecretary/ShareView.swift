//
//  ShareView.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/17.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ShareView: UIView,UIScrollViewDelegate {
    fileprivate var contentHeight:CGFloat = 155
    fileprivate var topbarHeight:CGFloat = 65
    
    fileprivate var bgView:UIView!
    fileprivate var contentView:UIView!
    fileprivate var rootVC:UIViewController!
    fileprivate var scrollView:UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-topbarHeight))
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.0
        self.addSubview(self.bgView)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.bgViewTapped))
        self.bgView.addGestureRecognizer(tapGesture)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(self.contentView)
        
        let sharePaltformArray = [
            [ "icon_wxhy", "icon_pyq"],
            [ "微信好友","朋友圈"]
        ]
        
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.contentSize = CGSize(width: frame.width * CGFloat(self.pageNum(sharePaltformArray[0].count)), height: 0)
        self.contentView.addSubview(self.scrollView)
        
        let buttonWidth:CGFloat = 40.0
        let count = CGFloat((sharePaltformArray[0].count))
        let buttonX = (frame.width / count - buttonWidth) / 2
        
        for i in 0 ..< sharePaltformArray[0].count {
            
            let shareButton = UIButton(type:.custom)
            
            let btnRect = CGRect(x: (buttonX + (frame.width / count) * CGFloat(i)), y: 20, width: buttonWidth, height: buttonWidth)
            
            shareButton.frame = btnRect
            shareButton.tag = 100 + i
            shareButton.addTarget(self, action: #selector(self.shareButtonClicked(_:)), for: .touchUpInside)
            shareButton.setBackgroundImage(UIImage(named: sharePaltformArray[0][i]), for: UIControlState())
            
            shareButton.layer.cornerRadius = buttonWidth / 2
            shareButton.layer.masksToBounds = true
            self.scrollView.addSubview(shareButton)
            
            let shareLabel = UILabel.init(frame: CGRect(x: ((frame.width / count - shareButton.frame.width - 15) / 2 + (frame.width / count) * CGFloat(i)), y: shareButton.frame.maxY + 10 , width: shareButton.frame.width + 15, height: 15))
            shareLabel.font = UIFont.systemFont(ofSize: 13)
            shareLabel.textColor = UIColor.darkGray
            shareLabel.textAlignment = .center
            shareLabel.text = sharePaltformArray[1][i]
            self.scrollView.addSubview(shareLabel)
        }
        
        let cancelBtn = UIButton(type:.custom)
        cancelBtn.frame = CGRect(x: 0, y: self.contentView.frame.height - 50, width: self.contentView.frame.width, height: 50)
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState())
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnClicked), for: .touchUpInside)
        self.contentView.addSubview(cancelBtn)
    }
    
    /**
     遮罩背景响应事件
     */
    func bgViewTapped() {
        self.dismiss()
    }
    
    /**
     取消按钮响应事件
     */
    func cancelBtnClicked() {
        self.dismiss()
    }
    
    /**
     分享按钮响应事件
     */
    func shareButtonClicked(_ sender:UIButton) {
        if WXApi.isWXAppInstalled() == false{
            print("未安装微信")
            return
        }
        if sender.tag == 100 {
            sendLinkContent(inScene: WXSceneSession)
        }else if sender.tag == 100 + 1 {
            sendLinkContent(inScene: WXSceneTimeline)
        }
    }
    
    func sendLinkContent(inScene:WXScene) {
        let message = WXMediaMessage()
        message.title = "销小秘"
        message.description = "握在手心里的小秘 带你走上人生巅峰"
        message.setThumbImage(UIImage(named:"logo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = "http://www.zj.vc"
        message.mediaObject = ext
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(inScene.rawValue)
        WXApi.send(req)
    }
    
    func showInViewController(_ viewController:UIViewController){
        self.rootVC = viewController
        self.showInView(viewController.view)
    }
    
    fileprivate func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentHeight)
            self.rootVC.tabBarController?.tabBar.isHidden=false
            
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
    
    fileprivate func pageNum(_ num:Int) -> Int {
        return (num % 4 == 0 ? 0 : 1) + num / 4
    }
    
    fileprivate func showInView(_ parentView:UIView) {
        parentView.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.4
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - self.contentHeight - self.topbarHeight, width: self.frame.width, height: self.contentHeight)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
