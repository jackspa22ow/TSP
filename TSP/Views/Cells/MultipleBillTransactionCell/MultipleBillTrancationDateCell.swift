//
//  MultipleBillTrancationDateCell.swift
//  TSP
//
//  Created by Yagnesh Dobariya on 21/04/22.
//

import UIKit

class MultipleBillTrancationDateCell: UITableViewCell {
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var vwCheckBoxWithDate: UIView!
    @IBOutlet weak var vwCheck: UIView!
    @IBOutlet weak var imgCheckUnCheck: UIImageView!
    @IBOutlet weak var lblTransactionDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwCheckBoxWithDate.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDate(status:String,dateValue:String){
        if status == "Completed"{
            let attrs1 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "909196")]
            
            let attributedString1 = NSMutableAttributedString(string:"Completed", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:" - \(dateValue)", attributes:attrs2 as [NSAttributedString.Key : Any])
            
            attributedString1.append(attributedString2)
            self.lblTransactionDate.attributedText = attributedString1
            
            self.imgCheckUnCheck.image = UIImage(named: "ic_check_white")
            self.vwCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        }else{
            let attrs1 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "909196")]
            
            let attributedString1 = NSMutableAttributedString(string:"Failed", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:" - \(dateValue)", attributes:attrs2 as [NSAttributedString.Key : Any])
            
            attributedString1.append(attributedString2)
            self.lblTransactionDate.attributedText = attributedString1
            
            self.imgCheckUnCheck.image = UIImage(named: "ic_close_white")
            self.vwCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")
        }
    }
}
