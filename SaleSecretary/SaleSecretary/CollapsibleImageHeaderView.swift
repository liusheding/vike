//
//  CollapsibleImageHeaderView.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/21.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit

protocol CollapsibleImageHeaderViewDelegate {
    
    func toggleSection(_ header: CollapsibleImageHeaderView, section: Int)
    
    func tappedSectionImage(_ section: Int)
    
    func sectionStatus(_ section: Int) -> Bool
}

public class CollapsibleImageHeaderView: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleImageHeaderViewDelegate?
    
    var section: Int = 0
    
    let titleLabel = UILabel()
    
    var imageLabel:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
    
    var collapseLabel = UIButton()
    
    var selected = false
    
    var collapsed = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        // Content View
        contentView.backgroundColor = UIColor.white
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(collapseLabel)
        
        self.collapseLabel.translatesAutoresizingMaskIntoConstraints = true
        self.collapseLabel.setImage(UIImage(named: "buddy_header_arrow"), for: .normal)
        self.collapseLabel.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 0)
        self.collapseLabel.imageEdgeInsets = UIEdgeInsets(top: 45 , left: 15, bottom: 0, right: 20)
        // self.collapseLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        //self.collapseLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        // self.collapseLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 15).isActive = true
        // self.collapseLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: -15).isActive = true
        self.collapseLabel.backgroundColor = UIColor.white
        self.collapseLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.collapseLabel.imageView?.contentMode = UIViewContentMode.center
        self.collapseLabel.imageView?.clipsToBounds = false
        
        // Image label
        imageLabel.image = UIImage(named: "icon_wxz")
        imageLabel.isUserInteractionEnabled = true
        contentView.addSubview(imageLabel)
        // imageLabel.textColor = UIColor.white
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 7).isActive = true
        imageLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        // imageLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        imageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
            #selector(CollapsibleImageHeaderView.setHeaderSelected(_:))))
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        // titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: collapseLabel.leadingAnchor, constant: 25).isActive = true
        
        //
        // Call tapHeader when tapping on this header
        //
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleImageHeaderView.tapHeader(_:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleImageHeaderView else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setHeaderSelected(_ gestureRecognizer: UITapGestureRecognizer) {
        let status: Bool? = delegate?.sectionStatus(self.section)
        if !status! {
            self.imageLabel.image = UIImage(named: "icon_xz_1")
        } else {
            self.imageLabel.image = UIImage(named: "icon_wxz")
        }
        delegate?.tappedSectionImage(self.section)
    }
    
    func setHeaderCollapsed(_ collapsed: Bool) {
        self.collapsed = collapsed
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if collapsed {
            collapseLabel.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        } else {
            collapseLabel.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }
    }

    
}
