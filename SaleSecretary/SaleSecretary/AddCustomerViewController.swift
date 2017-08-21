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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    func initSetting() {
        self.collectionView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        let viewParent = self.parent as! CTChooseNewerController
        viewParent.pressCancel()
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
        // Register cell classes
        self.collectionView.register( UINib.init(nibName: String.init(describing: AddingCustomViewCell.self ) , bundle: nil) , forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension AddCustomerViewController  : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.groupArr.count == 0 {
            self.groupArr = (self.parent as! CTChooseNewerController).groupsInDb
        }
        return self.groupArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddingCustomViewCell
        initCell(c: cell)
        cell.addingButton.setTitle( self.groupArr[indexPath.row].group_name , for: .normal)
        cell.addingButton.setTitleColor( ContactCommon.THEME_COLOR , for: .normal)
        cell.addingButton.setTitleColor( UIColor.white , for: .selected )
        cell.addingButton.addTarget(self , action: #selector(self.choosedButton(_:)), for: .touchUpInside )
        return cell
    }
    
    func choosedButton(_ sender: UIButton!) {
        let tag = sender.tag
        let cell = self.collectionView.cellForItem(at: [0,tag]) as! AddingCustomViewCell
        cell.addingButton.isSelected = true
        cell.addingButton.backgroundColor = ContactCommon.THEME_COLOR
//        cell.addingButton.setTitleColor(UIColor.white , for: .selected)
        cell.addingButton.titleLabel?.textColor = UIColor.white
    }
    
    func changeButtonBackGroudColor(_ index:Int){
        self.currentSel = index
        let cell = self.collectionView.cellForItem(at: [0,0]) as! AddingCustomViewCell
        
        cell.addingButton.backgroundColor = ContactCommon.THEME_COLOR
    }
    
    
    func initCell(c : AddingCustomViewCell){
        c.addingButton.layer.borderWidth = 1
        c.addingButton.layer.borderColor = ContactCommon.THEME_COLOR.cgColor
        c.addingButton.layer.cornerRadius = 1.0   // need  dynamic setting
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( self.groupArr[indexPath.row].group_name! as NSString ).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).width
//        NSLog("size : \(width) ---- \(self.defaultButtonHeight)")
        return CGSize(width: width + 40 , height: self.defaultButtonHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 5
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
