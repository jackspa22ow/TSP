//
//  MultipleBillPaymentVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class MultipleBillPaymentVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var aryOfTitle = ["Airtel Postpaid","TATA Power","my_home_bill\nMSEDCL CO LTD","Canara HSBC OBC Life Insurance","ICICI Bank","Life Insurance Corporation of India","Jio","My_TATA\nTATA SKY","HDFC Bank"]
    
    var aryOfSubTitle = ["9984328711","8435279521","432154789","432154789","8435 **** **** 9521","432154789","8435279521","9987568711","9984 **** **** 5711"]
    
    var aryOfTitleImage = ["Credit_card_Bill","loan repayment","insurance premium","municipal services","municipal services","Credit_card_Bill","loan repayment","insurance premium","municipal services"]
    
    var aryOfPrice = ["₹ 1250","₹ 800","₹ 1200","₹ 2500","₹ 6000","₹ 2000","₹ 250","₹ 350","₹ 8000"]
    
    var aryOfDue = [true,true,true,true,false,false,false,false,false]
    
    var aryOfRadio = [true,true,false,true,false,true,false,false,false]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MultipleBillCell.nib, forCellReuseIdentifier: MultipleBillCell.identifier)
        self.tblView.estimatedRowHeight = 70

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
        self.aryOfTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleBillCell.identifier, for: indexPath) as? MultipleBillCell else {
            fatalError("XIB doesn't exist.")
        }
        
        cell.imgIcon.image = UIImage(named: self.aryOfTitleImage[indexPath.row])
        cell.lblTitle.text = self.aryOfTitle[indexPath.row]
        cell.lblSubTitle.text = self.aryOfSubTitle[indexPath.row]
        cell.lblPrice.text = self.aryOfPrice[indexPath.row]

        if self.aryOfDue[indexPath.row]{
            cell.imgDue.isHidden = false
        }else{
            cell.imgDue.isHidden = true
        }
        
        if self.aryOfRadio[indexPath.row]{
            cell.viewRadio.isHidden = false
        }else{
            cell.viewRadio.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.aryOfRadio[indexPath.row]{
            self.aryOfRadio[indexPath.row] = false
        }else{
            self.aryOfRadio[indexPath.row] = true
        }
        self.tblView.reloadData()
    }
    
   
}
