//
//  MyBillsDetailsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 08/10/21.
//

import UIKit
import ActionSheetPicker_3_0

class MyBillsDetailsVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var json: MyBillsContent!
    
    let reminderViewModel = ReminderListViewModel()
    var isReminderSet = Bool()
    
    var aryOfBool = [false,false]
    var reminderHeight = 70
    
    var aryOfDays = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetup()
        
        self.reminderViewModel.fetchReminderByUserBillID(billID: "\(self.json.id!)") { success in
            self.isReminderSet = success
            self.setupReminderCell()
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupReminderCell(){
        if self.isReminderSet{
            self.reminderHeight = 185
        }else{
            self.reminderHeight = 70
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if value{
            self.isReminderSet = true
            self.setupReminderCell()
            self.tblView.reloadData()
        }else{
            self.isReminderSet = false
            self.reminderHeight = 70
            self.tblView.reloadData()
        }
    }
    
    @objc func buttonConfirm(){
        
    }
    
    @objc func buttonCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonOptionOne(){
        if self.aryOfBool[0]{
            self.aryOfBool[0] = false
            self.selectedValuesForOptionOne = ""
        }else{
            self.aryOfBool[0] = true
        }
        self.tblView.reloadData()
    }
    
    @objc func buttonOptionTwo(){
        if self.aryOfBool[1]{
            self.aryOfBool[1] = false
            self.selectedValuesForOptionTwo = ""
        }else{
            self.aryOfBool[1] = true
        }
        self.tblView.reloadData()
    }
    
    var selectedValuesForOptionOne = ""
    @objc func buttonEnterOptionOne(_ sender: UIButton){
        ActionSheetStringPicker.show(withTitle: "Choose number of days", rows: self.aryOfDays
                                     , initialSelection: 0, doneBlock: {
            picker, values, indexes in
            
            self.selectedValuesForOptionOne = "\(indexes!)"
            self.tblView.reloadData()
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return
            
        }, origin: sender)
    }
    
    var selectedValuesForOptionTwo = ""
    @objc func buttonEnterOptionTwo(_ sender: UIButton){
        ActionSheetStringPicker.show(withTitle: "Choose number of days", rows: self.aryOfDays
                                     , initialSelection: 0, doneBlock: {
            picker, values, indexes in
            
            self.selectedValuesForOptionTwo = "\(indexes!)"
            self.tblView.reloadData()
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return
            
        }, origin: sender)
    }
    
    
}


extension MyBillsDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableViewSetup(){
        self.tblView.register(MyBillDetailsHeaderCell.nib, forCellReuseIdentifier: MyBillDetailsHeaderCell.identifier)
        
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        
        self.tblView.register(MyBillDetailsReminderCell.nib, forCellReuseIdentifier: MyBillDetailsReminderCell.identifier)
        
        self.tblView.register(MyBillDetailsFooterCell.nib, forCellReuseIdentifier: MyBillDetailsFooterCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.customerParams.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UITableView.automaticDimension
        }else if indexPath.row == self.json.customerParams.count + 1{
            return CGFloat(self.reminderHeight)
        }else if indexPath.row == self.json.customerParams.count + 2{
            return 140
        }else{
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
            
            cell.reminderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.reminderSwitch.onTintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            cell.reminderSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            
            return cell
        }else if indexPath.row == self.json.customerParams.count + 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsFooterCell.identifier, for: indexPath) as? MyBillDetailsFooterCell else {
                fatalError("XIB doesn't exist.")
            }
            
            if self.isReminderSet{
                cell.viewConfirm.isHidden = false
            }else{
                cell.viewConfirm.isHidden = true
            }
            
            cell.btnConfirm.addTarget(self, action: #selector(buttonConfirm), for: UIControl.Event.touchUpInside)
            cell.btnCancel.addTarget(self, action: #selector(buttonCancel), for: UIControl.Event.touchUpInside)
            
            return cell
        }else{
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
