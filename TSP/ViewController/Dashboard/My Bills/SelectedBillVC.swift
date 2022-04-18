//
//  SelectedBillVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class SelectedBillSection {
    var title : String?
    var list : [String]?
    var isColleps : Bool?
    init() {
    }
    
    init(title : String? , list : [String]?, isColleps : Bool?) {
        self.title = title
        self.list = list
        self.isColleps = isColleps
    }
}

class SelectedBillVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var arrayOfIcons = ["Credit_card_Bill","loan repayment","insurance premium"]
            
    var aryOfSubTitle = ["9984328711","8435279521","432154789"]
    
    var aryOfPrice = ["₹ 1250","₹ 800","₹ 1200"]
    
    var aryOfDue = [true,true,true]

    var selectedBills: [MyBillsContent]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(SelectedBillHeaderCell.nib, forCellReuseIdentifier: SelectedBillHeaderCell.identifier)
        self.tblView.register(SelectedBillContentCell.nib, forCellReuseIdentifier: SelectedBillContentCell.identifier)
        self.tblView.register(SelectedBillFooterCell.nib, forCellReuseIdentifier: SelectedBillFooterCell.identifier)
        
        self.tblView.estimatedSectionHeaderHeight = 60

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Button action arrow in header
    @objc func buttonHandlerSectionArrowTap(sender : UIButton)  {
        var sectionData = selectedBills[sender.tag]
        sectionData.isColleps = !(sectionData.isColleps ?? false)
        selectedBills[sender.tag] = sectionData
        self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    

}


extension SelectedBillVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedBills.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.selectedBills.count-1 == section{
            return 230
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : SelectedBillHeaderCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SelectedBillHeaderCell.self)) as! SelectedBillHeaderCell
        
        let sectionData = selectedBills[section]
        header.lblTitle.text = sectionData.billerName
        header.lblSubTitle.text = sectionData.billNickName
        header.imgDue.isHidden = (sectionData.billDue == true || sectionData.billDue == nil) ? false : true
        header.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
        header.lblPrice.text = "₹ \(sectionData.amount!)"
        
        if sectionData.customerParams.count > 0 {
            ///arrow rotate
            header.imgArrow.isHidden = false
            header.buttonHandlerAction.transform = CGAffineTransform(rotationAngle: (sectionData.isColleps ?? false) ? 0.0 : .pi)
            header.buttonHandlerAction.tag = section
            header.buttonHandlerAction.addTarget(self, action: #selector(buttonHandlerSectionArrowTap(sender:)), for: .touchUpInside)

            ///change cell color and arrow to updown
            if sectionData.isColleps == true{
                header.imgArrow.image = UIImage(named: "ic_up")
                header.lblPrice.isHidden = true
            }else{
                header.imgArrow.image = UIImage(named: "ic_down")
                header.lblPrice.isHidden = false
            }

        }else{
            header.imgArrow.isHidden = true
            header.lblPrice.isHidden = false
        }
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let header : SelectedBillFooterCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SelectedBillFooterCell.self)) as! SelectedBillFooterCell

        header.lblTotalBillAcount.text = "(Total \(selectedBills.count) Billers"
        
        var totalAmount : Double = 0.0
        for obj in selectedBills {
            if let amount = obj.amount {
                totalAmount = totalAmount + Double(amount)
            }
        }
        header.lblTotalBillAmount.text = "₹ \(totalAmount)"

        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = selectedBills[section]
    
        return  sectionData.isColleps ?? false ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionData = selectedBills[indexPath.section]

        return CGFloat(sectionData.customerParams.count * 64) + 24 + 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedBillContentCell.identifier, for: indexPath) as? SelectedBillContentCell else {
            fatalError("XIB doesn't exist.")
        }
        

        let sectionData = selectedBills[indexPath.section]

        cell.customerParams = sectionData.customerParams
        cell.amountValue = "₹ \(sectionData.amount!)"
        
        cell.setupData()
        
        return cell
    }
    
}
