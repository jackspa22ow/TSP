//
//  HelpRecentOrderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/11/21.
//

import UIKit
import DXPopover

class HelpRecentOrderCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var tblView: UITableView!
    var aryOfTransactionsList : [TransactionsModel] = []
    var btnMoreAction:((_ sender : UIButton) -> ())?

    @IBOutlet weak var lblNoDataFound: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tblView.register(TransactionsCell.nib, forCellReuseIdentifier: TransactionsCell.identifier)
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.lblNoDataFound.text = Constant.NoTransactionsAvailable
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
    

    @objc func btnMore(sender : UIButton) {
        btnMoreAction?(sender)
    }
}
extension HelpRecentOrderCell: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aryOfTransactionsList.count > 3 {
            self.btnViewAll.isHidden = false
        } else {
            if aryOfTransactionsList.count == 0 {
                self.lblNoDataFound.isHidden = false
            } else {
                self.lblNoDataFound.isHidden = true
            }
            self.btnViewAll.isHidden = true
        }
        return aryOfTransactionsList.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsCell.identifier, for: indexPath) as? TransactionsCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = aryOfTransactionsList[indexPath.row]

        cell.lblNickName.text = obj.billNickName
        cell.lblTitle.text = obj.billerName
        cell.lblTitle.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        cell.lblSubTitle.text = obj.txnid
        cell.lblPrice.text = "₹ \(obj.amount ?? 0)"
        cell.lblPrice.textColor = obj.status == "SUCCESS" ? Utilities.sharedInstance.hexStringToUIColor(hex: "020202") : Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")
        cell.lblFailed.isHidden = obj.status == "SUCCESS" ? true : false

        if let str = obj.paymentDate{
            let dateAry = str.components(separatedBy: "T")
            let dateValue = dateAry[0]
            cell.lblDate.text = self.convertDateFormater(dateValue)
        }else{
            cell.lblDate.text = ""
        }

        cell.btnDots.tag = indexPath.row
        cell.btnDots.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)

        return cell
        
    }
    
   
}
