//
//  BillerCategoryStep3ItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 14/11/21.
//

import UIKit

class BillerCategoryStep3ItemCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var txtBillerDetail : UITextField!
    
    var objAddBiller: AddBillerCustomerParam?
    var datePickerView  : UIDatePicker = UIDatePicker()

    var enteredText:((_ index : Int, _ value : String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtBillerDetail.delegate = self
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpData(objAddBiller: AddBillerCustomerParam) {
        
        self.objAddBiller = objAddBiller
        
        var placeholder = objAddBiller.paramName
        if objAddBiller.optional == "false"{
            placeholder = (placeholder ?? "") + "*"
            
            let length = placeholder?.count ?? 1
            
            let str = NSMutableAttributedString(string: placeholder ?? "", attributes: [:])
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: (length - 1) ,length:1))
            // set label Attribute
            txtBillerDetail.attributedPlaceholder = str
            
        } else {
            txtBillerDetail.placeholder = objAddBiller.paramName
        }
        
        if ((placeholder ?? "").contains("Date") || (placeholder ?? "").contains("DOB")) {
            txtBillerDetail.inputView = datePickerView
        } else {
            if objAddBiller.dataType == "ALPHANUMERIC" {
                txtBillerDetail.keyboardType = .default
            } else if objAddBiller.dataType == "NUMERIC" {
                txtBillerDetail.keyboardType = .numberPad
            } else {
                txtBillerDetail.keyboardType = .default
            }
        }
        
       
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getDateFormatFromPlaceholder(value: txtBillerDetail.placeholder ?? "dd-MM-YYYY")
        txtBillerDetail.text = dateFormatter.string(from: datePickerView.date)
    }
    
    func getDateFormatFromPlaceholder(value: String) -> String {
        let array = value.components(separatedBy: "(")
        
        if array.count > 1 {
            var formate = array[1].replacingOccurrences(of: "*", with: "")
            formate = formate.replacingOccurrences(of: ")", with: "")
            formate = formate.replacingOccurrences(of: "DD", with: "dd")
            return formate
        } else {
            return "dd-MM-YYYY"
        }
    }
    
}

extension BillerCategoryStep3ItemCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 16 characters

        if self.objAddBiller == nil {
            return true
        }
        if let maxLength = self.objAddBiller?.maxLength {
            return updatedText.count <= Int(maxLength) ?? 0
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        enteredText?(textField.tag, textField.text ?? "")
    }
}
