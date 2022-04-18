//
//  MyBillAutoPayEditCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 24/12/21.
//

import UIKit

class MyBillAutoPayEditCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwAutoPayEdit: UIView!
    
    @IBOutlet weak var lblMaxAmount: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    @IBOutlet weak var txtMaxAmount: UITextField!
    @IBOutlet weak var txtPaymentMethod: UITextField!

    @IBOutlet weak var btnSelectPaymentMethod: UIButton!
    
    @IBOutlet weak var switchAutoPay: UISwitch!
    @IBOutlet weak var vwAutopayAmount: UIView!
    @IBOutlet weak var vwPaymentType: UIView!
    
    var maxminAmountValue:((_ value : String) -> ())?
    var isAutoPayEditing:((_ value : Bool) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnEdit.addTarget(self, action: #selector(self.btnEditAction(sender:)), for: .touchUpInside)
        self.txtMaxAmount.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnEditAction(sender: UIButton) {
        self.vwAutoPayEdit.isHidden = false
        self.vwAutopayAmount.isHidden = true
        self.vwPaymentType.isHidden = true
        self.isAutoPayEditing?(true)
    }
    
}

extension MyBillAutoPayEditCell : UITextFieldDelegate {
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
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.maxminAmountValue?(textField.text ?? "")
    }
    
}
