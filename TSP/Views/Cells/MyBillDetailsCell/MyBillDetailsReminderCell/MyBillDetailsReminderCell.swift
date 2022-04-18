//
//  MyBillDetailsReminderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 11/10/21.
//

import UIKit

class MyBillDetailsReminderCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var tblView: UITableView!
    
    
    @IBOutlet weak var lblReminder: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var autoPaySwitch: UISwitch!
    
    @IBOutlet weak var consViewAutoPayToHide: NSLayoutConstraint!
    
    @IBOutlet weak var txtMaxLimit: UITextField!
    @IBOutlet weak var txtPaymentMethod: UITextField!
    @IBOutlet weak var btnPaymentMethod: UIButton!

    @IBOutlet weak var btnAutoPayConfirm: UIButton!
    @IBOutlet weak var btnReminderConfirm: UIButton!

    var aryOfReminders : [ReminderSubtype] = []
    var aryOfRemindersValue: [ReminderListPayload] = []

    @IBOutlet weak var lblAutoPayTitle: UILabel!
    @IBOutlet weak var lblReminderTitle: UILabel!
    var isFirstTime : Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tableViewSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MyBillDetailsReminderCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryOfReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsReminderItemCell.identifier, for: indexPath) as? MyBillDetailsReminderItemCell else {
            fatalError("XIB doesn't exist.")
        }
        
        var reminderObj = self.aryOfReminders[indexPath.row]
        
        if isFirstTime {
            let payload = self.aryOfRemindersValue.filter{ $0.eventSubType == reminderObj.eventSubTypes}
            
            if payload.count > 0 {
                if (reminderObj.eventSubTypes ?? "").lowercased().contains("before") {
                    if let value = payload.first?.daysBeforeDueDate {
                        if value > 0 {
                            reminderObj.value = "\(value)"
                        } else {
                            reminderObj.value = ""
                        }
                    }
                    reminderObj.isChecked = payload.first?.isEnable ?? false
                } else {
                    if let value = payload.first?.daysAfterBillGenerated {
                        if value > 0 {
                            reminderObj.value = "\(value)"
                        } else {
                            reminderObj.value = ""
                        }
                    }
                    reminderObj.isChecked = payload.first?.isEnable ?? false
                }
            }
            self.aryOfReminders[indexPath.row] = reminderObj
        }
        if let isCheck = reminderObj.isChecked {
            if isCheck {
                cell.imgCheckUncheck.image = UIImage(named: "ic_check")
                cell.txtNoOfDays.isUserInteractionEnabled = true
            } else {
                cell.imgCheckUncheck.image = UIImage(named: "ic_uncheck")
                cell.txtNoOfDays.isUserInteractionEnabled = false
            }
        } else {
            cell.imgCheckUncheck.image = UIImage(named: "ic_uncheck")
            cell.txtNoOfDays.isUserInteractionEnabled = false
        }
        if let value = reminderObj.value {
            cell.txtNoOfDays.text = value
        } else {
            cell.txtNoOfDays.text = ""
        }

        cell.lblReminderTitle.text = reminderObj.eventSubTypes
        cell.btnCheckUncheck.tag = indexPath.row
        cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckHandler), for: .touchUpInside)
        
        cell.txtNoOfDays.delegate = self
        cell.txtNoOfDays.tag = indexPath.row
        return cell
    }
    
    func tableViewSetup(){
        self.tblView.register(MyBillDetailsReminderItemCell.nib, forCellReuseIdentifier: MyBillDetailsReminderItemCell.identifier)
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    @objc func btnCheckUncheckHandler(sender : UIButton) {
        var reminderObj = self.aryOfReminders[sender.tag]
        reminderObj.isChecked = !(reminderObj.isChecked ?? false)
        if reminderObj.isChecked == false {
            reminderObj.value = ""
        }
        self.aryOfReminders[sender.tag] = reminderObj
        isFirstTime = false
        self.tblView.reloadData()
    }

}


extension MyBillDetailsReminderCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 16 characters

        if updatedText.isEmpty {
            return true
        }
        let isNumberText =  (!updatedText.isEmpty && (updatedText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil))

        if isNumberText {
            if updatedText.count == 1 && updatedText == "0" {
                return false
            }
            return (Int(updatedText) ?? 0) <= 30
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var reminderObj = self.aryOfReminders[textField.tag]
        reminderObj.value = textField.text
        self.aryOfReminders[textField.tag] = reminderObj
    }
}
