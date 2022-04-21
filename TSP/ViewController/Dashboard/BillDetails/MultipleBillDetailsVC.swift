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
    
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    var transactionIDs = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
        self.viewLeft.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
        self.viewRight.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)

        self.tblView.register(MultipleBillTransactionCell.nib, forCellReuseIdentifier: MultipleBillTransactionCell.identifier)
        self.tblView.register(MultipleBilllTrasactionTitleCell.nib, forCellReuseIdentifier: MultipleBilllTrasactionTitleCell.identifier)
        self.tblView.register(MultipleBillTransactionAmountCell.nib, forCellReuseIdentifier: MultipleBillTransactionAmountCell.identifier)
        self.tblView.register(MultipleBillTransactionFooterCell.nib, forCellReuseIdentifier: MultipleBillTransactionFooterCell.identifier)
        self.tblView.register(SelectedBillContentCell.nib, forCellReuseIdentifier: SelectedBillContentCell.identifier)
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
//        self.tblView.rowHeight = UITableView.automaticDimension
//
//        self.tblView.estimatedRowHeight = 70
                
        self.multipleBillDetailsViewModel.getMultipleBillDetails(transactionIDs: self.transactionIDs) { response in
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
            
//            let status = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[0].status

//            if status == "success" || status == "Success" || status == "SUCCESS"{
//                self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
//                self.imgStatus.image = UIImage(named: "ic_thumbsup")
//            }else{
//                self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")
//                self.imgStatus.image = UIImage(named: "ic_thumbsup_down")
//            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnExpandCollapsAction(sender : UIButton)  {
        var obj = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[sender.tag - 1]
        obj.isExpand = !(obj.isExpand ?? false)
        self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[sender.tag - 1] = obj
        
        self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
}

extension MultipleBillDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == (self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 1) {
            return 145
        } else if section == (self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 2) {
            return 235
        }
        return 64
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header : MultipleBilllTrasactionTitleCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBilllTrasactionTitleCell.self)) as! MultipleBilllTrasactionTitleCell
            
            return header.contentView

        } else if section == self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 1 {
            let header : MultipleBillTransactionAmountCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionAmountCell.self)) as! MultipleBillTransactionAmountCell
            
            var totalAmount : Double = 0.0
            for obj in self.multipleBillDetailsViewModel.aryOfMultipleBillDetails {
                if let amount = obj.amount {
                    totalAmount = totalAmount + Double(amount)
                }
            }
            var billDatee = String()
            if let str = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[0].paymentDate{
                if str.contains("T"){
                    let vall = str.components(separatedBy: "T")
                    billDatee = self.convertDateFormater(vall[0])
                }else{
                    billDatee = ""
                }
            }else{
                billDatee = ""
            }
            
            let status = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[0].status

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
        } else if section == self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 2 {
            let header : MultipleBillTransactionFooterCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionFooterCell.self)) as! MultipleBillTransactionFooterCell
    
            return header.contentView
        }
        else {
            let header : MultipleBillTransactionCell = tableView.dequeueReusableCell(withIdentifier: String(describing : MultipleBillTransactionCell.self)) as! MultipleBillTransactionCell

            let obj = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[section - 1]
            header.lblTitle.text = obj.billerName
            
            for params in obj.customerParams ?? []{
                let val = params.primary
                if val == true{
                    header.lblSubTitle.text = params.value
                    break
                }
            }
            header.btnExpandCollaps.tag = section
            header.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
            header.btnExpandCollaps.addTarget(self, action: #selector(btnExpandCollapsAction(sender:)), for: .touchUpInside)

            if (obj.customerParams?.count ?? 0) > 0 {
                ///arrow rotate
                header.imgIcon.isHidden = false
                header.btnExpandCollaps.transform = CGAffineTransform(rotationAngle: (obj.isExpand ?? false) ? 0.0 : .pi)
                ///change cell color and arrow to updown
                if (obj.isExpand ?? false) == true{
                    header.ingArrow.image = UIImage(named: "ic_up")
                }else{
                    header.ingArrow.image = UIImage(named: "ic_down")
                }
            }else{
                header.imgIcon.isHidden = true
            }
            
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
        if section == 0 || section == self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 1 || section == self.multipleBillDetailsViewModel.aryOfMultipleBillDetails.count + 2 {
            return 0
        }
        let sectionData = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[section - 1]

        return  (sectionData.isExpand ?? false) ? 1 : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionData = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[indexPath.section - 1]

        return CGFloat((sectionData.customerParams?.count ?? 0) * 64) + 24 + 70 + 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedBillContentCell.identifier, for: indexPath) as? SelectedBillContentCell else {
            fatalError("XIB doesn't exist.")
        }
        

        let sectionData = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[indexPath.section - 1]

        cell.customerParams = sectionData.customerParams ?? []
        cell.amountValue = "₹ \(sectionData.amount!)"

        var billDatee = String()
        if let str = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[0].paymentDate{
            if str.contains("T"){
                let vall = str.components(separatedBy: "T")
                billDatee = self.convertDateFormater(vall[0])
            }else{
                billDatee = ""
            }
        }else{
            billDatee = ""
        }
        
        cell.trasactionDate = billDatee
        let status = self.multipleBillDetailsViewModel.aryOfMultipleBillDetails[0].status

        if status == "success" || status == "Success" || status == "SUCCESS"{
            cell.trasactionStatus = "Completed"
        } else {
            cell.trasactionStatus = "Faile"
        }
        cell.setupData()
        
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
