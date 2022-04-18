//
//  SelectedBillVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit
import PayUParamsKit
import PayUBizCoreKit
import PayUCheckoutProKit
import PayUCheckoutProBaseKit

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

    var selectedBills: [MyBillsContent]!
    
    var addBillerViewModel = AddBillerViewModel()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    ///Button action arrow in header
    @objc func buttonHandlerSectionArrowTap(sender : UIButton)  {
        var sectionData = selectedBills[sender.tag]
        sectionData.isColleps = !(sectionData.isColleps ?? false)
        selectedBills[sender.tag] = sectionData
        self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    

    @objc func btnBillPayAction(sender: UIButton) {
        
        var param = [[String:Any]]()
        
        let firstName = dicOfUserProfile.firstName!
        let phone = dicOfUserProfile.phoneNumber!
        let email = dicOfUserProfile.email!
        let lastName = dicOfUserProfile.lastName!
        
        let sUrl = "https://payuresponse.firebaseapp.com/success"
        let fUrl = "https://payuresponse.firebaseapp.com/failure"
        let cUrl = "https://payuresponse.firebaseapp.com/cancel"
        
        var productInfo = String()
        var amount = Double()
        var billerId = String()
        var billId = Int()
        
        for obj in selectedBills {
            
            if let str = obj.billerName {
                productInfo = str
            }
            
            if let str = obj.amount {
                amount = str
            }
            
            if let str = obj.billerPayuId {
                billerId = str
            }
            
            if let str = obj.id {
                billId = str
            }
            
            
            var dic = [String : Any]()
            dic = ["userDetails":
                        ["firstName":firstName,
                         "phone": phone,
                         "email": email,
                         "lastName": lastName,
                         "userId": "0"],
                     "sUrl": sUrl,
                     "fUrl": fUrl,
                     "cUrl": cUrl,
                     "productInfo": productInfo,
                     "amount": amount,
                     "billerId": billerId,
                     "billId": billId
            ]
            
            param.append(dic)
        }
        
        print(param)
        
        self.addBillerViewModel.preparePaymentForMultipleBillPayment(param:param) { success in
            PayUCheckoutPro.open(on: self, paymentParam: self.getPaymentParam(), delegate: self)
        }
        
    }
    
    @objc func btnBillCancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func getPaymentParam() -> PayUPaymentParam{
        
        let key = self.addBillerViewModel.dicOfPreparePayment.key ?? ""
        let transactionId = self.addBillerViewModel.dicOfPreparePayment.txnid ?? ""
        let amount = self.addBillerViewModel.dicOfPreparePayment.amt ?? 0.0
        let productInfo = self.addBillerViewModel.dicOfPreparePayment.productinfo ?? ""
        let firstName = self.addBillerViewModel.dicOfPreparePayment.firstname ?? ""
        let email = self.addBillerViewModel.dicOfPreparePayment.email ?? ""
        let phone = self.addBillerViewModel.dicOfPreparePayment.phone ?? ""
        let surl = self.addBillerViewModel.dicOfPreparePayment.surl ?? ""
        let furl = self.addBillerViewModel.dicOfPreparePayment.furl ?? ""
      
        let paymentParam = PayUPaymentParam(key: key,
                                            transactionId: transactionId,
                                            amount: "\(amount)",
                                            productInfo: productInfo,
                                            firstName: firstName,
                                            email: email,
                                            phone: phone,
                                            surl: surl,
                                            furl: furl,
                                            environment: .test)
        
        let userCredential = "\(key):\(email)"
        paymentParam.userCredential = userCredential
        
        return paymentParam
    }
    
}

extension SelectedBillVC: PayUCheckoutProDelegate {
    func onError(_ error: Error?) {
        print(error?.localizedDescription ?? "")
        showAlert(title: "Error", message: error?.localizedDescription ?? "")
    }
    
    func onPaymentSuccess(response: Any?) {
        if let transactionId = self.addBillerViewModel.dicOfPreparePayment.txnid{
            self.addBillerViewModel.verifyPayment(transactionID: transactionId) { response in
                print("Verify Payment Done")
                let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "MultipleBillDetailsVC")as! MultipleBillDetailsVC
//                let obj = self.addBillerViewModel.aryOfVerifyPaymentModel[0]
                nextVC.aryOfVerifyPaymentModel = self.addBillerViewModel.aryOfVerifyPaymentModel
//                nextVC.transactionID = obj.txnId ?? ""
//                nextVC.isFromAddBiller = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }else{
            showAlert(title: "Failure", message: "Payment is not verfied")
        }
    }
    
    func onPaymentFailure(response: Any?) {
        showAlert(title: "Failure", message: "\(response ?? "")")
    }
    
    func onPaymentCancel(isTxnInitiated: Bool) {
        let completeResponse = "isTxnInitiated = \(isTxnInitiated)"
        showAlert(title: "Cancelled", message: "\(completeResponse)")
    }
    
    func generateHash(for param: DictOfString, onCompletion: @escaping PayUHashGenerationCompletion){
        
        let hashStringWithoutSalt = param[HashConstant.hashString] ?? ""
        let hashName = param[HashConstant.hashName] ?? ""
        
        self.addBillerViewModel.generateHash(hashStringWithoutSalt: hashStringWithoutSalt) { response in
            let hashFetchedFromServer = self.addBillerViewModel.dicOfGenerateHash.hash
            onCompletion([hashName : hashFetchedFromServer])
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        header.lblSubTitle.text = sectionData.billerPayuId
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

        header.lblTotalBillAcount.text = "(Total \(selectedBills.count) Billers)"
        
        var totalAmount : Double = 0.0
        for obj in selectedBills {
            if let amount = obj.amount {
                totalAmount = totalAmount + Double(amount)
            }
        }
        header.lblTotalBillAmount.text = "₹ \(totalAmount)"
        
        header.btnPay.addTarget(self, action: #selector(btnBillPayAction(sender:)), for: .touchUpInside)
        header.btnCancel.addTarget(self, action: #selector(btnBillCancelAction(sender:)), for: .touchUpInside)
        
        header.lblHeader.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        header.lblFooter.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        header.viewPay.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        header.viewCancel.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
        header.btnCancel.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)

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
