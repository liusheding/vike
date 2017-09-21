//
//  CTChangeGroupViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/26.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol GroupDataDelegate {
    func reloadGroupData()
}

private let reuseIdentifier = "ChangeCell"
class CTChangeGroupViewController: UIViewController {

    var groupArr : [MemGroup] = []
    let addIconTag : MemGroup = MemGroup.init(id: "0", gn: "")
    let defaultFontSize : CGFloat  = 16
    let defaultBottomTopHeight : CGFloat = 25
    
    var defaultButtonHeight : CGFloat = 0
    var currentSel : Int = 0
    let defaultLeftRight : CGFloat = 10
    //    var tableViewSel : Int = -1
    
    var defaultSelectGroup : Int = -1
    
    let contextDb = CustomerDBOp.defaultInstance()
    
    let sectionInsets = UIEdgeInsets(top: -5.0, left: 5.0, bottom: 0.0, right: 5.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    static var instance : CTChangeGroupViewController!
    
    func initSetting() {
        self.groupArr.append( self.addIconTag ) // the last for "Add button"
    }
    
    func reloadData() {
        self.groupArr = MemGroup.toMemGroup(dbGroup: self.contextDb.getGroupInDb(userId: APP_USER_ID! , true))
        self.groupArr.append( self.addIconTag ) // the last for "Add button"
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        let viewParent = self.parent as! ContactTableViewController
        viewParent.pressCancel()
        viewParent.reloadTableViewData()
    }
    
    
    @IBAction func chooseGroupAction(_ sender: Any) {
        
        let g = self.groupArr[self.currentSel]
        
        let view = self.parent as! ContactTableViewController
        let tmpIndexPath = view.changeGroupIndex
        let cust = view.contactsCells[tmpIndexPath.section - 1].friends?[tmpIndexPath.row]
        
        if self.currentSel != tmpIndexPath.row  {
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = ""
            
            if cust?.id.characters.count == 0 {
                let phone = (cust?.phone_number?.count)!>0 ? cust?.phone_number![0] ?? "" :""
                let r = NetworkUtils.postBackEnd("R_BASE_TXL_CUS_INFO", body:["userId": APP_USER_ID! , "cellphoneNumber" :  phone  ] , handler: { (json) in
                    let id = json["body"]["id"].stringValue
                    let request = NetworkUtils.postBackEnd("U_TXL_CUS_INFO", body: ["id": id , "userId": APP_USER_ID! , "cusGroupId" : g.id ], handler: { (json) in
                        self.contextDb.updateByPhone(phone: phone , g: g )
                    })
                    request.response(completionHandler: { _ in
                        view.reloadTableViewData()
                        hud.hide(animated: true)
                    })
                })
                r.response(completionHandler: { (_) in  })
                
            }else {
                let request = NetworkUtils.postBackEnd("U_TXL_CUS_INFO", body: ["id": cust?.id ?? "" , "userId": APP_USER_ID! , "cusGroupId" : g.id ], handler: { (json) in
                    self.contextDb.updateById(id: (cust?.id)! , newGroup: g.id )
                })
                request.response(completionHandler: { _ in
                    view.reloadTableViewData()
                    hud.hide(animated: true)
                })
            }
        }
        view.pressCancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init height
        self.defaultButtonHeight = (ContactCommon.groupDefault).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).height + self.defaultBottomTopHeight
        
        self.collectionView.layer.borderColor = UIColor.gray.cgColor
        self.initSetting()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self 
        self.collectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.white
        self.view.layer.cornerRadius = 10
        // Register cell classes
        self.collectionView.register( UINib.init(nibName: String.init(describing: AddingCustomViewCell.self ) , bundle: nil) , forCellWithReuseIdentifier: reuseIdentifier)
        CTChangeGroupViewController.instance = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
extension CTChangeGroupViewController  : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
            
            return self.groupArr.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddingCustomViewCell
            
            if indexPath.row == (self.groupArr.count-1) {
                // remove setting
                
                cell.addingButton.setTitle("", for: .normal)
                cell.addingButton.setImage(UIImage(named: "icon_tj") , for: .normal )
                cell.addingButton.tintColor = ContactCommon.THEME_COLOR
                cell.addingButton.removeTarget(self , action: #selector(self.choosedButton(_:)) , for: .touchDown )
                cell.addingButton.addTarget(self , action: #selector(self.addNewGroup) , for: .touchDown  )
                cell.addingButton.frame = CGRect.init(x: 5, y: 5, width: cell.addingButton.frame.width + self.defaultLeftRight , height: cell.addingButton.frame.height)
                cell.addingButton.tag = indexPath.row
                cell.addingButton.isSelected = false
                cell.addingButton.backgroundColor = UIColor.clear
                cell.addingButton.layer.borderColor = UIColor.white.cgColor
                
            }else {
                if indexPath.row == 0 {
                    cell.addingButton.isSelected = true
                    cell.addingButton.tintColor = ContactCommon.THEME_COLOR
                    cell.addingButton.backgroundColor = ContactCommon.THEME_COLOR
                }else {
                    cell.addingButton.isSelected = false
                    cell.addingButton.tintColor = UIColor.clear
                    cell.addingButton.backgroundColor = UIColor.clear
                }
                
                cell.addingButton.layer.borderWidth = 1
                cell.addingButton.layer.borderColor = ContactCommon.THEME_COLOR.cgColor
                cell.addingButton.layer.cornerRadius = 3.0
                
                cell.addingButton.setTitle( self.groupArr[indexPath.row].group_name , for: .normal)
                cell.addingButton.setTitleColor( ContactCommon.THEME_COLOR , for: .normal)
                cell.addingButton.setTitleColor( UIColor.white , for: .selected )
                cell.addingButton.setTitleColor( UIColor.white , for: .focused)
                cell.addingButton.frame = CGRect.init(x: 5 , y: 5, width: ( self.groupArr[indexPath.row].group_name as NSString ).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).width + self.defaultLeftRight , height: cell.addingButton.frame.height)
                cell.addingButton.tag = indexPath.row
                print("____====++++\(String(describing: cell.addingButton.titleLabel?.text))")
                cell.addingButton.removeTarget(self, action: #selector(self.addNewGroup), for: .touchDown )
                cell.addingButton.addTarget(self , action: #selector(self.choosedButton(_:)), for: .touchDown )
                
                //
                cell.addingButton.setImage(UIImage.init(), for: .normal )
                cell.addingButton.imageView?.isHidden = true
                
            }
            
            //cell.backgroundColor = UIColor.red
            return cell
        }
        
        func choosedButton(_ sender: UIButton!) {
            
            self.currentSel = sender.tag
            let cell = self.collectionView.cellForItem(at: [0, self.currentSel ]) as! AddingCustomViewCell
            cell.addingButton.isSelected = true
            cell.addingButton.tintColor = ContactCommon.THEME_COLOR
            cell.addingButton.backgroundColor = ContactCommon.THEME_COLOR
            self.changeButtonBackGroudColor(self.currentSel)
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
        
        func addNewGroup() {
            let alertController = UIAlertController(title: "添加分组", message: "请输入分组名（长度限制10个字）！",preferredStyle: .alert)
            
            alertController.addTextField {
                (textField: UITextField!) -> Void in
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "添加", style: .default, handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let groupName = alertController.textFields!.first!
                
                let msg = ContactCommon.validateGroupName(newName: groupName.text!, group: self.groupArr)
                if msg.characters.count > 0 {
                    let uc = UIAlertController(title: "警告", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                    uc.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default))
                    self.present( uc , animated: true, completion: nil)
                    return
                }
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.text = "加载中..."
                // 同步到服务器和本地数据库
                let request = NetworkUtils.postBackEnd("C_TXL_CUS_GROUP", body: ["userId" : APP_USER_ID! , "name" : groupName.text! ] ){
                    json in
                    print("++++===\(json)")
                    let dt = json["body"]["id"].stringValue
                    self.contextDb.storeGroup(id: dt , group_name: groupName.text!, userId: APP_USER_ID!)
                    self.groupArr = MemGroup.toMemGroup(dbGroup: self.contextDb.getGroupInDb(userId: APP_USER_ID!, true))
                    self.groupArr.append( self.addIconTag )
                }
                request.response(completionHandler: { _ in
                    hud.hide(animated: true)
                    self.collectionView.reloadData()
                })
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = ( self.groupArr[indexPath.row].group_name as NSString ).size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.defaultFontSize )]).width
            var tmp : CGFloat = 20
            if indexPath.row == self.groupArr.count - 1 {
                tmp = 49
            }
            return CGSize(width: width + tmp , height: self.defaultButtonHeight )
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
            return 7
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return self.sectionInsets
        }

        // Uncomment this method to specify if the specified item should be highlighted during tracking
        func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            return true
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    }

extension CTChangeGroupViewController : GroupDataDelegate {
    func reloadGroupData() {
        self.reloadData()
        self.collectionView.reloadData()
    }
}

