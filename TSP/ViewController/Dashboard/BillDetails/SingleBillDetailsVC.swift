//
//  SingleBillDetailsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/09/21.
//

import UIKit

class SingleBillDetailsVC: UIViewController {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewThumsUp: UIView!
    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var lblRaiseComplaint: UILabel!
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var detailPopView: UIView!
    @IBOutlet weak var detailPopViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblDetailViewTitle: UILabel!
    @IBOutlet weak var imgDetailViewArrow: UIImageView!
    @IBOutlet weak var detailViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgBillIcon: UIImageView!
    @IBOutlet weak var lblBillTitle: UILabel!
    @IBOutlet weak var lblBillSubTitle: UILabel!
    @IBOutlet weak var lblCustomerID: UILabel!
    @IBOutlet weak var lblBillPrice: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    
    @IBOutlet weak var imgCheckUnCheck: UIImageView!
    
    @IBOutlet weak var lblPopViewEmail: UILabel!
    @IBOutlet weak var lblPopViewBillDate: UILabel!
    @IBOutlet weak var lblPopViewBillNumber: UILabel!
    @IBOutlet weak var lblPopViewPaymentMode: UILabel!
    @IBOutlet weak var lblPopViewPayTo: UILabel!
    
    let singleBillDetailsViewModel = SingleBillDetailsViewModel()
    var transactionID = String()
    var billStatusBGColor = String()
    var isFromAddBiller = Bool()
    var isFromHomeDetail = Bool()

    @IBOutlet weak var btnRaiseComplain: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI(isShow: false)
        if self.isFromHomeDetail {
            self.lblRaiseComplaint.text = "Done"
        }
        self.singleBillDetailsViewModel.getSingleBillDetails(transactionID: self.transactionID) { success in
            let obj = self.singleBillDetailsViewModel.dicOfSingleBillDetails
            
            self.lblTransactionID.text = obj?.txnId
            self.lblBillPrice.text = (String(format: "₹%.2f", obj?.amount ?? 0))
            self.lblCustomerID.text = "Consumer ID : \(obj?.billerId ?? "")"
            self.lblPopViewEmail.text = obj?.email
                        
            if let billDate = obj?.billDate{
                if billDate.contains("T"){
                    let val = billDate.components(separatedBy: "T")
                    let str = self.convertDateFormater(val[0])
                    self.lblPopViewBillDate.text = str
                }else{
                    self.lblPopViewBillDate.text = ""
                }
            }else{
                self.lblPopViewBillDate.text = ""
            }
            
            self.lblPopViewBillNumber.text = obj?.billerId
            self.lblPopViewPaymentMode.text = obj?.paymentMode
            self.lblPopViewPayTo.text = obj?.billerName
            
            self.lblBillTitle.text = ""
            self.lblBillSubTitle.text = obj?.billerName
            
            let status = obj?.status
            
            
            var billDatee = String()
            if let str = obj?.paymentDate{
                if str.contains("T"){
                    let vall = str.components(separatedBy: "T")
                    billDatee = self.convertDateFormater(vall[0])
                }else{
                    billDatee = ""
                }
            }else{
                billDatee = ""
            }
            
            if status == "success" || status == "Success" || status == "SUCCESS"{
                self.setupDate(status: "Completed", dateValue: billDatee)
                self.viewDate.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
                self.imgCheckUnCheck.image = UIImage(named: "ic_check_white")
                self.billStatusBGColor = TSP_PrimaryColor
                self.viewCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
                self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
                self.imgStatus.image = UIImage(named: "ic_thumbsup")
            }else{
                self.setupDate(status: "Failed", dateValue: billDatee)
                self.viewDate.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202").cgColor
                self.imgCheckUnCheck.image = UIImage(named: "ic_close_white")
                self.billStatusBGColor = "EB0202"
                self.viewCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
                self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
                self.imgStatus.image = UIImage(named: "ic_thumbsup_down")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
    
    func convertDateFormaterr(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy, hh:mma"
        return dateFormatter.string(from: date!)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        if self.isFromAddBiller{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }
            tabbarController.selectedIndex = 0            
        } else if self.isFromHomeDetail {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            for obj in viewControllers {
                if obj.isKind(of: TabBarVC.self) {
                    self.navigationController!.popToViewController(obj, animated: true)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonViewDetailsAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            self.setupUI(isShow: true)
        }else{
            sender.tag = 0
            self.setupUI(isShow: false)
        }
    }
    
    @IBAction func buttonRaiseComplaint(_ sender: UIButton) {
        if self.isFromHomeDetail {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            for obj in viewControllers {
                if obj.isKind(of: TabBarVC.self) {
                    self.navigationController!.popToViewController(obj, animated: true)
                }
            }
        } else {
            let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "RaiseComplaintVC")as! RaiseComplaintVC
            nextVC.refID = self.singleBillDetailsViewModel.dicOfSingleBillDetails.txnId ?? ""
            nextVC.billerId = self.singleBillDetailsViewModel.dicOfSingleBillDetails.billerId ?? ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    func setupUI(isShow:Bool){
        if isShow{
            self.mainViewHeight.constant = 900
            self.detailPopViewHeight.constant = 190
            self.detailPopView.isHidden = false
            self.lblDetailViewTitle.text = "View Less"
            self.imgDetailViewArrow.image = #imageLiteral(resourceName: "ic_up")
            self.detailViewWidth.constant = 100
        }else{
            self.mainViewHeight.constant = 710
            self.detailPopViewHeight.constant = 0
            self.detailPopView.isHidden = true
            self.lblDetailViewTitle.text = "View Details"
            self.imgDetailViewArrow.image = #imageLiteral(resourceName: "ic_darknext")
            self.detailViewWidth.constant = 115
        }
        self.viewThumsUp.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
        self.viewCheck.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.billStatusBGColor)
        self.viewPrice.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        self.view.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
        self.viewLeft.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
        self.viewRight.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
        self.viewDetails.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
        self.lblRaiseComplaint.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
    }
    
    func setupDate(status:String,dateValue:String){
        if status == "Completed"{
            let attrs1 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "909196")]
            
            let attributedString1 = NSMutableAttributedString(string:"Completed", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:" - \(dateValue)", attributes:attrs2 as [NSAttributedString.Key : Any])
            
            attributedString1.append(attributedString2)
            self.lblDate.attributedText = attributedString1
        }else{
            let attrs1 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.init(name: "Avenir-Book", size: 10.0), NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: "909196")]
            
            let attributedString1 = NSMutableAttributedString(string:"Failed", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:" - \(dateValue)", attributes:attrs2 as [NSAttributedString.Key : Any])
            
            attributedString1.append(attributedString2)
            self.lblDate.attributedText = attributedString1
        }
    }
    

}
