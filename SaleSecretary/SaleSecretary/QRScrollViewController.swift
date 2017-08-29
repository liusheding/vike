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

class QRScrollViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        // let imageView = UIImageView()
        // imageView.kf.setImage(with: URL(string: qrUrls[0]))
        self.scrollView.backgroundColor = UIColor.black
        let maxWidth = self.view.frame.width
        for _i in qrUrls {
            self.scrollView.addSubview(_i)
        }
        // self.pageControl.numberOfPages = qrUrls.count
        // self.scrollView.contentSize = CGSize(width: maxWidth * 3, height: CGFloat)
        self.scrollView.contentSize.width = maxWidth * 3
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    lazy var qrUrls:[UIImageView] = { [unowned self] in
        var urls = [
            "http://wx4.sinaimg.cn/mw1024/817ccdaegy1fi1pke9hp4j20ku0rrgqd.jpg",
            "http://wx1.sinaimg.cn/mw1024/817ccdaegy1fegvh9mbqnj20ku0m10vt.jpg",
            "http://wx1.sinaimg.cn/mw1024/817ccdaegy1fi9nmbuymqj20ku0rrn2d.jpg"]
        var _images:[UIImageView] = []
        let maxWidth = self.view.frame.width
        // let maxHight = self.scrollView.bounds.height
        var originX: CGFloat = 0.0
        for _u in urls {
            var _img: UIImageView = UIImageView(frame: CGRect(x: originX, y: 0, width: maxWidth, height: maxWidth))
            _img.kf.setImage(with: URL(string: _u))
            _images.append(_img)
            originX += maxWidth
        }
        return _images
    }()
    
    
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        
    }
    
}

extension QRScrollViewController: UIScrollViewDelegate {
    
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
    
}


