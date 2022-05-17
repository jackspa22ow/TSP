//
//  HomeDetailsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 08/10/21.
//

import UIKit
import ActionSheetPicker_3_0
import PayUParamsKit
import PayUBizCoreKit
import PayUCheckoutProKit
import PayUCheckoutProBaseKit

class HomeDetailsVC: UIViewController {
    
    let myBillsViewModel = MyBillsViewModel()
    let homeViewModel = HomeViewModel()
    var addBillerViewModel = AddBillerViewModel()
    var autoPayViewModel = AutopayListViewModel()
    
    var json: BillDetailModel!
    var billID: String!
    var autoPayID: String!

    var reminderObj: ReminderListPayload!

    @IBOutlet weak var tblView: UITableView!
    var reminderHeight = 70
    var isReminderSet = Bool()
    var isReminderSetUpdate = Bool()
    var isAutoPay = Bool()
    var isAutoPayOnForBill = Bool()
    var isAutoPayFromHomeMore = Bool()

    var isReminderHide = Bool()
    var isAutoPayHide = Bool()
    var isGetReminderAPICall = Bool()
    var aryOfBool = [false,false]
    
//    var aryOfReminders : [ReminderModel] = []
    var aryOfPaymentMethod : [String] = ["Credit Card", "Debit Card", "Net Banking"]
    var selectedPaymentMethod = ""
    var autoPaymentMaxAmount = ""
    var isAutoPaymentEditing = false

    let reminderListViewModel = ReminderListViewModel()
    var isReminderEdit : Bool = false
    var isAutoPayEdit : Bool = false
    var isShortNameEdit : Bool = false

    var isReminderEditMode : Bool = false
    var selectedReminderOption : ReminderSubtype!
    var selectedReminderOptionValue : String = ""
    var isReminderUpdated:((_ value : Bool) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.myBillsViewModel.getBillDetailByID(billID: self.billID ?? "") { [self] response in
            self.json = self.myBillsViewModel.dicOfBillDetail
            
            let amountParam = MyBillsCustomerParam(value: "\(self.json.amount ?? 0)", paramName: "Amount", primary: false)
            if !isShortNameEdit {
                self.json.customerParams.append(amountParam)
            }
            
            if self.isAutoPayHide == false && !self.isReminderEdit{
                self.isAutoPay = self.json?.autoPay ?? false
                self.isAutoPayOnForBill = self.json?.autoPay ?? false
                self.selectedPaymentMethod = self.json.standingInstruction?.preferredPaymentMode ?? ""
                self.autoPaymentMaxAmount = "\(self.json.standingInstruction?.maxLimitAmount ?? 0)" == "0" ? "" : "\(self.json.standingInstruction?.maxLimitAmount ?? 0)"
                self.autoPayID = "\(self.json.standingInstruction?.id ?? 0)" == "0" ? "" : "\(self.json.standingInstruction?.id ?? 0)"
                
                if self.isAutoPayFromHomeMore && self.isAutoPay {
                    self.isAutoPaymentEditing = true
                }
            }
            if self.isReminderHide == false && !self.isAutoPayEdit{
                self.isReminderSet = self.json?.enableReminder ?? false
            }
            
            if !self.isAutoPayEdit {
                self.getRemiderSubtype()

            } else {
                self.autoPayAndReminderCOnfiguration()
                self.setupReminderCell()

                self.tableViewSetup()
            }
        }
    }
    
    func autoPayAndReminderCOnfiguration(){
        if TSP_Allow_Setting_Reminders != "" && TSP_Allow_Setting_Reminders != Constant.User {
            self.isReminderSet = false
            self.isReminderHide = true
        }
        
        if TSP_Allow_Setting_Autopay != "" && TSP_Allow_Setting_Autopay != Constant.User {
            self.isAutoPay = false
            self.isAutoPayHide = true
        }
    }
//
//    func getAutoPayDetail() {
//        self.autoPayViewModel.getAutoPayByID(autoPayID: "\(self.autoPayObj.id ?? 0)") { response in
//            print("Max Limit: \(self.autoPayViewModel.autoPayDetail.maxLimitAmount) Payment Type:\(self.autoPayViewModel.autoPayDetail.preferredPaymentMode)")
//
//            self.setupReminderCell()
//
//            self.tableViewSetup()
//
//        }
//    }
    func getReminderList() {
        if let billID = self.json.id {
            self.reminderListViewModel.getReminderByBillID(billID: "\(billID)") { response in
                Utilities.sharedInstance.dismissSVProgressHUD()
                let payload = self.reminderListViewModel.dicOfReminderByBill.payload?.filter{ $0.isEnable == true }
                
                if (payload?.count ?? 0) > 0 {
                    self.isReminderSet = true
                } else {
                    self.isReminderSet = false
                }
                
                self.homeViewModel.getBillAutoPayDetailByBillID(billID: "\(billID)") { response in

                    if let autoPay = self.homeViewModel.dicOfMyBillAutoPayDetail, (autoPay.id ?? 0) > 0 {
                        self.isAutoPay = true
                        self.isAutoPayOnForBill = true
                    } else {
                        self.isAutoPay = false
                    }
                    
                    self.autoPayAndReminderCOnfiguration()

                    self.setupReminderCell()
                    
                    self.tableViewSetup()
                }
                
            }
        }
    }
    func getRemiderSubtype(){
        self.reminderListViewModel.getReminderSubType { response in
            Utilities.sharedInstance.dismissSVProgressHUD()
            if let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
                if payload.count > 0{
                    self.autoPayAndReminderCOnfiguration()

                    self.setupReminderCell()
                    for obj in payload {
                        if self.reminderObj != nil && obj.eventSubTypeId == self.reminderObj.eventSubTypeId {
                            self.selectedReminderOption = obj
                            if let value = self.reminderObj.daysBeforeDueDate {
                                if value > 0 {
                                    self.selectedReminderOptionValue = "\(value)"
                                } else {
                                    if let value = self.reminderObj.daysAfterBillGenerated {
                                        self.selectedReminderOptionValue = "\(value)"
                                    }
                                }
                            }
                        }
                    }
                    if !self.isReminderEdit {
                        self.getReminderList()
                    } else {
                        self.autoPayAndReminderCOnfiguration()
                        self.tableViewSetup()
                    }
                }
            }
        }
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HomeDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableViewSetup(){
        self.tblView.register(MyBillDetailsHeaderCell.nib, forCellReuseIdentifier: MyBillDetailsHeaderCell.identifier)
        
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        
        self.tblView.register(MyBillDetailsReminderCell.nib, forCellReuseIdentifier: MyBillDetailsReminderCell.identifier)
        
        self.tblView.register(MyBillReminderEditCellTableViewCell.nib, forCellReuseIdentifier: MyBillReminderEditCellTableViewCell.identifier)

        self.tblView.register(MyBillDetailsFooterCell.nib, forCellReuseIdentifier: MyBillDetailsFooterCell.identifier)
        
        self.tblView.register(MyBillAutoPayEditCell.nib, forCellReuseIdentifier: MyBillAutoPayEditCell.identifier)
        
        self.tblView.register(MyBillDetailShortNameCell.nib, forCellReuseIdentifier: MyBillDetailShortNameCell.identifier)

        self.tblView.register(AddBillerDetailsTotalAmountCell.nib, forCellReuseIdentifier: AddBillerDetailsTotalAmountCell.identifier)

        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.customerParams.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UITableView.automaticDimension
        }else if indexPath.row == self.json.customerParams.count + 1{
            if isShortNameEdit {
                return 80
            } else {
                if isReminderEdit {
                    if (self.json.enableReminder ?? false) {
                        return 204
                    }
                    return 70
                }
                return CGFloat(self.reminderHeight)
            }
        }else if indexPath.row == self.json.customerParams.count + 2{
            return 140
        }else{
            if !isShortNameEdit && indexPath.row == self.json.customerParams.count {
                return UITableView.automaticDimension
            }
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsHeaderCell.identifier, for: indexPath) as? MyBillDetailsHeaderCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.lblTitle.text = self.json?.billNickName
            cell.lblDescription.text = self.json?.billerName
            
            return cell
        }else if indexPath.row == self.json.customerParams.count + 1{
            if isShortNameEdit {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailShortNameCell.identifier, for: indexPath) as? MyBillDetailShortNameCell else {
                    fatalError("XIB doesn't exist.")
                }
                cell.txtShortNAme.text = self.json?.billNickName
                return cell
            } else {
                if isReminderEdit {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillReminderEditCellTableViewCell.identifier, for: indexPath) as? MyBillReminderEditCellTableViewCell else {
                        fatalError("XIB dosn't exist.")
                    }
                    cell.switchReminder.isOn = self.json.enableReminder ?? false
                    cell.switchReminder.addTarget(self, action: #selector(self.switchChangedWhileReminderEdit), for: UIControl.Event.valueChanged)
                    
                    if isReminderEditMode {
                        cell.btnEdit.isHidden = false
                        if cell.switchReminder.isOn  == true{
                            cell.consReminderValueViewHeight.priority = UILayoutPriority(250)
                        } else {
                            cell.consReminderValueViewHeight.priority = UILayoutPriority(999)
                        }
                        cell.consReminderEditViewHeight.priority = UILayoutPriority(999)
                    } else {
                        cell.btnEdit.isHidden = true
                        if cell.switchReminder.isOn {
                            cell.consReminderEditViewHeight.priority = UILayoutPriority(250)
                        } else {
                            cell.consReminderEditViewHeight.priority = UILayoutPriority(999)
                        }
                        cell.consReminderValueViewHeight.priority = UILayoutPriority(999)
                    }
                    
                    
                    cell.btnEdit.addTarget(self, action: #selector(btnEditReminderAction(sender:)), for: .touchUpInside)
                    cell.btnReminderOption.addTarget(self, action: #selector(btnReminderOptionAction(sender: )), for: .touchUpInside)
                    
                    cell.txtReminderOption.text = selectedReminderOption.eventSubTypes ?? ""
                    cell.lblReminderOption.text = selectedReminderOption.eventSubTypes ?? ""
                    cell.txtReminderOptionValue.text = selectedReminderOptionValue
                    cell.lblReminderOptionValue.text = selectedReminderOptionValue
                    
                    cell.reminderOptionValue = { value in
                        self.selectedReminderOptionValue = value
                    }
                    
                    return cell
                } else if isAutoPayEdit {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillAutoPayEditCell.identifier, for: indexPath) as? MyBillAutoPayEditCell else {
                        fatalError("XIB dosn't exist.")
                    }
                    cell.txtMaxAmount.text = self.autoPaymentMaxAmount
                    cell.txtPaymentMethod.text = self.selectedPaymentMethod
                    cell.lblMaxAmount.text = self.autoPaymentMaxAmount
                    cell.lblPaymentType.text = self.selectedPaymentMethod
                    cell.switchAutoPay.isOn = self.isAutoPay
                    cell.switchAutoPay.addTarget(self, action: #selector(autoPaySwitchChangedWithEidt), for: UIControl.Event.valueChanged)
                    
                    if isAutoPayFromHomeMore {
                        if self.isAutoPay == false{
                            cell.vwAutoPayEdit.isHidden = true
                            cell.vwPaymentType.isHidden = true
                            cell.vwAutopayAmount.isHidden = true
                            cell.btnEdit.isHidden = true
                        } else{
                            cell.vwAutoPayEdit.isHidden = false
                            cell.vwPaymentType.isHidden = true
                            cell.vwAutopayAmount.isHidden = true
                            cell.btnEdit.isHidden = true
                        }
                    }
                    //                if (self.json?.autoPay ?? false) {
                    //                    cell.switchAutoPay.isUserInteractionEnabled = false
                    //                    cell.vwAutoPayEdit.isHidden = true
                    //                    cell.vwPaymentType.isHidden = true
                    //                    cell.vwAutopayAmount.isHidden = true
                    //                    cell.btnEdit.isHidden = true
                    //                } else {
                    //
                    //                    if self.isAutoPay == false{
                    //                        cell.vwAutoPayEdit.isHidden = true
                    //                        cell.vwPaymentType.isHidden = true
                    //                        cell.vwAutopayAmount.isHidden = true
                    //                        cell.btnEdit.isHidden = true
                    //                    } else{
                    //                        cell.vwAutoPayEdit.isHidden = false
                    //                        cell.vwPaymentType.isHidden = true
                    //                        cell.vwAutopayAmount.isHidden = true
                    //                        cell.btnEdit.isHidden = true
                    //                    }
                    //                }
                    cell.btnSelectPaymentMethod.addTarget(self, action: #selector(self.btnPaymentMethodAction), for: .touchUpInside)
                    
                    cell.maxminAmountValue = { value in
                        self.autoPaymentMaxAmount = value
                    }
                    cell.isAutoPayEditing = { value in
                        self.isAutoPaymentEditing = value
                        self.tblView.reloadRows(at: [IndexPath(row:self.json.customerParams.count + 2, section: 0)], with: .none)
                    }
                    
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsReminderCell.identifier, for: indexPath) as? MyBillDetailsReminderCell else {
                        fatalError("XIB dosn't exist.")
                    }
                    if self.isReminderSet{
                        cell.lblReminder.isHidden = false
                        cell.reminderSwitch.isOn = true
                    }else{
                        cell.lblReminder.isHidden = true
                        cell.reminderSwitch.isOn = false
                    }
                    
                    if self.isAutoPay {
                        cell.autoPaySwitch.isOn = true
                        if isAutoPayOnForBill {
                            cell.autoPaySwitch.isUserInteractionEnabled = false
                            cell.consViewAutoPayToHide.priority = UILayoutPriority(999)
                        } else {
                            cell.consViewAutoPayToHide.priority = UILayoutPriority(250)
                        }
                    } else {
                        cell.autoPaySwitch.isOn = false
                        cell.consViewAutoPayToHide.priority = UILayoutPriority(999)
                    }
                    
                    cell.reminderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                    cell.reminderSwitch.onTintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                    cell.reminderSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
                    
                    cell.autoPaySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                    cell.autoPaySwitch.onTintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                    cell.autoPaySwitch.addTarget(self, action: #selector(autoPaySwitchChanged), for: UIControl.Event.valueChanged)
                    
                    cell.btnAutoPayConfirm.addTarget(self, action: #selector(btnAutoPayConfirmAction), for: .touchUpInside)
                    cell.btnReminderConfirm.addTarget(self, action: #selector(btnReminderConfirmAction), for: .touchUpInside)
                    cell.btnAutoPayConfirm.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                    cell.btnReminderConfirm.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                    
                    cell.btnPaymentMethod.addTarget(self, action: #selector(btnPaymentMethodAction), for: .touchUpInside)
                    
                    cell.txtPaymentMethod.text = self.selectedPaymentMethod
                    if let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
                        cell.aryOfReminders = payload
                        if isGetReminderAPICall {
                            isGetReminderAPICall = false
                            cell.isFirstTime = true
                        }
                        cell.aryOfRemindersValue = self.reminderListViewModel.dicOfReminderByBill.payload ?? []
                        cell.tblView.reloadData()
                    }
                    cell.autoPaySwitch.isHidden = isAutoPayHide
                    cell.lblAutoPayTitle.isHidden = isAutoPayHide
                    
                    cell.reminderSwitch.isHidden = isReminderHide
                    cell.lblReminderTitle.isHidden = isReminderHide
                    
                    return cell
                }
            }
        }else if indexPath.row == self.json.customerParams.count + 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsFooterCell.identifier, for: indexPath) as? MyBillDetailsFooterCell else {
                fatalError("XIB doesn't exist.")
            }
            
            if self.isAutoPayHide || self.isReminderHide{
                cell.viewConfirm.isHidden = true
            } else if isShortNameEdit {
                cell.viewConfirm.isHidden = false
            }else{
                cell.viewConfirm.isHidden = false
            }
                        
            cell.btnConfirm.addTarget(self, action: #selector(buttonConfirm), for: UIControl.Event.touchUpInside)
            if isReminderEdit || isAutoPayEdit{
                if isReminderEditMode {
                    cell.viewConfirm.isHidden = true
                } else {
                    if (self.json.enableReminder ?? false) {
                        cell.viewConfirm.isHidden = false
                    } else if self.isAutoPaymentEditing == true {
                        cell.viewConfirm.isHidden = false
                    } else {
                        cell.viewConfirm.isHidden = true
                    }
                    cell.btnConfirm.setTitle("Done", for: .normal)
                }
            } else if isShortNameEdit {
                cell.viewConfirm.isHidden = false

                cell.btnConfirm.setTitle("Modify", for: .normal)
            } else {
                cell.btnConfirm.setTitle("Pay", for: .normal)
            }
            
            cell.btnConfirm.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            
            cell.btnCancel.addTarget(self, action: #selector(buttonCancel), for: UIControl.Event.touchUpInside)
            if self.isAutoPayHide || self.isReminderHide || isShortNameEdit{
                cell.btnCancel.setTitle("Cancel", for: .normal)
            } else {
                if isReminderEdit || isAutoPayEdit {
                    cell.btnCancel.setTitle("Back", for: .normal)
                } else {
                    cell.btnCancel.setTitle("Done", for: .normal)
                }
            }
            
            cell.btnCancel.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
            cell.btnCancel.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)

            return cell
        }else{
            if !isShortNameEdit && indexPath.row == self.json.customerParams.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBillerDetailsTotalAmountCell.identifier, for: indexPath) as? AddBillerDetailsTotalAmountCell else {
                    fatalError("XIB doesn't exist.")
                }
                let dic = self.json.customerParams[indexPath.row - 1]
                cell.lblName.text = dic.paramName
                cell.txtAmount.text = dic.value
                if let amount = dic.value {
                    if let amountExact = self.json.paymentAmountExactness, amountExact != "Exact" {
                        cell.vwTxtAmount.isHidden = false
                        cell.vwTxtAmountHeight.constant = 40
                    } else {
                        cell.lblValue.text = dic.value
                        cell.vwTxtAmount.isHidden = true
                        cell.vwTxtAmountHeight.constant = 20
                    }
                } else {
                    cell.vwTxtAmount.isHidden = false
                    cell.vwTxtAmountHeight.constant = 40
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsCustomerParamCell.identifier, for: indexPath) as? MyBillDetailsCustomerParamCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                let dic = self.json.customerParams[indexPath.row - 1]
                
                cell.lblName.text = dic.paramName
                cell.lblDescription.text = dic.value
                
                return cell
            }
        }
    }
    
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if value{
            self.isReminderSet = true
//            self.getReminderList()
            self.reminderListViewModel.getReminderByBillID(billID: "\(self.json.id ?? 0)") { response in
                self.isGetReminderAPICall = true
                Utilities.sharedInstance.dismissSVProgressHUD()
                self.autoPayAndReminderCOnfiguration()
                self.setupReminderCell()

                self.tblView.reloadRows(at: [IndexPath(row: self.json.customerParams.count + 1, section: 0)], with: .none)
            }
        }else{
            self.isReminderSet = false
            
            self.isReminderSetUpdate = false

            self.reminderListViewModel.desableReminderByBillID(billID: self.json.id ?? 0) { response in
                let alert = UIAlertController(title: "",
                                              message: "Successfully Disabled Reminders for bill",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in

                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            self.autoPayAndReminderCOnfiguration()
            self.setupReminderCell()
            self.tblView.reloadData()
        }
    }
    
    @objc func switchChangedWhileReminderEdit(mySwitch: UISwitch) {
        if isReminderEditMode {
            //api call to update reminder off
            if let reminderId = self.reminderObj.id, let billID = self.reminderObj.billId{
                
                self.reminderListViewModel.updateReminderByReminderID(reminderID: "\(reminderId)", billID: "\(billID)", daysAfter: self.reminderObj.daysAfterBillGenerated ?? 0, dayBefore: self.reminderObj.daysBeforeDueDate ?? 0, eventSubType: self.reminderObj.eventSubTypeId ?? 0, isEnable: false) { response in
                    
//                    if let payload = self.reminderListViewModel.dicOfReminderUpdate.payload {
//                        if payload.count > 0 {
                    self.isReminderUpdated?(true)
                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
                }
            }
        } else {
            self.isReminderEditMode = false
            self.isReminderSetUpdate = false
            self.json.enableReminder = !(self.json.enableReminder ?? false)
            self.tblView.reloadRows(at: [IndexPath(row: self.json.customerParams.count + 1, section: 0), IndexPath(row: self.json.customerParams.count + 2, section: 0)], with: .none)
        }
    }
    
    @objc func btnEditReminderAction(sender: UIButton){
        self.isReminderEditMode = false
        self.tblView.reloadRows(at: [IndexPath(row: self.json.customerParams.count + 1, section: 0), IndexPath(row: self.json.customerParams.count + 2, section: 0)], with: .none)

    }
    
    @objc func btnReminderOptionAction(sender: UIButton){
        var arrayOfReminderOption : [String] = []
        if let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
            for obj in payload {
                arrayOfReminderOption.append(obj.eventSubTypes ?? "")
            }
        }
        
        ActionSheetStringPicker.show(withTitle: "Reminder Option", rows: arrayOfReminderOption
                                     , initialSelection: 0, doneBlock: {
            picker, values, indexes in
            
            self.selectedReminderOption = self.reminderListViewModel.dicOfReminderSubtype.payload?[values]
            self.tblView.reloadRows(at: [IndexPath(row: self.json.customerParams.count + 1, section: 0)], with: .none)
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return
            
        }, origin: sender)

    }
    
    @objc func autoPaySwitchChangedWithEidt(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if value{
            self.isAutoPay = true
            self.isAutoPaymentEditing = true
        }else{
            self.isAutoPay = false
            self.isAutoPaymentEditing = false
        }
        self.autoPayAndReminderCOnfiguration()
        self.setupReminderCell()
        self.tblView.reloadData()
    }
    
    @objc func autoPaySwitchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        self.isAutoPayOnForBill = false
        if value{
            self.isAutoPay = true
        }else{
            self.isAutoPay = false
        }
        self.autoPayAndReminderCOnfiguration()
        self.setupReminderCell()
        self.tblView.reloadData()

    }
    
    @objc func buttonConfirm(){
        if isReminderEdit {
            // api to edit reminder
            if let reminderId = self.reminderObj.id, let billID = self.reminderObj.billId{
                let subtype = self.selectedReminderOption.eventSubTypes ?? ""
                if subtype.lowercased().contains("before") {
                    self.reminderListViewModel.updateReminderByReminderID(reminderID: "\(reminderId)", billID: "\(billID)", daysAfter: 0, dayBefore: Int(self.selectedReminderOptionValue) ?? 0, eventSubType: self.selectedReminderOption.eventSubTypeId ?? 0, isEnable: true) { response in
                        self.isReminderUpdated?(true)
                        self.navigationController?.popViewController(animated: true)
                    }

                } else {
                    self.reminderListViewModel.updateReminderByReminderID(reminderID: "\(reminderId)", billID: "\(billID)", daysAfter: Int(self.selectedReminderOptionValue) ?? 0, dayBefore: 0, eventSubType: self.selectedReminderOption.eventSubTypeId ?? 0, isEnable: true) { response in
                        self.isReminderUpdated?(true)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else if self.isAutoPayEdit {
            self.btnAutoPayConfirmAction()
        } else if isShortNameEdit {
            let cell = self.tblView.cellForRow(at: IndexPath(row: self.json.customerParams.count + 1, section: 0)) as! MyBillDetailShortNameCell

            if (cell.txtShortNAme.text ?? "").count == 0{
                Utilities.sharedInstance.showAlertView(title: "", message: "Please enter short name")
            }else{
                self.homeViewModel.updateBillShortNAme(billID: self.billID, billNickName: (cell.txtShortNAme.text ?? "")) { response in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            let cell = self.tblView.cellForRow(at: IndexPath(row: json.customerParams.count, section: 0)) as! AddBillerDetailsTotalAmountCell
            
            var minimumValue : Int?
            var maximumValue : Int?
            if let arrayOfPaymentChannels = self.json.paymentChannelsAllowed {
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
            
            if let amount = self.json.amount {
                if let amountExact = self.json.paymentAmountExactness {
                    if amountExact == "EXACT_AND_ABOVE" {
                        let enteredAmount: Int? = Int(cell.txtAmount.text!)
                        let actualAmount: Int? = Int(amount)
                        if let enteredAmt = enteredAmount, let actualAmt = actualAmount, let maxVal = maximumValue {
                            if enteredAmt >= actualAmt && enteredAmt <= maxVal {
                                self.preparePayment(amount: cell.txtAmount.text ?? "")
                            } else {
                                Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(actualAmt) and \(maxVal)")
                            }
                        }
                    } else if amountExact == "EXACT_AND_BELOW" {
                        let enteredAmount: Int? = Int(cell.txtAmount.text!)
                        let actualAmount: Int? = Int(amount)
                        if let enteredAmt = enteredAmount, let actualAmt = actualAmount, let minVal = minimumValue {
                            if enteredAmt <= actualAmt && enteredAmt >= minVal {
                                self.preparePayment(amount: cell.txtAmount.text ?? "")
                            } else {
                                Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(minVal) and \(actualAmt)")
                            }
                        }
                    } else if (amountExact == "EXACT") {
                        self.preparePayment(amount: "\(amount)")
                    }
                    print("Entered Amount: \(cell.txtAmount.text!), IsValueAmount: \((cell.txtAmount.text!).isNumber)")
                } else {
                    self.preparePayment(amount: "\(amount)")
                    print("Entered Amount: \(amount) , IsValueAmount: \("\(amount)".isNumber)")
                }
            } else {
                let enteredAmount: Int? = Int(cell.txtAmount.text!)
                if let enteredAmt = enteredAmount, let minVal = minimumValue, let maxVal = maximumValue {
                    if enteredAmt >= minVal && enteredAmt <= maxVal {
                        self.preparePayment(amount: cell.txtAmount.text ?? "")
                    } else {
                        Utilities.sharedInstance.showAlertView(title: "", message: "Entered amount must be in between \(minVal) and \(maxVal)")
                    }
                }
                print("Entered Amount: \(cell.txtAmount.text!), IsValueAmount: \((cell.txtAmount.text!).isNumber)")
            }
        }
    }
    
    func preparePayment(amount: String){
        let firstName = dicOfUserProfile.firstName!
        let phone = dicOfUserProfile.phoneNumber!
        let email = dicOfUserProfile.email!
        let lastName = dicOfUserProfile.lastName!
        
        let sUrl = "https://payuresponse.firebaseapp.com/success"
        let fUrl = "https://payuresponse.firebaseapp.com/failure"
        let cUrl = "https://payuresponse.firebaseapp.com/cancel"

        let productInfo = self.addBillerViewModel.dicOfAddedBill.billerName ?? ""
//        let amount = self.addBillerViewModel.dicOfAddedBill.amount ?? 0
        let billerId = self.addBillerViewModel.dicOfAddedBill.billerPayuId ?? ""
        let billId = self.addBillerViewModel.dicOfAddedBill.id ?? 0
        
        var param = [String : Any]()
        
        if (self.json.customerParams.filter{ $0.paramName == "Mobile Number" }).count > 0 {
            param = ["userDetails":
                        ["firstName":firstName,
                         "phone": phone,
                         "email": email,
                         "lastName": lastName,
                         "userId": "0"],
                     "customerParams":["paramName":"Mobile Number",
                                       "value":(self.json.customerParams.filter{ $0.paramName == "Mobile Number" }).first?.value],
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
    @objc func btnAutoPayConfirmAction(){
        
        var maxAMountLimit = ""
        let amount = "\(self.json.amount ?? 0)"

        var isMaxAmountLimitChange = false
        var isPaymentMethodTypeChange = false
        if isAutoPayEdit {
            maxAMountLimit = self.autoPaymentMaxAmount
            
            if (self.json.autoPay ?? false) {
                let maxAmount = self.json.standingInstruction?.maxLimitAmount ?? 0
                let maxAmountString = maxAmount == 0 ? "" : "\(maxAmount)"
                
                let selectedMethod = self.json.standingInstruction?.preferredPaymentMode ?? ""
                
                if maxAMountLimit != maxAmountString{
                    isMaxAmountLimitChange = true
                }
                
                if selectedPaymentMethod != selectedMethod {
                    isPaymentMethodTypeChange = true
                }
            }
        } else {
            let cell = self.tblView.cellForRow(at: IndexPath(row: self.json.customerParams.count + 1, section: 0)) as! MyBillDetailsReminderCell
            maxAMountLimit = cell.txtMaxLimit.text ?? ""
        }

        var customerParamsList : [[String: Any]] = []
        for obj in self.json.customerParams {
            if let paramName = obj.paramName {
                customerParamsList.append(["paramName": paramName, "value": obj.value ?? ""])
            }
        }
        
        if maxAMountLimit.count == 0 {
            let alertMessage = "Enter Max limit."
            let alert = UIAlertController(title: "",
                                          message: alertMessage,
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        } else if selectedPaymentMethod == "" {
            let alertMessage = "Choose Payment Method."
            let alert = UIAlertController(title: "",
                                          message: alertMessage,
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        } else {
            let param : [String: Any] = [
                "paymentDetails": [
                    "additionalParams": [
                        "agentTxnID": "PU0689231"
                    ],
                    "amount": isPaymentMethodTypeChange ? "1" : amount,
                    "billCustomerParamsList": customerParamsList,
                    "billId": self.json.id ?? "",
                    "billerId": self.json.billerPayuId ?? "",
                    "cUrl": "https://api1.usprojects.co/tsp/bill-details/v1/api/payment/cancel",
                    "deviceDetails": [
                        "APP": "ANDROID",
                        "IMEI": "866409033986700",
                        "INITIATING_CHANNEL": "MOB",
                        "IP": "0.0.0.0",
                        "OS": "android"
                    ],
                    "fUrl": "https://api1.usprojects.co/tsp/bill-details/v1/api/payment/failure",
                    "productInfo": "BHIM Biller 13",
                    "sUrl": "https://api1.usprojects.co/tsp/bill-details/v1/api/payment/success",
                    "userDetails": [
                        "email": dicOfUserProfile.email ?? "",
                        "firstName": dicOfUserProfile.firstName ?? "",
                        "lastName": dicOfUserProfile.lastName ?? "",
                        "phone": dicOfUserProfile.phoneNumber ?? "",
                        "userId": 0
                    ]
                ],
                "standingInstruction": [
                    "billId": self.json.id ?? "",
                    "billerId": self.json.billerPayuId ?? "",
                    "maxLimitAmount": maxAMountLimit,
                    "pgType": "custom",
                    "preferredPaymentMode": selectedPaymentMethod
                ]
            ]
            
            if (self.autoPayID.count > 0) {
                self.homeViewModel.setAutoPay(autoPayID: self.autoPayID, param: param) { response in
                    if (isPaymentMethodTypeChange) {
                        PayUCheckoutPro.open(on: self, paymentParam: self.getPaymentParam(), delegate: self)
                    }
                }
            } else {
                self.homeViewModel.setAutoPay(param: param) { response in
                    PayUCheckoutPro.open(on: self, paymentParam: self.getPaymentParam(), delegate: self)
                }
            }
        }
    
        
        
    }
    
    private func getPaymentParam() -> PayUPaymentParam{
        if (self.isAutoPayEdit && self.autoPayID.count > 0) {
            let key = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.key ?? ""
            let transactionId = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.txnid ?? ""
            let amount = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.amount ?? 0
            let productInfo = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.productinfo ?? ""
            let firstName = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.firstname ?? ""
            let email = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.email ?? ""
            let phone = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.phone ?? ""
            let surl = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.surl ?? ""
            let furl = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.furl ?? ""
            
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
        } else {
            let key = self.homeViewModel.dicAutoPayPrePayment.key ?? ""
            let transactionId = self.homeViewModel.dicAutoPayPrePayment.txnid ?? ""
            let amount = self.homeViewModel.dicAutoPayPrePayment.amount ?? 0
            let productInfo = self.homeViewModel.dicAutoPayPrePayment.productinfo ?? ""
            let firstName = self.homeViewModel.dicAutoPayPrePayment.firstname ?? ""
            let email = self.homeViewModel.dicAutoPayPrePayment.email ?? ""
            let phone = self.homeViewModel.dicAutoPayPrePayment.phone ?? ""
            let surl = self.homeViewModel.dicAutoPayPrePayment.surl ?? ""
            let furl = self.homeViewModel.dicAutoPayPrePayment.furl ?? ""
            
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
    @objc func btnReminderConfirmAction(){
        let cell = self.tblView.cellForRow(at: IndexPath(row: self.json.customerParams.count + 1, section: 0)) as! MyBillDetailsReminderCell

        var requestParam : [[String: Any]] = []
        let payload = cell.aryOfReminders.filter { $0.isChecked == true }
        if payload.count == 0 {
            let alert = UIAlertController(title: "",
                                          message: "Choose Reminder Option.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)

        } else {
            let payloadWithData = payload.filter { $0.value == "" || $0.value == nil}
            if payloadWithData.count > 0 {
                let alertMessage = "Enter No Of Days for '\(payloadWithData[0].eventSubTypes ?? "")'"
                let alert = UIAlertController(title: "",
                                              message: alertMessage,
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)

            } else {
                for obj in payload {
                    if (obj.eventSubTypes ?? "").lowercased().contains("before") {
                        let param : [String: Any] = ["billId": self.json.id ?? 0, "daysAfterBillGenerated": 0, "daysBeforeDueDate": obj.value ?? "0", "eventSubType": obj.eventSubTypeId ?? 0, "eventType": 2, "isEnable": obj.isChecked ?? false]
                        requestParam.append(param)
                    } else {
                        let param : [String: Any] = ["billId": self.json.id ?? 0, "daysAfterBillGenerated": obj.value ?? "0", "daysBeforeDueDate": 0, "eventSubType": obj.eventSubTypeId ?? 0, "eventType": 2, "isEnable": obj.isChecked ?? false]
                        requestParam.append(param)
                    }
                    
                    
                    print("Check box : \(String(describing: obj.isChecked) ) and Value: \(String(describing: obj.value))")
                }
                self.reminderListViewModel.setReminderByBillID(billID: "\(self.json.id ?? 0)", requestParam: requestParam) { response in
                    let alert = UIAlertController(title: "",
                                                  message: "Successfully updated all reminder(s) pertaining to bill.",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    
                    self.isReminderSetUpdate = true
                    self.autoPayAndReminderCOnfiguration()
                    self.setupReminderCell()
                    self.tblView.reloadRows(at: [IndexPath(row: self.json.customerParams.count + 1, section: 0)], with: .none)
                }
            }
        }


    }
    
    @objc func btnPaymentMethodAction(_ sender: UIButton){
        ActionSheetStringPicker.show(withTitle: "Payment Method", rows: self.aryOfPaymentMethod
                                     , initialSelection: 0, doneBlock: {
            picker, values, indexes in
            
            self.selectedPaymentMethod = "\(indexes!)"
            self.tblView.reloadData()
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return
            
        }, origin: sender)
    }
    
    @objc func buttonCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupReminderCell(){
        if self.isReminderSet && self.isAutoPay{
            if isReminderSetUpdate{
                if self.isAutoPay {
                    self.reminderHeight = 300
                } else {
                    self.reminderHeight = 70
                }
            } else {
                if isAutoPayOnForBill {
                    if self.reminderListViewModel.dicOfReminderSubtype != nil, let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
                        self.reminderHeight = (44 * payload.count) + 120 + 64
                    } else {
                        self.reminderHeight = 120 + 64
                    }
                } else {
                    if let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
                        self.reminderHeight = 265 + (44 * payload.count) + 120 + 64
                    } else {
                        self.reminderHeight = 265 + 120 + 64
                    }
                }
            }
        } else if (self.isReminderSet == false && self.isAutoPay == false) {
            self.reminderHeight = 70
        } else if (self.isReminderSet == true && self.isAutoPay == false) {
            if let payload = self.reminderListViewModel.dicOfReminderSubtype.payload {
                if isReminderSetUpdate{
                    self.reminderHeight = 70
                } else {
                    self.reminderHeight = (44 * payload.count) + 120 + 64
                }
            } else {
                if isReminderSetUpdate{
                    self.reminderHeight = 70
                } else {
                    self.reminderHeight = 120 + 64
                }
            }
        } else if (self.isReminderSet == false && self.isAutoPay == true) {
            if isAutoPayEdit {
                self.reminderHeight = 260
            } else {
                if isAutoPayOnForBill {
                    self.reminderHeight = 70
                } else {
                    self.reminderHeight = 265 + 70
                }
            }
        } else {
            self.reminderHeight = 70
        }
        
        if isReminderHide && isAutoPayHide{
            self.reminderHeight = 0
        }
    }
}

extension HomeDetailsVC: PayUCheckoutProDelegate {
    func onError(_ error: Error?) {
        print(error?.localizedDescription ?? "")
        showAlert(title: "Error", message: error?.localizedDescription ?? "")
    }
    
    func onPaymentSuccess(response: Any?) {
        if (self.isAutoPayEdit && self.autoPayID.count > 0) {

            if let transactionId = self.homeViewModel.dicAutoPayUpdatePrePayment.transactionRequest?.txnid{
                self.addBillerViewModel.verifyPayment(transactionID: transactionId) { response in
                    let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
                    let obj = self.addBillerViewModel.aryOfVerifyPaymentModel[0]
                    nextVC.transactionID = obj.txnId ?? ""
                    nextVC.isFromHomeDetail = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }else{
                showAlert(title: "Failure", message: "Payment is not verfied")
            }
        } else {
            if let transactionId = self.homeViewModel.dicAutoPayPrePayment.txnid{
                self.addBillerViewModel.verifyPayment(transactionID: transactionId) { response in
                    let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
                    let obj = self.addBillerViewModel.aryOfVerifyPaymentModel[0]
                    nextVC.transactionID = obj.txnId ?? ""
                    nextVC.isFromHomeDetail = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }else{
                showAlert(title: "Failure", message: "Payment is not verfied")
            }
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
