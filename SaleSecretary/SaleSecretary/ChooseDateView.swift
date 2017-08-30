//
//  ChooseDateView.swift
//  SaleSecretary
//
//  Created by xiaoqiang on 2017/8/29.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

class ChooseDateView: UIView {
    fileprivate var contentHeight:CGFloat = 200
    fileprivate var topbarHeight:CGFloat = 65
    fileprivate var tabViewHeight:CGFloat = 120
    
    fileprivate var bgView:UIView!
    fileprivate var contentView:UIView!
    fileprivate var rootVC:UITableViewController!
    fileprivate var tableView:UITableView!
    
    fileprivate let planDatePickerId = "planDatePicker"
    
    fileprivate var yangli:UIButton!
    fileprivate var yinli:UIButton!
    
    fileprivate var calendarType = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-topbarHeight))
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.0
        self.addSubview(self.bgView)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.bgViewTapped))
        self.bgView.addGestureRecognizer(tapGesture)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
        self.contentView.backgroundColor = UIColor.white
        
        let cancelBtn = UIButton(type:.custom)
        cancelBtn.frame = CGRect(x:20, y:10, width:16, height:16)
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnClicked), for: .touchUpInside)
        cancelBtn.setBackgroundImage(UIImage(named: "icon_gb"), for: UIControlState())
        contentView.addSubview(cancelBtn)
        
        let commitBtn = UIButton(type:.custom)
        commitBtn.frame = CGRect(x:frame.width - 41, y:10, width:21, height:14)
        commitBtn.addTarget(self, action: #selector(self.commitBtnClicked), for: .touchUpInside)
        commitBtn.setBackgroundImage(UIImage(named: "icon_dg"), for: UIControlState())
        contentView.addSubview(commitBtn)
        
        tableView = createTableView()
        contentView.addSubview(tableView)
        
        yangli = UIButton(type:.custom)
        yangli.frame = CGRect(x:20,y:170,width:21, height:21)
        yangli.addTarget(self, action: #selector(self.yangliBtnClicked), for: .touchUpInside)
        yangli.setBackgroundImage(UIImage(named: "icon_xz_1"), for: UIControlState())
        contentView.addSubview(yangli)
        
        let yanglliText = UILabel(frame: CGRect(x:50,y:170,width:32,height:20))
        yanglliText.text = "阳历"
        yanglliText.font = UIFont.systemFont(ofSize: 15)
        yanglliText.textColor = UIColor.darkGray
        contentView.addSubview(yanglliText)
        
        yinli = UIButton(type:.custom)
        yinli.frame = CGRect(x:frame.width - 82,y:170,width:21, height:21)
        yinli.addTarget(self, action: #selector(self.yinliBtnClicked), for: .touchUpInside)
        yinli.setBackgroundImage(UIImage(named: "icon_wxz"), for: UIControlState())
        contentView.addSubview(yinli)
        
        let yinliText = UILabel(frame: CGRect(x:frame.width - 52,y:170,width:32,height:20))
        yinliText.text = "农历"
        yinliText.font = UIFont.systemFont(ofSize: 15)
        yinliText.textColor = UIColor.darkGray
        contentView.addSubview(yinliText)
        
        self.addSubview(self.contentView)
        
        tableView.register(UINib(nibName: "PlanExecTimeCellView", bundle: nil), forCellReuseIdentifier: planDatePickerId)
        
    }
    
    func createTableView() -> UITableView{
        if self.tableView == nil{
            tableView = UITableView(frame: CGRect(x: 0, y: 40, width: SCREEN_WIDTH, height: tabViewHeight), style: .plain)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.layer.borderWidth = 1
            tableView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        }
        
        return tableView!  
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
    
    func commitBtnClicked(){
        let cell = self.tableView.cellForRow(at: [0,0]) as! PlanExecTimeCellView
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let time = [1:"阳历 ", 2:"农历 "][calendarType]! + dateFormatter.string(from: cell.datePicker.date)
        let textLabel = self.rootVC.tableView.cellForRow(at: [0,5])?.detailTextLabel
        textLabel?.text = time
        textLabel?.textColor = UIColor.gray
        
        self.dismiss()
    }
    
    func yangliBtnClicked(){
        yangli.setBackgroundImage(UIImage(named: "icon_xz_1"), for: UIControlState())
        yinli.setBackgroundImage(UIImage(named: "icon_wxz"), for: UIControlState())
        calendarType = 1
    }
    
    func yinliBtnClicked(){
        yangli.setBackgroundImage(UIImage(named: "icon_wxz"), for: UIControlState())
        yinli.setBackgroundImage(UIImage(named: "icon_xz_1"), for: UIControlState())
        calendarType = 2
    }
    
    func showInViewController(_ viewController:UITableViewController){
        self.rootVC = viewController
        self.showInView(viewController.view)
    }
    
    fileprivate func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentHeight)
            self.rootVC.tableView.deselectRow(at: [0,5], animated: true)
            self.rootVC.tableView.deselectRow(at: [1,0], animated: true)
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
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

extension ChooseDateView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tabViewHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.planDatePickerId) as! PlanExecTimeCellView
        return cell
    }
        
}
