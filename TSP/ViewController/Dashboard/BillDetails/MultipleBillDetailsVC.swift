//
//  MultipleBillDetailsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/09/21.
//

import UIKit

class MultipleBillDetailsVC: UIViewController {

    let multipleBillDetailsViewModel = MultipleBillDetailsViewModel()

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewThumsUp: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    
    var transactionIDs = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MultipleBillTransactionCell.nib, forCellReuseIdentifier: MultipleBillTransactionCell.identifier)
        self.tblView.register(MultipleBilllTrasactionTitleCell.nib, forCellReuseIdentifier: MultipleBilllTrasactionTitleCell.identifier)
        self.tblView.register(MultipleBillTransactionAmountCell.nib, forCellReuseIdentifier: MultipleBillTransactionAmountCell.identifier)
        self.tblView.register(MultipleBillTransactionFooterCell.nib, forCellReuseIdentifier: MultipleBillTransactionFooterCell.identifier)
        
        self.tblView.rowHeight = UITableView.automaticDimension

        self.tblView.estimatedRowHeight = 70
        
        
        
        self.multipleBillDetailsViewModel.getMultipleBillDetails(transactionIDs: self.transactionIDs) { response in
            print(response)
        }
        
        
        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.reloadData()
        
        let status = self.aryOfVerifyPaymentModel[0].status

        if status == "success" || status == "Success" || status == "SUCCESS"{
            self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.imgStatus.image = UIImage(named: "ic_thumbsup")
        }else{
            self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")
            self.imgStatus.image = UIImage(named: "ic_thumbsup_down")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MultipleBillDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aryOfVerifyPaymentModel.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == (self.aryOfVerifyPaymentModel.count + 1) {
            return 212
        } else if section == (self.aryOfVerifyPaymentModel.count + 2) {
            return 235
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header : MultipleBilllTrasactionTitleCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBilllTrasactionTitleCell.self)) as! MultipleBilllTrasactionTitleCell
            
            return header.contentView

        } else if section == self.aryOfVerifyPaymentModel.count + 1 {
            let header : MultipleBillTransactionAmountCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionAmountCell.self)) as! MultipleBillTransactionAmountCell
            
            var totalAmount : Double = 0.0
            for obj in self.aryOfVerifyPaymentModel {
                if let amount = obj.amount {
                    totalAmount = totalAmount + Double(amount)
                }
            }
            var billDatee = String()
            if let str = self.aryOfVerifyPaymentModel[0].paymentDate{
                if str.contains("T"){
                    let vall = str.components(separatedBy: "T")
                    billDatee = self.convertDateFormater(vall[0])
                }else{
                    billDatee = ""
                }
            }else{
                billDatee = ""
            }
            
            let status = self.aryOfVerifyPaymentModel[0].status

            if status == "success" || status == "Success" || status == "SUCCESS"{
                header.setupDate(status: "Completed", dateValue: billDatee)
                header.imgCheckUnCheck.image = UIImage(named: "ic_check_white")
                header.vwCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)

            } else {
                header.setupDate(status: "Failed", dateValue: billDatee)
                header.imgCheckUnCheck.image = UIImage(named: "ic_close_white")
                header.vwCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")

            }
            header.lblTotalAmount.text = "₹ \(totalAmount)"
            return header.contentView
        } else if section == self.aryOfVerifyPaymentModel.count + 2 {
            let header : MultipleBillTransactionFooterCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionFooterCell.self)) as! MultipleBillTransactionFooterCell
    
            return header.contentView
        }
        else {
            let header : MultipleBillTransactionCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionCell.self)) as! MultipleBillTransactionCell
            
            let obj = aryOfVerifyPaymentModel[section - 1]
            header.lblTitle.text = obj.billerName
            header.lblSubTitle.text = obj.billerId
            header.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
            //        let sectionData = selectedBills[section]
            //        header.lblTitle.text = sectionData.billerName
            //        header.lblSubTitle.text = sectionData.billerPayuId
            //        header.imgDue.isHidden = (sectionData.billDue == true || sectionData.billDue == nil) ? false : true
            //        header.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
            //        header.lblPrice.text = "₹ \(sectionData.amount!)"
            //
            //        if sectionData.customerParams.count > 0 {
            //            ///arrow rotate
            //            header.imgArrow.isHidden = false
            //            header.buttonHandlerAction.transform = CGAffineTransform(rotationAngle: (sectionData.isColleps ?? false) ? 0.0 : .pi)
            //            header.buttonHandlerAction.tag = section
            //            header.buttonHandlerAction.addTarget(self, action: #selector(buttonHandlerSectionArrowTap(sender:)), for: .touchUpInside)
            //
            //            ///change cell color and arrow to updown
            //            if sectionData.isColleps == true{
            //                header.imgArrow.image = UIImage(named: "ic_up")
            //                header.lblPrice.isHidden = true
            //            }else{
            //                header.imgArrow.image = UIImage(named: "ic_down")
            //                header.lblPrice.isHidden = false
            //            }
            //
            //        }else{
            //            header.imgArrow.isHidden = true
            //            header.lblPrice.isHidden = false
            //        }
            
            return header.contentView
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        let header : MultipleBillTransactionFooterCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionFooterCell.self)) as! MultipleBillTransactionFooterCell
//
//        return header.contentView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        let sectionData = selectedBills[section]
//
//        return  sectionData.isColleps ?? false ? 1 : 0
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let sectionData = selectedBills[indexPath.section]
//
//        return CGFloat(sectionData.customerParams.count * 64) + 24 + 70
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedBillContentCell.identifier, for: indexPath) as? SelectedBillContentCell else {
            fatalError("XIB doesn't exist.")
        }
        

//        let sectionData = selectedBills[indexPath.section]

//        cell.customerParams = sectionData.customerParams
//        cell.amountValue = "₹ \(sectionData.amount!)"
//
//        cell.setupData()
        
        return cell
    }
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
}
