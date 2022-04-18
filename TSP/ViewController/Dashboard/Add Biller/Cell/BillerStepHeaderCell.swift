//
//  BillerStepHeaderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/11/21.
//

import UIKit

class BillerStepHeaderCell: UITableViewHeaderFooterView {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblStepsTitle: UILabel!
    @IBOutlet weak var viewSearchField: UIView!
    @IBOutlet weak var imgBlue: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtSearch.delegate = self
    }
    
    var searchHandler:((_ searchText : String) -> ())?
    var searchEndHandler:((_ searchText : String) -> ())?

    func setBorder(setborder : Bool) {
        if setborder {
            self.viewBorder.layer.cornerRadius = 2.0
            self.viewBorder.layer.borderWidth = 0.5
            self.viewBorder.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: "A7A7AA").cgColor
            self.viewSearchField.isHidden = true
            self.imgBlue.isHidden = false
        } else {
            self.viewBorder.layer.borderWidth = 0
            self.viewSearchField.isHidden = false
            self.imgBlue.isHidden = true
        }
    }
}

extension BillerStepHeaderCell : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        self.searchEndHandler?(textField.text ?? "")
        return false
    }
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText = ""
        if string != "" {
            searchText = textField.text! + string
        }else{
            let subText = textField.text?.dropLast()
            searchText = String(subText!)
        }
        
        self.searchHandler?(searchText)
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchEndHandler?(textField.text ?? "")

    }
}
