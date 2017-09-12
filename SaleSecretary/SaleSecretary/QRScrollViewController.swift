//
//  QRScrollViewController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/15.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import MBProgressHUD

class QRScrollViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var qrs: [UIImageView]!
    
    var objs: [QRCode]! = []
    
    var isSharing = false {
        
        didSet {
            
        }
    }
    
    @IBOutlet weak var shareItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        // let imageView = UIImageView()
        // imageView.kf.setImage(with: URL(string: qrUrls[0]))
        self.scrollView.backgroundColor = APP_BACKGROUND_COLOR
        // self.scrollView.addSubview(EmptyContentView()
        // for _i in qrUrls {
         //   self.scrollView.addSubview(_i)
        // }
        // self.pageControl.numberOfPages = qrUrls.count
        // self.scrollView.contentSize = CGSize(width: maxWidth * 3, height: CGFloat)
        // self.scrollView.contentSize.width = maxWidth * 3
        
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func loadImageViews() {
        
        Utils.showLoadingHUB(view: self.scrollView, completion: {
            hub in
            let r = QRCode.getUserQRCodes() {
                json in
                let cnt = json["body"]["page"]["totalRecord"].int
                if cnt == nil || cnt! < 1 {
                    self.pageControl.numberOfPages = 1
                    let empty = EmptyContentView(frame: self.scrollView.frame)
                    empty.textLabel.text = "还没有生成过二维码呢，您可以自由生成多张不同的身份名片～"
                    empty.textLabel.numberOfLines = 3
                    empty.showInView(self.scrollView)
                    self.shareItem.isEnabled = false
                    return
                }
                self.shareItem.isEnabled = true
                let obj = json["body"]["obj"].arrayValue
                var originX: CGFloat = 0
                self.qrs = []
                self.objs = []
                let maxWidth = self.view.frame.width
                for o in obj {
                    let url = o["qrCodeSrc"].string
                    let img: UIImageView = UIImageView(frame: CGRect(x: originX, y: -64, width: maxWidth, height: maxWidth * CGFloat(1.6667)))
                    img.isUserInteractionEnabled = true
                    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
                    img.addGestureRecognizer(gesture)
                    img.kf.setImage(with: URL(string: url!))
                    self.qrs.append(img)
                    self.objs.append(QRCode(json: o))
                    originX += maxWidth
                }
                for qr in self.qrs {
                    self.scrollView.addSubview(qr)
                    // qr.snp.makeConstraints()
                }
                self.pageControl.numberOfPages = cnt!
                // self.scrollView.contentSize = CGSize(width: maxWidth * cnt, height: CGFloat)
                self.scrollView.contentSize.width = maxWidth * CGFloat(cnt!)
            }
            r.response(completionHandler: {
                _ in
                hub.hide(animated: true)
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImageViews()

    }
    
    func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let o = self.objs[self.pageControl.currentPage]
            let alertController = UIAlertController(title: "", message: "",
                                                    preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "删除二维码", style: .destructive, handler: {_ in
                Utils.showLoadingHUB(view: self.view, msg: "删除中", completion: {
                    hub in
                    let r = o.delete({
                        _ in
                        Utils.alert("删除成功", handler: {_ in
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    r.response(completionHandler: {_ in hub.hide(animated: true)})
                })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    @IBAction func shareCard(_ sender: UIBarButtonItem) {
        let shareView = ShareView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        shareView.delegate = self
        shareView.hasTabBar = false
        shareView.showInViewController(self)
    }
    
//    lazy var qrUrls:[UIImageView] = { [unowned self] in
//        var urls = [
//            "http://wx4.sinaimg.cn/mw1024/817ccdaegy1fi1pke9hp4j20ku0rrgqd.jpg",
//            "http://wx1.sinaimg.cn/mw1024/817ccdaegy1fegvh9mbqnj20ku0m10vt.jpg",
//            "http://wx1.sinaimg.cn/mw1024/817ccdaegy1fi9nmbuymqj20ku0rrn2d.jpg"]
//        var _images:[UIImageView] = []
//        let maxWidth = self.view.frame.width
//        // let maxHight = self.scrollView.bounds.height
//        var originX: CGFloat = 0.0
//        for _u in urls {
//            var _img: UIImageView = UIImageView(frame: CGRect(x: originX, y: 0, width: maxWidth, height: maxWidth))
//            _img.kf.setImage(with: URL(string: _u))
//            _images.append(_img)
//            originX += maxWidth
//        }
//        return _images
//    }()
    
    
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        
    }
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "QRCodeAddViewController") as! QRCodeAddViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension QRScrollViewController: UIScrollViewDelegate, ShareViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        let width = scrollView.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / width
        
        // print("scrollViewDidEndDecelerating,\(width), \(offsetX), \(index)")
        // scrollView.inputView?.backgroundColor = UIColor.groupTableViewBackground
        
        self.pageControl.currentPage = Int(index)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        // print("scrollViewDidScroll \(offsetX)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetX = scrollView.contentOffset.x
        print("scrollViewDidEndDragging \(offsetX)")
    }
    
    func sendLinkContent(inScene: WXScene) {
        let msg = WXMediaMessage()
        if self.objs.count == 0 {
            let hub = MBProgressHUD.showAdded(to: view!, animated: true)
            hub.mode = MBProgressHUDMode.text
            hub.label.text = "您还没有名片可以分析"
            // hub.offset = CGPoint(x: 0, y: MBProgressMaxOffset - 100)
            hub.show(animated: true)
            hub.hide(animated: true, afterDelay: 1.5)
            return
        }
        let obj = self.objs[pageControl.currentPage]
        msg.title = "销小秘"
        msg.description = "\(obj.name!)的个人名片"
        msg.setThumbImage(UIImage(named:"logo_xxm"))
        let ext = WXWebpageObject()
        ext.webpageUrl = obj.qrCodeLinkurl ?? "http://www.zj.vc"
        msg.mediaObject = ext
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = msg
        req.scene = Int32(inScene.rawValue)
        WXApi.send(req)
    }
    
}


