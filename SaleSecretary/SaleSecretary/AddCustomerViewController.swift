//
//  AddCustomerViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/18.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AddCustomerViewController: UIViewController {

    var groupArr : [Group] = []
    let defaultFontSize : CGFloat  = 16
    let defaultBottomTopHeight : CGFloat = 25
    
    var defaultButtonHeight : CGFloat = 0
    var currentSel : Int = -1
    var tableViewSel : Int = -1
    
    let contextDb = CustomerDBOp.defaultInstance()
    
    let sectionInsets = UIEdgeInsets(top: -5.0, left: 5.0, bottom: 0.0, right: 5.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    func initSetting() {
        self.collectionView.layer.borderColor = UIColor.gray.cgColor
        
        // init data 
        self.groupArr = self.contextDb.getGroupInDb()
        let ad = self.groupArr[0]
        self.groupArr.append( ad ) // the last for "Add button"
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        let viewParent = self.parent as! CTChooseNewerController
        viewParent.pressCancel()
    }
    
    
    @IBAction func chooseGroupAction(_ sender: Any) {
        let g = self.groupArr[self.currentSel]
        
        let view = self.parent as! CTChooseNewerController
        let c = view.newCustomer[view.tableViewSel]
        c.group_id = g.group_name!
        self.contextDb.insertCustomer(ctms: c)
        view.pressCancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init height
        self.defaultButtonHeight = (ContactCommon.groupDefault).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).height + self.defaultBottomTopHeight
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.initSetting()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.white
        // Register cell classes
        self.collectionView.register( UINib.init(nibName: String.init(describing: AddingCustomViewCell.self ) , bundle: nil) , forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddCustomerViewController  : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return self.groupArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddingCustomViewCell
        if indexPath.row == (self.groupArr.count-1) {
            cell.addingButton.setTitle("", for: .normal)
            cell.addingButton.setImage(UIImage(named: "icon_tj") , for: .normal )
            cell.addingButton.addTarget(self , action: #selector(self.addNewGroup) , for: .touchDown  )
        }else {
            cell.addingButton.layer.borderWidth = 1
            cell.addingButton.layer.borderColor = ContactCommon.THEME_COLOR.cgColor
            cell.addingButton.layer.cornerRadius = 3.0
            
            cell.addingButton.setTitle( self.groupArr[indexPath.row].group_name , for: .normal)
            cell.addingButton.setTitleColor( ContactCommon.THEME_COLOR , for: .normal)
            cell.addingButton.setTitleColor( UIColor.white , for: .selected )
            cell.addingButton.setImage( UIImage(named: "") , for: .selected )
            cell.addingButton.addTarget(self , action: #selector(self.choosedButton(_:)), for: .touchDown )
            
            cell.addingButton.tag = indexPath.row
        }
        
        return cell
    }
    
    func choosedButton(_ sender: UIButton!) {
        
        self.currentSel = sender.tag
        let cell = self.collectionView.cellForItem(at: [0, self.currentSel ]) as! AddingCustomViewCell
        cell.addingButton.isSelected = true
        cell.addingButton.tintColor = ContactCommon.THEME_COLOR
        cell.addingButton.backgroundColor = ContactCommon.THEME_COLOR
        changeButtonBackGroudColor(self.currentSel)
    }
    
    func changeButtonBackGroudColor(_ indexTag:Int){
        for i in 0  ..< self.groupArr.count - 1     {
            if i != indexTag {
                let cell = self.collectionView.cellForItem(at: [0, i ]) as! AddingCustomViewCell
                cell.addingButton.isSelected = false
                cell.addingButton.tintColor = UIColor.clear
                cell.addingButton.backgroundColor = UIColor.clear
            }
        }
    }
    
    func clickConfirmButton(_ sender: UIButton!)  {
        
    }
    
    func addNewGroup() {
        let alertController = UIAlertController(title: "添加分组", message: "请输入分组名（长度限制10个字）！",preferredStyle: .alert)
        
        
        alertController.addTextField {
            (textField: UITextField!) -> Void in
//            textField.placeholder = "用户名"
//            textField.
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "添加", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let groupName = alertController.textFields!.first!
            var maxId = 0
            for ga in self.groupArr {
                if Int(ga.id) > maxId {
                    maxId = Int(ga.id)
                }
            }
            self.contextDb.storeGroup(id: maxId + 1, group_name: groupName.text!)
            self.groupArr = self.contextDb.groupContentUpdate()
            self.collectionView.reloadData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( self.groupArr[indexPath.row].group_name! as NSString ).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).width
//        NSLog("size : \(width) ---- \(self.defaultButtonHeight)")
        return CGSize(width: width + 40 , height: self.defaultButtonHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if let collectionView = collectionView
//        {
//            collectionView.contentInset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
//            collectionView.scrollIndicatorInsets = collectionView.contentInset
//        }
//    }

}
