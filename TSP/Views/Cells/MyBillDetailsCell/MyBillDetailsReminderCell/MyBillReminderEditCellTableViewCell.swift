//
//  MyBillReminderEditCellTableViewCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 17/12/21.
//

import UIKit

class MyBillReminderEditCellTableViewCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    @IBOutlet weak var btnReminderOption: UIButton!
    
    @IBOutlet weak var txtReminderOption: UITextField!
    
    @IBOutlet weak var lblReminderOption: UILabel!
    
    @IBOutlet weak var txtReminderOptionValue: UITextField!
    
    @IBOutlet weak var lblReminderOptionValue: UILabel!

    @IBOutlet weak var switchReminder: UISwitch!
    @IBOutlet weak var consReminderEditViewHeight: NSLayoutConstraint!
    @IBOutlet weak var consReminderValueViewHeight: NSLayoutConstraint!

    @IBOutlet weak var btnEdit: UIButton!
    var reminderOptionValue:((_ value : String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtReminderOptionValue.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MyBillReminderEditCellTableViewCell : UITextFieldDelegate {
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
        self.reminderOptionValue?(textField.text ?? "")
    }
}
