//
//  ChooseDataView.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/9/14.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import SnapKit

class ChooseDataView: UIView {

        fileprivate var contentHeight:CGFloat = 180
        fileprivate var topbarHeight:CGFloat = 65
        fileprivate var tabViewHeight:CGFloat = 120
        var delegate: ChooseDateDelegate?
        fileprivate var bgView:UIView!
        fileprivate var contentView:UIView!
        fileprivate var rootVC:CTInfoViewController?
        fileprivate var tableView:UITableView!
        
        fileprivate let planDatePickerId = "planDatePicker"
        
        fileprivate var yangli:UIButton!
        fileprivate var yinli:UIButton!
        
        fileprivate var calendarType = 1
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
            self.bgView.backgroundColor = UIColor.black
            self.bgView.alpha = 0.0
            self.addSubview(self.bgView)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.bgViewTapped))
            self.bgView.addGestureRecognizer(tapGesture)
            
            self.contentView = UIView.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
            // self.contentView = UIView(frame: .zero)
            
            self.contentView.backgroundColor = UIColor.white
            
            let cancelBtn = UIButton(type:.custom)
            cancelBtn.frame = CGRect(x:0, y:0, width:43, height:43)
            cancelBtn.addTarget(self, action: #selector(self.cancelBtnClicked), for: .touchUpInside)
            cancelBtn.setImage(UIImage(named: "icon_gb"), for: UIControlState())
            contentView.addSubview(cancelBtn)
            
            let commitBtn = UIButton(type:.custom)
            commitBtn.frame = CGRect(x:frame.width - 43, y:0, width:43, height:43)
            commitBtn.addTarget(self, action: #selector(self.commitBtnClicked), for: .touchUpInside)
            commitBtn.setImage(UIImage(named: "icon_dg"), for: UIControlState())
            contentView.addSubview(commitBtn)
            
            tableView = createTableView()
            contentView.addSubview(tableView)
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
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let time = dateFormatter.string(from: cell.datePicker.date)
            delegate?.didchose(date: time)
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
        
        func showInViewController(_ viewController: CTInfoViewController ){
            self.rootVC = viewController
            self.showInView(viewController.view)
        }
        
        fileprivate func dismiss(){
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.alpha = 0.0
                self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentHeight)
                self.rootVC?.tableView.deselectRow(at: [0,3], animated: true)
                self.rootVC?.tableView.deselectRow(at: [1,0], animated: true)
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        }
        
        func showInView(_ parentView:UIView) {
            parentView.addSubview(self)
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.alpha = 0.4
                self.contentView.snp.makeConstraints({make in
                    make.width.equalToSuperview()
                    make.height.equalTo(self.contentHeight)
                    make.bottom.equalToSuperview()
                })
            })
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
    
extension ChooseDataView : UITableViewDelegate,UITableViewDataSource{
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
