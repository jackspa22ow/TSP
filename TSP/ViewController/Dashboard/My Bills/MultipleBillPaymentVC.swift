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

    var aryOfTitle = ["Airtel Postpaid","TATA Power","my_home_bill\nMSEDCL CO LTD","Canara HSBC OBC Life Insurance","ICICI Bank","Life Insurance Corporation of India","Jio","My_TATA\nTATA SKY","HDFC Bank"]
    
    var aryOfSubTitle = ["9984328711","8435279521","432154789","432154789","8435 **** **** 9521","432154789","8435279521","9987568711","9984 **** **** 5711"]
    
    var aryOfTitleImage = ["Credit_card_Bill","loan repayment","insurance premium","municipal services","municipal services","Credit_card_Bill","loan repayment","insurance premium","municipal services"]
    
    var aryOfPrice = ["₹ 1250","₹ 800","₹ 1200","₹ 2500","₹ 6000","₹ 2000","₹ 250","₹ 350","₹ 8000"]
    
    var aryOfDue = [true,true,true,true,false,false,false,false,false]
    
    var aryOfRadio = [true,true,false,true,false,true,false,false,false]
    let homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MultipleBillCell.nib, forCellReuseIdentifier: MultipleBillCell.identifier)
        self.tblView.register(MyBillsCell.nib, forCellReuseIdentifier: MyBillsCell.identifier)
        self.tblView.estimatedRowHeight = 70

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
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "SelectedBillVC")as! SelectedBillVC
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
        
        cell.lblPrice.text = "₹ \(json.amount!)"

        cell.imgDue.isHidden = (json.billDue == true || json.billDue == nil) ? false : true
        cell.viewRadio.isHidden = json.isSelected ?? true

        cell.imgDot.isHidden = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var json = self.homeViewModel.dicOfMyBillList.content[indexPath.row]
        json.isSelected = !(json.isSelected ?? true)
        self.homeViewModel.dicOfMyBillList.content[indexPath.row] = json
        
        self.tblView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
    }
    
   
}
