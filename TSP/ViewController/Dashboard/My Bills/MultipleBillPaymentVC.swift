//
//  MultipleBillPaymentVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class MultipleBillPaymentVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var btnProceed: UIButton!
    
    let homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MultipleBillCell.nib, forCellReuseIdentifier: MultipleBillCell.identifier)
        self.tblView.register(MyBillsCell.nib, forCellReuseIdentifier: MyBillsCell.identifier)
        self.tblView.estimatedRowHeight = 70

        self.btnProceed.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        self.homeViewModel.getMyBills { success in
            Utilities.sharedInstance.dismissSVProgressHUD()
            if self.homeViewModel.dicOfMyBillList.content.count > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoDataFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoDataFound.isHidden = false
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonHandlerProceed(_ sender: Any) {
        let myBills = self.homeViewModel.dicOfMyBillList.content.filter{ $0.isSelected == false && ($0.billDue == true || $0.billDue == nil) }
                
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "SelectedBillVC")as! SelectedBillVC
        nextVC.selectedBills = myBills
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}


extension MultipleBillPaymentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.dicOfMyBillList.content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillsCell.identifier, for: indexPath) as? MyBillsCell else {
            fatalError("XIB doesn't exist.")
        }
        cell.consDisplayRadioButton.priority = UILayoutPriority(999)
        
        let json = self.homeViewModel.dicOfMyBillList.content[indexPath.row]
        
//        let fileUrl = URL(string: json.customerParams)
//        cell.imgIcon.sd_setImage(with: fileUrl)
        cell.lblNickName.text = json.billNickName
        cell.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
        
        cell.lblTitle.text = json.billerName
        
        for obj in json.customerParams{
            let val = obj.primary
            if val == true{
                cell.lblSubTitle.text = obj.value
                break
            }
        }
        
        if let amount = json.amount {
            cell.lblPrice.text = "₹ \(amount)"
        }
    
        cell.imgDue.isHidden = (json.billDue == true || json.billDue == nil) ? false : true
        cell.viewRadio.isHidden = json.isSelected ?? true

        cell.imgDot.isHidden = true

        cell.viewRadioContainer.isHidden = cell.imgDue.isHidden
        
        cell.viewRadio.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var json = self.homeViewModel.dicOfMyBillList.content[indexPath.row]
        json.isSelected = !(json.isSelected ?? true)
        self.homeViewModel.dicOfMyBillList.content[indexPath.row] = json
        
        self.tblView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
    }
    
   
}
