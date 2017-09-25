//
//  SMSDetailController.swift
//  SaleSecretary
//
//  Created by liusheding on 2017/8/1.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import RxSwift

class SMSDetailViewController : UIViewController {
    
    
    var schedule: MessageSchedule!
    
    @IBOutlet weak var textContentView: UITextView!

    @IBOutlet weak var colletions: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var recLabel: UILabel!
    
    var executeTime: String! {
        
        didSet {
            self.schedule.executeTime = self.executeTime
        }
    }
    
    var receiptions: [MsgKH] = [] {
        
        didSet {
            self.numberLabel.text = "总共\(self.receiptions.count)人"
        }
    }
    
    override func viewDidLoad() {
        textContentView.sizeThatFits(CGSize(width: textContentView.frame.width, height:300))
        textContentView.text = schedule.content
        textContentView.isUserInteractionEnabled = false
        self.colletions.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customerCocCell")
        self.colletions.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "addCustomerCocCell")
        self.colletions.delegate = self
        self.colletions.dataSource = self
        self.colletions.layer.cornerRadius = 5
        self.colletions.isUserInteractionEnabled = true
        self.loadSchedule()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.dateBtn.titleLabel?.textAlignment = .right
        self.dateBtn.setTitle(schedule.executeTime, for: .normal)
        self.numberLabel.text = "总共\(self.receiptions.count)人"
        self.tipsLabel.snp.makeConstraints({
            make in
            make.centerY.equalTo(self.recLabel.snp.centerY)
            make.left.equalTo(self.recLabel.snp.right).offset(8)
        })
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    
    public func loadSchedule() {
        let _ = NetworkUtils.postBackEnd("R_BASE_DXJH", body: ["id": schedule.id!], handler: {
            json in
            self.schedule = MessageSchedule(json: json["body"])
            self.receiptions = self.schedule.customers
            self.colletions.reloadSections([0])
        })
    }
    
    @IBAction func dataBtnTapped(_ sender: UIButton) {
        let shooseView = ChooseDateView.init(frame: self.view.frame)
        shooseView.delegate = self
        // self.view.addSubview(shooseView)
        shooseView.showInView(self.view)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if self.receiptions.count == 0 {
            Utils.alert("至少有一名短信客户")
            return
        }
        sender.isEnabled = false
        sender.setTitle("保存中", for: .disabled)
        Utils.showLoadingHUB(view: self.view, msg: "保存中...", completion: {hub in
            self.schedule.customers = self.receiptions
            let _ = self.schedule.update() {[unowned self]
                json in
                hub.hide(animated: true)
                let vc = self.navigationController?.viewControllers
                self.navigationController?.popToViewController((vc?[(vc?.count)! - 2])!, animated: true)
            }
        })
    }
    
    @IBAction func deleteTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "删除短信计划", message: "删除后您还可以重新再新建一个",
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "确定删除", style: .destructive, handler: {_ in
            self.schedule.delete({
                _ in
                Utils.showLoadingHUB(view: self.view, msg: "删除成功", completion: nil)
                let vc = self.navigationController?.viewControllers
                self.navigationController?.popToViewController((vc?[(vc?.count)! - 2])!, animated: true)
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension SMSDetailViewController: CustomerSelectDelegate, ChooseDateDelegate {
    
    func selectedRecipients(rec: [Customer]) {
        
        
        for c in rec {
            self.receiptions.append(MsgKH(customer: c))
        }
        self.colletions.reloadSections([0])
    }
    
    func didchose(date: String) {
        self.dateBtn.setTitle(date, for: .normal)
        self.executeTime = date
    }
}

extension SMSDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func launchCustomerSelection(_ sender: Any) {
        
        let vc = UIStoryboard(name: "SMSView", bundle: nil).instantiateViewController(withIdentifier: "CustomerSelectViewController") as! CustomerSelectViewController
        vc.delegate = self
        present(vc, animated: true) {}
    }
    
    func deleteCustomer(_ sender: UITapGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.colletions)
        let item = self.colletions.indexPathForItem(at: point)
        if let i = item {
            let row = i.row
            if row >= 0 && row < self.receiptions.count {
                self.receiptions.remove(at: row)
                self.colletions.reloadSections([0])
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        if row == self.receiptions.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCustomerCocCell", for: indexPath)
            cell.isUserInteractionEnabled = true
            let view = UIView(frame: CGRect(x: 0, y:0, width: 36, height: 36))
            cell.addSubview(view)
            let btn = UIButton(type: .system)
            view.addSubview(btn)
            // btn.setImage(UIImage(named: "icon_tjfz"), for: .normal)
            btn.setBackgroundImage(UIImage(named: "icon_tjfz"), for: .normal)
            btn.backgroundColor = UIColor.clear
            btn.snp.makeConstraints({make in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.center.equalToSuperview()
            })
            btn.isUserInteractionEnabled = true
            btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchCustomerSelection(_:))))
            // btn.addTarget(self, action: ), for: .touchUpOutside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customerCocCell", for: indexPath)
            cell.isUserInteractionEnabled = true
            let view = UIView(frame: CGRect(x: 0, y:0, width: 36, height: 36))
            view.layer.cornerRadius = 18
            view.backgroundColor = ContactCommon.sampleColor[ indexPath.row % ContactCommon.count]
            cell.addSubview(view)
            let label = UILabel()
            view.addSubview(label)
            let name = receiptions[row].cw
            let len = name?.characters.count
            let idx = name?.index((name?.endIndex)!, offsetBy: len!>=2 ? -2 : -len!)
            label.text = name?.substring(from: idx!)
            label.font = UIFont.systemFont(ofSize: 13)
            label.snp.makeConstraints({(make) in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
            })
//            let btn = UIButton.init(type: .custom)
//            btn.setImage(UIImage.init(named: "icon_gb"), for: .normal)
//            cell.addSubview(btn)
//            btn.snp.makeConstraints({make in
//                make.width.equalTo(8)
//                make.height.equalTo(8)
//                make.bottom.equalTo(cell.snp.bottom)
//                make.right.equalTo(cell.snp.right)
//            })
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteCustomer(_:))))
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receiptions.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


extension SMSDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
