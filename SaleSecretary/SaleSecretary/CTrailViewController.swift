//
//  CTrailViewController.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/8.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import UIKit

protocol TrailMsgReloadDelegate {
    func reloadTrailMsg()
}

class CTrailViewController: UIViewController {

    @IBOutlet weak var trailTableView: UITableView!
    
    var custInfo : Customer?
    
    let contactDb = CustomerDBOp.defaultInstance()
    var trailInfo : [TrailMsg] = []
    var displayData  = [ String : [TrailMsg] ]()
    var years : [String] = []
    
    static var instance : CTrailViewController!
    
    let trailCell = "trailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailTableView.tableFooterView = UIView()
        
        self.trailTableView.delegate = self
        self.trailTableView.dataSource = self
        self.generateDate()
        self.createDisplayData(info: self.trailInfo)
        self.trailTableView.register( UINib(nibName: String(describing: TrailMsgCell.self ), bundle: nil) , forCellReuseIdentifier: self.trailCell )
        self.trailTableView.separatorStyle = .none
        CTrailViewController.instance = self
    }
    
    func generateDate() {
        self.trailInfo = self.contactDb.queryTrailInfo(cusInfoId: (self.custInfo?.id)!)
        self.trailInfo.sort { (x, y) -> Bool in
            let dx = DateFormatterUtils.getDateFromString(x.date!, dateFormat: "yyyy/MM/dd HH-mm-ss")
            let dy = DateFormatterUtils.getDateFromString(y.date!, dateFormat: "yyyy/MM/dd HH-mm-ss")
            return (dx > dy)
        }
    }
    
    func createDisplayData( info : [TrailMsg]) {
        self.displayData.removeAll()
        for msg in info {
            if (msg.date?.characters.count)! > 0 {
                let year = msg.date?.components(separatedBy: "/")[0]
                if self.displayData[year!] == nil {
                    self.displayData[year!] =  [msg]
                }else {
                    self.displayData[year!]?.append(msg)
                }
            }
        }
        let tmp = self.displayData.keys
        for t in tmp {
            self.years.append(t)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CTrailViewController : UITableViewDelegate , UITableViewDataSource {
    
    // required
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: self.trailCell , for: indexPath) as! TrailMsgCell
        let msg : TrailMsg = self.displayData[self.years[indexPath.section]]![indexPath.row]
        cell.content.text = msg.content
        cell.time.text = msg.date
        cell.title.text = msg.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = UITableViewHeaderFooterView.init()
        let picView = UIImageView.init(frame: CGRect.init(x: 5, y: 0, width: 60, height: 60))
        picView.image = UIImage.init(named: "yuan")
        head.contentView.backgroundColor = UIColor.white
        head.contentView.addSubview(picView)
        return head
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return  (self.displayData[self.years[section]]?.count)!
    }
    // end of required
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.displayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension CTrailViewController : TrailMsgReloadDelegate {
    func reloadTrailMsg(){
        self.generateDate()
        self.createDisplayData(info: self.trailInfo)
        self.trailTableView.reloadData()
    }
}


