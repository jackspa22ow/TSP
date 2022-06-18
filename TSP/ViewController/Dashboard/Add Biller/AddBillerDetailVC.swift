//
//  AddBillerDetailVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 17/11/21.
//

import UIKit
import PayUParamsKit
import PayUBizCoreKit
import PayUCheckoutProKit
import PayUCheckoutProBaseKit

class AddBillerDetailVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var aryOfBillerDetailList: [AddBillerCustomerParam] = []
    let numberOfCell = 8
    
    var addBillerViewModel = AddBillerViewModel()
    var shortName : String = ""
    var addBillerModel : AddBillerModelContent!
    var addBillerModelAfterValidation : AddBillModel!

    
    var planID : String?
    var arrayOfPlanDetail : [PlanInfo] = []
    
    var contactNumber : String = ""
    var contactName : String = ""
    var isUserBill = Bool()
    
    var isRecharge = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        tblView.rowHeight = 100
        tblView.estimatedRowHeight = UITableView.automaticDimension
        if let planID = self.planID {
            addBillerViewModel.getPlanDetailByPlanID(planId: "\(planID)") { response in
                
                if let operatorName = self.addBillerViewModel.dicOfPlanDetailByPlanID.operatorName, !operatorName.isEmpty {
                    let operatorNameObj = PlanInfo(itemName: "OperatorName", itemValue: operatorName)
                    self.arrayOfPlanDetail.append(operatorNameObj)
                }
                
                if let talkTime = self.addBillerViewModel.dicOfPlanDetailByPlanID.price, !talkTime.isEmpty {
                    let talkTimeObj = PlanInfo(itemName: "Talk Time", itemValue: talkTime)
                    self.arrayOfPlanDetail.append(talkTimeObj)
                }
                
                if let planData = self.addBillerViewModel.dicOfPlanDetailByPlanID.data, !planData.isEmpty {
                    let planDataObj = PlanInfo(itemName: "Data", itemValue: planData)
                    self.arrayOfPlanDetail.append(planDataObj)
                }
                
                if let planCalls = self.addBillerViewModel.dicOfPlanDetailByPlanID.calls, !planCalls.isEmpty {
                    let planCallsObj = PlanInfo(itemName: "Calls", itemValue: planCalls)
                    self.arrayOfPlanDetail.append(planCallsObj)
                }
                
                if let planValidity = self.addBillerViewModel.dicOfPlanDetailByPlanID.validity, !planValidity.isEmpty {
                    let planValidityObj = PlanInfo(itemName: "Validity", itemValue: planValidity)
                    self.arrayOfPlanDetail.append(planValidityObj)
                }
                
                if let planSMS = self.addBillerViewModel.dicOfPlanDetailByPlanID.sms, !planSMS.isEmpty {
                    let planSMSObj = PlanInfo(itemName: "SMS", itemValue: planSMS)
                    self.arrayOfPlanDetail.append(planSMSObj)
                }
                
                if let planDetails = self.addBillerViewModel.dicOfPlanDetailByPlanID.packageDescription, !planDetails.isEmpty {
                    let planDetailsObj = PlanInfo(itemName: "Details", itemValue: planDetails)
                    self.arrayOfPlanDetail.append(planDetailsObj)
                }
                
                let planBillAmount = PlanInfo(itemName: "Bill Amount", itemValue: self.addBillerViewModel.dicOfPlanDetailByPlanID.price)
                self.arrayOfPlanDetail.append(planBillAmount)
                
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
            }
        } else {
            
            let billerObj = PlanInfo(itemName: addBillerModel.billerName ?? "", itemValue: "")
            self.arrayOfPlanDetail.append(billerObj)

            for obj in aryOfBillerDetailList{
                let operatorName = PlanInfo(itemName: obj.paramName ?? "", itemValue: obj.inputedValue)
                self.arrayOfPlanDetail.append(operatorName)
            }
            
            if shortName.count > 0 {
                let shortNameObj = PlanInfo(itemName: "Short Name", itemValue: self.shortName)
                self.arrayOfPlanDetail.append(shortNameObj)
            }
            
            if let accountHolderName = self.addBillerModelAfterValidation.accountHolderName, accountHolderName.count > 0 {
                let accountHolderObj = PlanInfo(itemName: "Consumer Name:", itemValue: accountHolderName)
                self.arrayOfPlanDetail.append(accountHolderObj)
            }
            
            if let noOfInstallment = self.addBillerModelAfterValidation.noOfInstallation, noOfInstallment > 0 {
                let noOfInstallmentObj = PlanInfo(itemName: "No. of Installment:", itemValue: "\(noOfInstallment)")
                self.arrayOfPlanDetail.append(noOfInstallmentObj)
            }
            
            if let billDate = self.addBillerModelAfterValidation.billDate, billDate.count > 0 {
                let billDateObj = PlanInfo(itemName: "Bill Date:", itemValue: billDate)
                self.arrayOfPlanDetail.append(billDateObj)
            }
            
            if let billDueDate = self.addBillerModelAfterValidation.dueDate, billDueDate.count > 0 {
                let billDueDateObj = PlanInfo(itemName: "Due Date:", itemValue: billDueDate)
                self.arrayOfPlanDetail.append(billDueDateObj)
            }
            
            if let amount = self.addBillerModelAfterValidation.amount {
                let planBillAmount = PlanInfo(itemName: "Bill Amount", itemValue: "\(amount)")
                self.arrayOfPlanDetail.append(planBillAmount)
            } else {
                let planBillAmount = PlanInfo(itemName: "Bill Amount", itemValue: "")
                self.arrayOfPlanDetail.append(planBillAmount)
            }
            
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
        }
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonConfirm(){
        let cell = self.tblView.cellForRow(at: IndexPath(row: arrayOfPlanDetail.count - 1, section: 0)) as! AddBillerDetailsTotalAmountCell
        
        var minimumValue : Int?
        var maximumValue : Int?
        if let arrayOfPaymentChannels = self.addBillerModelAfterValidation.paymentChannelsAllowed {
            let array = arrayOfPaymentChannels.filter{
                $0.paymentMode == "MOB"
            }
            if array.count > 0 {
                if let objPaymentChannel = array.first {
                    if let minValue = objPaymentChannel.minLimit {
                        minimumValue = Int(minValue)
                    }
                    
                    if let maxValue = objPaymentChannel.maxLimit {
                        maximumValue = Int(maxValue)
                    }
                }
            }
        }
        
        if let amount = addBillerModelAfterValidation.amount {
            if let amountExact = addBillerModelAfterValidation.paymentAmountExactness {
                if amountExact.lowercased() == "EXACT_AND_ABOVE".lowercased() {
                    let enteredAmount: Int? = Int(cell.txtAmount.text!)
                    let actualAmount: Int? = Int(amount)
                    if let enteredAmt = enteredAmount, let actualAmt = actualAmount, let maxVal = maximumValue {
                        if enteredAmt >= actualAmt && enteredAmt <= maxVal {
                            self.preparePayment(amount: cell.txtAmount.text ?? "", isRechargeBill: isRecharge)
                        } else {
                            Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(actualAmt) and \(maxVal)")
                        }
                    }
                } else if amountExact.lowercased() == "EXACT_AND_BELOW".lowercased() {
                    let enteredAmount: Int? = Int(cell.txtAmount.text!)
                    let actualAmount: Int? = Int(amount)
                    if let enteredAmt = enteredAmount, let actualAmt = actualAmount, let minVal = minimumValue {
                        if enteredAmt <= actualAmt && enteredAmt >= minVal {
                            self.preparePayment(amount: cell.txtAmount.text ?? "", isRechargeBill: isRecharge)
                        } else {
                            Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(minVal) and \(actualAmt)")
                        }
                    }
                } else if (amountExact.lowercased() == "EXACT".lowercased()) {
                    self.preparePayment(amount: "\(amount)", isRechargeBill: isRecharge)
                }
                print("Entered Amount: \(cell.txtAmount.text!), IsValueAmount: \((cell.txtAmount.text!).isNumber)")
            } else {
                self.preparePayment(amount: "\(amount)", isRechargeBill: isRecharge)

                print("Entered Amount: \(amount) , IsValueAmount: \("\(amount)".isNumber)")
            }
        } else {
            let enteredAmount: Int? = Int(cell.txtAmount.text!)
            if let enteredAmt = enteredAmount, let minVal = minimumValue, let maxVal = maximumValue {
                if enteredAmt >= minVal && enteredAmt <= maxVal {
                    self.preparePayment(amount: cell.txtAmount.text ?? "", isRechargeBill: isRecharge)
                } else {
                    Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(minVal) and \(maxVal)")
                }
            }
            print("Entered Amount: \(cell.txtAmount.text!), IsValueAmount: \((cell.txtAmount.text!).isNumber)")
            
        }
    }
    
    @objc func buttonCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    func addToMyBills(){
//        let name = "\(dicOfUserProfile.firstName ?? "") \(dicOfUserProfile.lastName ?? "")"
//        let amount = self.addBillerViewModel.dicOfPlanDetailByPlanID.price ?? ""
//        let circleID = self.addBillerViewModel.dicOfPlanDetailByPlanID.circleId!
//        let operatorID = self.addBillerViewModel.dicOfPlanDetailByPlanID.operatorId!
//        let mobileNumber = dicOfUserProfile.phoneNumber!
//        let isUserBillValue = self.isUserBill == true ? "true" : "false"
//
//        let param = ["accountHolderName":name,"amount":amount,"autoPay":true,"billDue":true,"customerParams":["CircleId":circleID,"Mobile Number":self.contactNumber,"Operator":operatorID],"customerPhoneNumber":mobileNumber,"enableReminder":false,"operatorId":operatorID] as [String : Any]
//
//        self.addBillerViewModel.addMobilePrepeaidBill(isUserBill: isUserBillValue, param: param) { response in
//            var isRechargeBill = false
//            for j in self.addBillerViewModel.dicOfAddedBill.customerParams{
//                if j.paramName == "Mobile Number"{
//                    isRechargeBill = true
//                    break
//                }
//            }
//            self.preparePayment(isRechargeBill: isRechargeBill)
//        }
//    }
    
    func preparePayment(amount: String, isRechargeBill:Bool){
        
        let firstName = dicOfUserProfile.firstName!
        let phone = dicOfUserProfile.phoneNumber!
        let email = dicOfUserProfile.email!
        let lastName = dicOfUserProfile.lastName!
        
        let sUrl = "https://payu.herokuapp.com/ios_success"
        let fUrl = "https://payu.herokuapp.com/ios_failure"
        let cUrl = "https://payu.herokuapp.com/ios_cancel"

        let productInfo = self.addBillerModelAfterValidation.billerName ?? ""
//        let amount = self.addBillerModelAfterValidation.amount ?? 0
        let billerId = self.addBillerModelAfterValidation.billerPayuId ?? ""
        let billId = self.addBillerModelAfterValidation.id ?? 0
        
        var param = [String : Any]()
        
        if isRechargeBill{
            param = ["userDetails":
                        ["firstName":firstName,
                         "phone": phone,
                         "email": email,
                         "lastName": lastName,
                         "userId": "0"],
                     "customerParams":["paramName":"Mobile Number",
                                       "value":self.contactNumber],
                     "sUrl": sUrl,
                     "fUrl": fUrl,
                     "cUrl": cUrl,
                     "productInfo": productInfo,
                     "amount": amount,
                     "billerId": billerId,
                     "billId": billId
            ]
        }else{
            param = ["userDetails":
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
        }
        
        print(param)
                        
        self.addBillerViewModel.preparePayment(param:param) { success in
            PayUCheckoutPro.open(on: self, paymentParam: self.getPaymentParam(), delegate: self)
        }
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


extension AddBillerDetailVC: PayUCheckoutProDelegate {
    func onError(_ error: Error?) {
        print(error?.localizedDescription ?? "")
        showAlert(title: "Error", message: error?.localizedDescription ?? "")
    }
    
    func onPaymentSuccess(response: Any?) {
        if let transactionId = self.addBillerViewModel.dicOfPreparePayment.txnid{
            self.addBillerViewModel.verifyPayment(transactionID: transactionId) { response in
                let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
                let obj = self.addBillerViewModel.aryOfVerifyPaymentModel[0]
                nextVC.transactionID = obj.txnId ?? ""
                nextVC.isFromAddBiller = true
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


extension AddBillerDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableViewSetup(){
        self.tblView.register(AddBillerDetailHeaderCell.nib, forCellReuseIdentifier: AddBillerDetailHeaderCell.identifier)
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        self.tblView.register(AddBillerDetailsTotalAmountCell.nib, forCellReuseIdentifier: AddBillerDetailsTotalAmountCell.identifier)
        self.tblView.register(MyBillDetailsFooterCell.nib, forCellReuseIdentifier: MyBillDetailsFooterCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPlanDetail.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == arrayOfPlanDetail.count - 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == arrayOfPlanDetail.count {
            return 140
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBillerDetailHeaderCell.identifier, for: indexPath) as? AddBillerDetailHeaderCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.lblTitle.text = arrayOfPlanDetail[0].name
            cell.lblDescription.text = arrayOfPlanDetail[0].value
            
            if self.aryOfBillerDetailList.count > 0 {
                cell.lblItemName.text = ""
                cell.lblItemValue.text = ""
            } else {
                cell.lblItemName.text = "Contact Number"
                cell.lblItemValue.text = self.contactNumber
            }
            
            return cell
        } else if indexPath.row == arrayOfPlanDetail.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsFooterCell.identifier, for: indexPath) as? MyBillDetailsFooterCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.viewConfirm.isHidden = false
            cell.btnConfirm.setTitle("Pay", for: .normal)
            cell.btnConfirm.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            cell.btnConfirm.addTarget(self, action: #selector(buttonConfirm), for: UIControl.Event.touchUpInside)
            cell.btnCancel.addTarget(self, action: #selector(buttonCancel), for: UIControl.Event.touchUpInside)
            cell.btnCancel.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
            cell.btnCancel.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
            
            return cell
        } else if indexPath.row == arrayOfPlanDetail.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBillerDetailsTotalAmountCell.identifier, for: indexPath) as? AddBillerDetailsTotalAmountCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.lblName.text = arrayOfPlanDetail[indexPath.row].name
            
            if let amount = addBillerModelAfterValidation.amount {
                if let amountExact = addBillerModelAfterValidation.paymentAmountExactness, amountExact.lowercased() != "Exact".lowercased() {
                    cell.vwTxtAmount.isHidden = false
                    cell.vwTxtAmountHeight.constant = 40
                } else {
                    cell.lblValue.text = arrayOfPlanDetail[indexPath.row].value
                    cell.vwTxtAmount.isHidden = true
                    cell.vwTxtAmountHeight.constant = 20
                }
            } else {
                cell.vwTxtAmount.isHidden = false
                cell.vwTxtAmountHeight.constant = 40
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsCustomerParamCell.identifier, for: indexPath) as? MyBillDetailsCustomerParamCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.lblName.text = arrayOfPlanDetail[indexPath.row].name
            cell.lblDescription.text = arrayOfPlanDetail[indexPath.row].value
            
            return cell
        }
    }
    
}
