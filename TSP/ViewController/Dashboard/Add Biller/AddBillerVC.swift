//
//  AddBillerVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Contacts
import SocketIO

fileprivate let identifierStep1 = "StepOneViewCell"
fileprivate let identifierStep2 = "StepTwoProviderCell"
fileprivate let identifierStep3 = "StepThreeProviderCell"

enum Steps: Int{
    case step1 = 0
    case step2 = 1
    case step3 = 2
}

class AddBillerVC: UIViewController {
    
    var step1Selection : [String:String]?
    var step2Selection : [String:String]?
    var step3Selection : [String:String]?
    
    @IBOutlet weak var tblBiller: UITableView!
    @IBOutlet weak var lblAddBiller: UILabel!
    
    var heights = [Int: CGFloat]()
    
    let homeViewModel = HomeViewModel()
    var displayCategories = [GroupDisplayCategory]()
    var displayFilteredCategories = [GroupDisplayCategory]()
    
    var isCategorySelected : Bool = false
    var isBillerSelected : Bool = false
    
    var selectedCategoryIndex : Int!
    var selectedBillerIndex : Int!
    var unknowContact : String = ""
    var addBillerViewModel = AddBillerViewModel()
    
    var aryOfBillerList : [AddBillerModelContent] = []
    var aryOfFilteredBillerList : [AddBillerModelContent] = []
    
    var aryOfBillerDetailList: [AddBillerCustomerParam] = []
    
    var showAddToBillerCheckbox = false
    
    var shortName : String = ""
    
    var contacts = [FetchedContact]()
    var contactsFiltered = [FetchedContact]()
    
    var isMobilePrepaidSeleted : Bool = false
    var selectedOperator = ""
    var selectedCircle = ""
    
    var numberOfPlans : Int = 6
    
    //    var selectedOperatorCircleInfo : GetOperatorCircleInfoPayload
    
    var selectedOperatorObj : GetAllOperatorsContent!
    var selectedCircleObj : GetAllCirclesContent!
    var selectedOperatorCode = ""
    var selectedPlanType = ""
    var isUserBill = false
    
    var rechargPlanTableViewHeight : Float = 400
    var isPushedToDetailScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblBiller.register(BillerStepHeaderCell.nib, forHeaderFooterViewReuseIdentifier: BillerStepHeaderCell.identifier)
        tblBiller.register(BillerCategorySelectHeaderCell.nib, forHeaderFooterViewReuseIdentifier: BillerCategorySelectHeaderCell.identifier)
        tblBiller.register(BillerCategoryStep2Cell.nib, forCellReuseIdentifier: BillerCategoryStep2Cell.identifier)
        
        tblBiller.register(BillerCategoryListCell.nib, forCellReuseIdentifier: BillerCategoryListCell.identifier)
        tblBiller.register(BillerCategoryStep3Cell.nib, forCellReuseIdentifier: BillerCategoryStep3Cell.identifier)
        tblBiller.register(MobileRechargeCell.nib, forCellReuseIdentifier: MobileRechargeCell.identifier)
        self.fetchGroups()
        self.fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (SelectedCategoryForBillerFromHomeVC != nil) {
            if let str = SelectedCategoryForBillerFromHomeVC.name{
                self.lblAddBiller.text = str
                isCategorySelected = true
                isBillerSelected = false
                showAddToBillerCheckbox = true
                self.tblBiller.reloadSections(IndexSet(integer: 0), with: .none)
                self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                fetchBillers(name: str.replacingOccurrences(of: " ", with: "%20"))
            }
        }
        if isPushedToDetailScreen {
            isPushedToDetailScreen = false
            self.isCategorySelected = false
            self.isBillerSelected = false
            self.isMobilePrepaidSeleted = false
            
            self.displayFilteredCategories = self.displayCategories
            self.contactsFiltered = self.contacts
            
            SelectedCategoryForBillerFromHomeVC = nil
            self.showAddToBillerCheckbox = false
            
            self.tblBiller.reloadSections(IndexSet(integer: 0), with: .none)
            self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
            self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)
            self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    func fetchGroups(){
        self.homeViewModel.getListOfGroups { success in
            for dicGroupsContent in self.homeViewModel.dicOfGroups! {
                if let categoryArray = dicGroupsContent.displayCategories {
                        self.displayCategories += categoryArray
                    }
                
            }
            self.displayFilteredCategories = self.displayCategories
            if (SelectedCategoryForBillerFromHomeVC == nil) {
                self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
    }
    
    func fetchBillers(name:String){
        if name.lowercased() == "mobile%20prepaid" {
            isMobilePrepaidSeleted = true
            contacts = [FetchedContact]()
            fetchContacts()
            contactsFiltered = contacts
            
            self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)
            self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            self.tblBiller.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        } else {
            isMobilePrepaidSeleted = false
            self.addBillerViewModel.getBillers(name: name) { success in
                if success == true{
                    if self.addBillerViewModel.dicOfBillerList.content.count == 0 {
                        let errorTitle = name.replacingOccurrences(of: "%20", with: " ").capitalized
                        Utilities.sharedInstance.showAlertView(title: errorTitle, message: "No biller found!")
                    }
                    self.aryOfBillerList = self.addBillerViewModel.dicOfBillerList.content
                    self.aryOfFilteredBillerList = self.aryOfBillerList
                    
                    self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)
                    self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                }else{
                    let errorTitle = name.replacingOccurrences(of: "%20", with: " ").capitalized
                    Utilities.sharedInstance.showAlertView(title: errorTitle, message: "No biller found!")
                }
            }
        }
    }
    
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
    func fetchOperatorInfo(){
        
        var telephoneNumber = ""
        if unknowContact.count == 0 {
            telephoneNumber = contactsFiltered[selectedBillerIndex].telephone.replacingOccurrences(of: " ", with: "")
        } else {
            telephoneNumber = unknowContact.replacingOccurrences(of: " ", with: "")
        }
        self.addBillerViewModel.getOperatorCircleInfo(phoneNumer: telephoneNumber) { response in
            self.selectedCircle = ""
            self.selectedPlanType = ""
            if let operatorCode = self.addBillerViewModel.dicOfOperatorCircleInfo.payload.operatorCode {
                //                self.selectedOperatorCircleInfo = self.addBillerViewModel.dicOfOperatorCircleInfo.payload
                
                self.selectedOperatorCode = operatorCode
                self.selectedOperator = self.addBillerViewModel.dicOfOperatorCircleInfo.payload.operatorName ?? ""
                self.fetchCircleList(operactorCode: operatorCode, isPresent: false)
            } else {
                
                self.addBillerViewModel.getAllOperators { response in
                    self.selectedOperatorObj = self.addBillerViewModel.dicOfOperator.content[0]
                    self.selectedOperator = self.selectedOperatorObj.operatorName ?? ""
                    
                    self.fetchCircleList(operactorCode: self.selectedOperatorObj.operatorCode ?? "", isPresent: false)
                }
            }
            
        }
    }
    
    func fetchCircleList(operactorCode: String, isPresent: Bool){
        self.addBillerViewModel.getAllCircles(operatorId: operactorCode, completion: { response in
            if self.selectedCircle.count == 0 && !isPresent{
                self.selectedCircleObj = self.addBillerViewModel.dicOfCircles.content[0]
                self.selectedCircle = self.selectedCircleObj.circleName ?? ""
                self.selectedPlanType = ""
                self.fetchPlanType()
            }
            if isPresent {
                let vc = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "MobileOperatorOrCircleVC")as! MobileOperatorOrCircleVC
                
                vc.headertText = "Select your Circle"
                vc.contentCircle = self.addBillerViewModel.dicOfCircles.content
                vc.isOperator = false
                vc.selectedItem = { (index, text, isOperator) in
                    self.selectedCircle = self.addBillerViewModel.dicOfCircles.content[index].circleName ?? ""
                    self.selectedCircleObj = self.addBillerViewModel.dicOfCircles.content[index]
                    
                    self.fetchPlanType()
                }
                vc.modalPresentationStyle = .overCurrentContext
                
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    func fetchOperatorList(){
        self.addBillerViewModel.getAllOperators { response in
            if self.selectedOperator.count > 0 {
                self.selectedOperator = self.addBillerViewModel.dicOfOperator.content[0].operatorName ?? ""
            }
            
            let vc = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "MobileOperatorOrCircleVC")as! MobileOperatorOrCircleVC
            vc.headertText = "Select your Operator"
            vc.isOperator = true
            vc.contentOperator = self.addBillerViewModel.dicOfOperator.content
            vc.selectedItem = { (index, text, isOperator) in
                self.selectedOperatorCode = ""
                self.selectedOperator = self.addBillerViewModel.dicOfOperator.content[index].operatorName ?? ""
                self.selectedOperatorObj = self.addBillerViewModel.dicOfOperator.content[index]
                self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
            }
            vc.modalPresentationStyle = .overCurrentContext
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func fetchPlanType(){
        let circleID = selectedCircleObj.circleId ?? ""
        let operatorID = (selectedOperatorCode.count > 0) ? selectedOperatorCode : (selectedOperatorObj.operatorCode ?? "")
        self.addBillerViewModel.getGetPlanTypes(circleId: circleID, operatorId: operatorID) { response in
//            if self.selectedPlanType.count == 0 {
                self.selectedPlanType = self.addBillerViewModel.dicOfPlanTypes.content[0]
                self.fetchPlanList()
//            }
        }
    }
    
    func fetchPlanList(){
        if selectedPlanType.count > 0 {
            if selectedOperatorCode.count > 0 {
                self.addBillerViewModel.getRechargePlans(circleId: (selectedCircleObj.circleId ?? ""), operatorId: selectedOperatorCode, planTypeSearch: selectedPlanType) { response in
                    self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)

                    self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                }
            } else {
                
                self.addBillerViewModel.getRechargePlans(circleId: (selectedCircleObj.circleId ?? ""), operatorId: (selectedOperatorObj.operatorCode ?? ""), planTypeSearch: selectedPlanType) { response in
                    
                    self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)

                    self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                }
            }
        } else {
            selectedPlanType = self.addBillerViewModel.dicOfPlanTypes.content[0]
            self.addBillerViewModel.getRechargePlans(circleId: (selectedCircleObj.circleId ?? ""), operatorId: (selectedOperatorObj.operatorCode ?? ""), planTypeSearch: self.addBillerViewModel.dicOfPlanTypes.content[0]) { response in
                
                self.tblBiller.reloadSections(IndexSet(integer: 1), with: .none)

                self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
            }
        }
    }
}

extension AddBillerVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isCategorySelected {
                return 1
            }
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BillerCategoryListCell.identifier, for: indexPath) as! BillerCategoryListCell
            cell.displayCategories = self.displayFilteredCategories
            
            cell.selectedCategory = { index in
                self.isCategorySelected = true
                self.isBillerSelected = false
                self.selectedCategoryIndex = index
                
                if let categoryName = self.displayFilteredCategories[index].name {
                    self.lblAddBiller.text = "Add Biller"

                    self.fetchBillers(name: categoryName.replacingOccurrences(of: " ", with: "%20"))
                }
                
                tableView.reloadSections(IndexSet(integer: 0), with: .none)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            cell.collectionView.reloadData()
            return cell
        } else if indexPath.section == 1 && isCategorySelected{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BillerCategoryStep2Cell.identifier, for: indexPath) as! BillerCategoryStep2Cell
            cell.isMobilePrepaidSeleted = isMobilePrepaidSeleted
            cell.contacts = contactsFiltered
            cell.aryOfBillerList = self.aryOfFilteredBillerList
            cell.selectedBiller = { index in
                self.isBillerSelected = true
                self.selectedBillerIndex = index
                

                if !self.isMobilePrepaidSeleted {
                    tableView.reloadSections(IndexSet(integer: 1), with: .none)

                    self.aryOfBillerDetailList = self.aryOfFilteredBillerList[index].customerParams
                    tableView.reloadSections(IndexSet(integer: 2), with: .none)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                } else {
                    self.unknowContact = ""
                    self.fetchOperatorInfo()
                }
            }
            
            cell.tableView.reloadData()
            return cell
        } else if indexPath.section == 2 && isBillerSelected {
            if isMobilePrepaidSeleted {
                let cell = tableView.dequeueReusableCell(withIdentifier: MobileRechargeCell.identifier, for: indexPath) as! MobileRechargeCell
//                if self.addBillerViewModel.dicOfPlanTypes != nil {
//                    cell.arrayOfPlanType = self.addBillerViewModel.dicOfPlanTypes.content
//                    if (self.addBillerViewModel.dicOfPlanTypes.content.count > 0 && selectedPlanType.count == 0) {
////                        self.fetchPlanList()
//                    } else {
//                        cell.selectedIndex = self.addBillerViewModel.dicOfPlanTypes.content.firstIndex(of: selectedPlanType) ?? 0
//                    }
//                } else {
//                    cell.arrayOfPlanType = []
//                }
                if self.addBillerViewModel.dicOfPlanTypes != nil {
                    
                    cell.arrayOfPlanType = self.addBillerViewModel.dicOfPlanTypes.content
                    cell.selectedIndex = self.addBillerViewModel.dicOfPlanTypes.content.firstIndex(of: selectedPlanType) ?? 0
                }
               
                cell.collectionView.reloadData()
                if self.addBillerViewModel.dicOfPlanTypes != nil {
                    cell.collectionView.scrollToItem(at: IndexPath(row: self.addBillerViewModel.dicOfPlanTypes.content.firstIndex(of: selectedPlanType) ?? 0, section: 0), at: .centeredHorizontally, animated: false)
                }
                cell.selectedPlanType = { planType in
                    self.selectedPlanType = planType
                    self.fetchPlanList()
                }
                if self.addBillerViewModel.dicOfRechargePlans != nil {
                    cell.rechargePlans = self.addBillerViewModel.dicOfRechargePlans.content
                    cell.tblPlanList.reloadData()
                }
                cell.isHeightCalculated = false
                cell.rechargePlanTableHeight = { height in
                    if height != self.rechargPlanTableViewHeight {
                        self.rechargPlanTableViewHeight = Float(cell.tblPlanList.contentSize.height)
                        self.tblBiller.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                    }
                }
                cell.setupUI(selectedOperator: self.selectedOperator, selectedCircle: self.selectedCircle)
                cell.isOperatorSelected = { isOperator in
                    if isOperator {
                        self.fetchOperatorList()
                    } else {
                        if self.selectedOperatorCode.count > 0 {
                            self.fetchCircleList(operactorCode: self.selectedOperatorCode, isPresent:  true)
                        } else {
                            self.fetchCircleList(operactorCode: self.selectedOperatorObj.operatorCode ?? "", isPresent: true)
                        }
                    }
                }
                
                cell.rechargePlanSelect = { index in
                    let vc = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "AddBillerDetailVC")as! AddBillerDetailVC
                    
                    if let planId = self.addBillerViewModel.dicOfRechargePlans.content[index].id {
                        vc.planID = "\(planId)"
                    }
                    if self.unknowContact.count > 0 {
                        vc.contactName = "Contact Number"
                        vc.contactNumber = self.unknowContact
                        vc.isUserBill = self.isUserBill
                    } else {
                        vc.contactName = self.contactsFiltered[self.selectedBillerIndex].firstName + " " + self.contactsFiltered[self.selectedBillerIndex].firstName
                        vc.contactNumber = self.contactsFiltered[self.selectedBillerIndex].telephone
                        vc.isUserBill = self.isUserBill
                    }
                    self.isPushedToDetailScreen = true
                    vc.isRecharge = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if showAddToBillerCheckbox {
                    cell.consAddToMyBillsHightZero.priority = UILayoutPriority(250)
                } else {
                    cell.consAddToMyBillsHightZero.priority = UILayoutPriority(999)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: BillerCategoryStep3Cell.identifier, for: indexPath) as! BillerCategoryStep3Cell
                
                cell.aryOfBillerDetailList = self.aryOfBillerDetailList
                
                if showAddToBillerCheckbox {
                    cell.consAddToMyBillHeight.priority = UILayoutPriority(250)
                } else {
                    cell.consAddToMyBillHeight.priority = UILayoutPriority(999)
                }
                
                cell.enteredText = { (index, value) in
                    if index < self.aryOfBillerDetailList.count {
                        self.aryOfBillerDetailList[index].inputedValue = value
                    } else {
                        self.shortName = value
                    }
                }
                
                cell.btnConfirm.addTarget(self, action: #selector(btnConfirmAction), for: .touchUpInside)
                
                cell.tableView.reloadData()
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @objc func btnConfirmAction(){
        var isInvalidData : Bool = false
        
        for obj in aryOfBillerDetailList{
            if obj.optional == "false"{
                if (obj.inputedValue?.isEmpty == true || obj.inputedValue == nil) {
                    isInvalidData = true
                    //should not be empty is compalsary field
                    Utilities.sharedInstance.showAlertView(title: "", message: "Please enter \(obj.paramName?.lowercased() ?? "")")
                    break
                }
            }
            
            if let minLength = obj.minLength{
                if !minLength.isEmpty && (obj.inputedValue ?? "").count < Int(minLength) ?? 0 {
                    isInvalidData = true
                    print("Minimum length:\(minLength)")
                    print("RegEx:\(obj.regex ?? "")")
                    print("Data Type:\(obj.dataType ?? "")")
                    print("Placeholder Name:\(obj.paramName ?? "")")
                    //min length of character not inputed
                    Utilities.sharedInstance.showAlertView(title: "", message: "Minimum length for \(obj.paramName?.lowercased() ?? "") is \(minLength)")
                    break
                }
            }
            
            if let regEx = obj.regex{
                if !regEx.isEmpty {
                    let result = (obj.inputedValue ?? "").range(
                        of: regEx,
                        options: .regularExpression
                    )
                    if result == nil{
                        isInvalidData = true
                        //regex match issue
                        Utilities.sharedInstance.showAlertView(title: "", message: "\(obj.paramName?.lowercased() ?? "") is invalid")
                        break
                    }
                }
            }
        }
        
        if isInvalidData{
            
        }else{
            let cell = self.tblBiller.cellForRow(at: IndexPath(row: 0, section: 2)) as! BillerCategoryStep3Cell
            if cell.isAddToMyBill {
                self.isUserBill = true
                if cell.shorNameValue.count == 0{
                    Utilities.sharedInstance.showAlertView(title: "", message: "Please enter short name")
                }else{
                    print("shot name:\(cell.shorNameValue)")
                    
                    let vc = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "AddBillerDetailVC")as! AddBillerDetailVC
                
                    self.isPushedToDetailScreen = true
                    vc.addBillerModel = self.aryOfFilteredBillerList[selectedBillerIndex]
                    vc.aryOfBillerDetailList = aryOfBillerDetailList
                    vc.shortName = self.shortName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                self.isUserBill = false
                let vc = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "AddBillerDetailVC")as! AddBillerDetailVC
            
                self.isPushedToDetailScreen = true
                vc.addBillerModel = self.aryOfFilteredBillerList[selectedBillerIndex]
                vc.aryOfBillerDetailList = aryOfBillerDetailList
                vc.shortName = self.shortName
                self.navigationController?.pushViewController(vc, animated: true)
                print("shot name:\(cell.shorNameValue)")
            }
            
            for obj in aryOfBillerDetailList {
                print("\(obj.paramName ?? "") value: \(obj.inputedValue ?? "")")
            }
            
            print("all data are valid")
            print("Input valid data")
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && isCategorySelected {
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BillerCategorySelectHeaderCell.identifier) as! BillerCategorySelectHeaderCell
            
            header.selectedCategory.isHidden = false
            header.lblContactName.isHidden = true
            header.lblContactNumber.isHidden = true
            
            if (SelectedCategoryForBillerFromHomeVC != nil) {
                if let str = SelectedCategoryForBillerFromHomeVC.iconUrl{
                    let fileUrl = URL(string: str)
                    header.imgCategory.sd_setImage(with: fileUrl)
                }
                
                header.setupHeader(stepsText: "Step 1", selectedHeaderText: "Select Biller Category", title: SelectedCategoryForBillerFromHomeVC.name ?? "", titleFontSize: 24)
            } else {
                if let str = self.displayFilteredCategories[selectedCategoryIndex].iconUrl{
                    let fileUrl = URL(string: str)
                    header.imgCategory.sd_setImage(with: fileUrl)
                }
                
                header.setupHeader(stepsText: "Step 1", selectedHeaderText: "Select Biller Category", title: self.displayFilteredCategories[selectedCategoryIndex].name ?? "", titleFontSize: 24)
            }
            header.closeCategory = { isClose in
                self.isCategorySelected = false
                self.isBillerSelected = false
                self.displayFilteredCategories = self.displayCategories
                self.contactsFiltered = self.contacts

                SelectedCategoryForBillerFromHomeVC = nil
                self.showAddToBillerCheckbox = false
                
                tableView.reloadSections(IndexSet(integer: 0), with: .none)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            }
            return header
            
        } else if section == 1 && isBillerSelected {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BillerCategorySelectHeaderCell.identifier) as! BillerCategorySelectHeaderCell
            if isMobilePrepaidSeleted {
                header.selectedCategory.isHidden = true
                header.lblContactName.isHidden = false
                header.lblContactNumber.isHidden = false
                
                if unknowContact.count == 0 {
                    header.lblContactName.text = "\(contactsFiltered[selectedBillerIndex].firstName) \(contactsFiltered[selectedBillerIndex].lastName)"
                    header.lblContactNumber.text = contactsFiltered[selectedBillerIndex].telephone
                } else {
                    header.lblContactName.text = "Unknown"
                    header.lblContactNumber.text = unknowContact
                }
                
                header.setupHeader(stepsText: "Step 2", selectedHeaderText: "Selected Contact", title: "", titleFontSize: 0)
                
            } else {
                
                header.selectedCategory.isHidden = false
                header.lblContactName.isHidden = true
                header.lblContactNumber.isHidden = true
                
                header.imgCategory.image = UIImage(named: "ic_bharatbillpay")
                
                header.setupHeader(stepsText: "Step 2", selectedHeaderText: "Selected Provider", title: self.aryOfFilteredBillerList[selectedBillerIndex].billerName ?? "", titleFontSize: 12)
            }
            //            if let str = self.aryOfFilteredBillerList[selectedBillerIndex].iconUrl{
            //                let fileUrl = URL(string: str)
            //                header.imgCategory.sd_setImage(with: fileUrl)
            //            }
            
            header.closeCategory = { isClose in
                self.isBillerSelected = false
                self.aryOfFilteredBillerList = self.aryOfBillerList
                
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            }
            
            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BillerStepHeaderCell.identifier) as! BillerStepHeaderCell
            if section == 0 {
                header.setBorder(setborder: false)
                header.searchHandler = { searchText in
                    if searchText.count > 0 {
                        self.displayFilteredCategories = self.displayCategories.filter{ $0.name?.lowercased().contains(searchText.lowercased()) == true }
                    } else {
                        self.displayFilteredCategories = self.displayCategories
                    }
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            } else if section == 1 && isCategorySelected {
                header.setBorder(setborder: false)
                if isMobilePrepaidSeleted {
                    header.txtSearch.placeholder = "Search Contact"
                } else {
                    header.txtSearch.placeholder = "Search Category"
                }
                header.searchHandler = { searchText in
                    if self.isMobilePrepaidSeleted {
                        if searchText.count > 0 {
                            self.contactsFiltered = self.contacts.filter{ $0.firstName.lowercased().contains(searchText.lowercased()) == true }
                        } else {
                            self.contactsFiltered = self.contacts
                        }
                    } else {
                        if searchText.count > 0 {
                            self.aryOfFilteredBillerList = self.aryOfBillerList.filter{ $0.billerName?.lowercased().contains(searchText.lowercased()) == true }
                        } else {
                            self.aryOfFilteredBillerList = self.aryOfBillerList
                        }
                    }
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                }
                if self.isMobilePrepaidSeleted {
                    
                    header.searchEndHandler = { searchText in
                        let isNumberText =  (!searchText.isEmpty && (searchText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) && searchText.count >= 10)
                        
                        if self.contactsFiltered.count == 0 && isNumberText {
                            self.unknowContact = searchText
                            self.isBillerSelected = true
                            self.contactsFiltered = self.contacts
                            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)

                            self.fetchOperatorInfo()
                        }
                    }
                }
            } else {
                if isBillerSelected || isMobilePrepaidSeleted{
                    header.setBorder(setborder: false)
                    header.viewSearchField.isHidden = true
                } else {
                    header.setBorder(setborder: true)
                }
            }
            
            if section == 0 {
                header.lblStepsTitle.text = "Select Biller Category"
            } else if section == 1 {
                if isMobilePrepaidSeleted {
                    header.lblStepsTitle.text = "Select Contact"
                } else {
                    header.lblStepsTitle.text = "Select Provider"
                }
                
            } else {
                header.lblStepsTitle.text = "Add Details"
            }
            
            header.lblSteps.text = "Step \(section + 1)"
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isCategorySelected {
                return 0
            }
            var mode = self.displayFilteredCategories.count / 3
            if ((mode * 3) != self.displayFilteredCategories.count) {
                mode += 1
            }
            return CGFloat(mode * 70)
        } else if indexPath.section == 1 {
            if isBillerSelected {
                return 0
            } else {
                if isCategorySelected{
                    if isMobilePrepaidSeleted {
                        if contactsFiltered.count > 10 {
                            return CGFloat(10 * 44)
                        }
                        return CGFloat(contactsFiltered.count * 44)
                    } else {
                        if aryOfFilteredBillerList.count > 10 {
                            return CGFloat(10 * 44)
                        }
                        return CGFloat(aryOfFilteredBillerList.count * 44)
                    }
                }
            }
            return 0
        } else if indexPath.section == 2 {
            if isBillerSelected {
                if isMobilePrepaidSeleted {
//                    if self.addBillerViewModel.dicOfRechargePlans != nil {
//                        if self.addBillerViewModel.dicOfRechargePlans.content.count > 5 {
//                            return CGFloat(400 + rechargPlanTableViewHeight)
//                        } else {
//                            return CGFloat(400 + rechargPlanTableViewHeight)
//                        }
//                    } else {
                        return CGFloat(230 + rechargPlanTableViewHeight)
//                    }
                    
                } else {
                    if showAddToBillerCheckbox {
                        return CGFloat((aryOfBillerDetailList.count + 1) * 44) + 129
                    } else {
                        return CGFloat((aryOfBillerDetailList.count + 1) * 44) + 89
                    }
                }
            }
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && !isCategorySelected{
            return 130
        } else if section == 1 && (isCategorySelected || isBillerSelected) {
            return 130
        } else if section == 2 && isBillerSelected {
            return 80
        }
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

class SectionTapGesture: UITapGestureRecognizer {
    var section = 0
}
