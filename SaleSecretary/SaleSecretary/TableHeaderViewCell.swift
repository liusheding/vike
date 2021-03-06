import UIKit

class TableHeaderViewCell:UITableViewCell
{
    var height:CGFloat = 30.0
    var label:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
    }
    
    class func getHeight() -> CGFloat
    {
        return 30.0
    }
    
    func setDate(_ value:Date)
    {
        self.height  = 30.0
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let text =  dateFormatter.string(from: value)
        
        if (self.label != nil)
        {
            self.label.text = text
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.label = UILabel(frame:CGRect(x: CGFloat((UIScreen.main.bounds.size.width - self.frame.size.width) / 2), y: CGFloat(-8), width: self.frame.size.width, height: height))
        
        self.label.text = text
        self.label.font = UIFont.systemFont(ofSize: 15)
        
        self.label.textAlignment = NSTextAlignment.center
        self.label.shadowOffset = CGSize(width: 0, height: 1)
        self.label.shadowColor = UIColor.white
        
        self.label.textColor = UIColor.darkGray
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.addSubview(self.label)
    }
}
