//
//  BillerCategoryStep3Cell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 14/11/21.
//

import UIKit

class BillerCategoryStep3Cell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var tableView: UITableView!
    var aryOfBillerDetailList: [AddBillerCustomerParam] = []

    @IBOutlet weak var imgAddToMyBill: UIImageView!
    
    @IBOutlet weak var consAddToMyBillHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    var enteredText:((_ index : Int, _ value : String) -> ())?
    var isAddToMyBillSelected:((_ isSelected : Bool) -> ())?

    var isAddToMyBill : Bool = false
    var shorNameValue : String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnConfirm.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        tableView.register(BillerCategoryStep3ItemCell.nib, forCellReuseIdentifier: BillerCategoryStep3ItemCell.identifier)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAddToMyBillAction(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            imgAddToMyBill.image = UIImage(named: "ic_check")
            self.isAddToMyBill = true
        } else {
            sender.tag = 0
            imgAddToMyBill.image = UIImage(named: "ic_uncheck")
            self.isAddToMyBill = false
        }
        
        self.tableView.reloadRows(at: [IndexPath.init(row: self.aryOfBillerDetailList.count, section: 0)], with: .none)
    }
    
    
    
}

extension BillerCategoryStep3Cell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryOfBillerDetailList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillerCategoryStep3ItemCell.identifier, for: indexPath) as! BillerCategoryStep3ItemCell
        
        if indexPath.row == aryOfBillerDetailList.count {
            cell.objAddBiller = nil
            
            var placeholder = "Short Name"
                
            if isAddToMyBill {
                placeholder = placeholder + "*"
                
                let length = placeholder.count
                
                let str = NSMutableAttributedString(string: placeholder , attributes: [:])
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: (length - 1) ,length:1))
                // set label Attribute
                cell.txtBillerDetail.attributedPlaceholder = str
            } else {
                cell.txtBillerDetail.placeholder = placeholder
            }
        } else {
            cell.setUpData(objAddBiller: aryOfBillerDetailList[indexPath.row])
        }
        
        cell.enteredText = { (index, value) in
            if index == self.aryOfBillerDetailList.count {
                self.shorNameValue = value
                self.enteredText?(index, value)
            } else {
                self.enteredText?(index, value)
            }
        }
        
        cell.txtBillerDetail.tag = indexPath.row
        
        return cell
    }
}

