//
//  SelectedBillContentCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class SelectedBillContentCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var tblView: UITableView!
    
    var customerParams: [MyBillsCustomerParam] = []
    var amountValue: String = ""
    var trasactionDate: String = ""
    var trasactionStatus: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        self.tblView.register(AddBillerDetailsTotalAmountCell.nib, forCellReuseIdentifier: AddBillerDetailsTotalAmountCell.identifier)
        self.tblView.register(MultipleBillTrancationDateCell.nib, forCellReuseIdentifier: MultipleBillTrancationDateCell.identifier)
    }

    func setupData() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



extension SelectedBillContentCell: UITableViewDelegate,UITableViewDataSource{
    
    func tableViewSetup(){
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        self.tblView.register(AddBillerDetailsTotalAmountCell.nib, forCellReuseIdentifier: AddBillerDetailsTotalAmountCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trasactionDate.count > 0 {
            return customerParams.count + 2
        }
        return customerParams.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if trasactionDate.count > 0 {
            if indexPath.row == customerParams.count + 1 {
                return 70
            }
        } else {
            if indexPath.row == customerParams.count {
                return 70
            }
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if trasactionDate.count > 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleBillTrancationDateCell.identifier, for: indexPath) as? MultipleBillTrancationDateCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                cell.setupDate(status: trasactionStatus, dateValue: trasactionDate)
                
                return cell
            } else if indexPath.row == customerParams.count + 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBillerDetailsTotalAmountCell.identifier, for: indexPath) as? AddBillerDetailsTotalAmountCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                cell.lblName.text = "Bill Amount"
                cell.lblValue.text = amountValue
                
                return cell
            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsCustomerParamCell.identifier, for: indexPath) as? MyBillDetailsCustomerParamCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                cell.lblName.text = customerParams[indexPath.row - 1].paramName
                cell.lblDescription.text = customerParams[indexPath.row - 1].value
                cell.separatorInset = UIEdgeInsets()
                return cell
            }
        } else {
                if indexPath.row == customerParams.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBillerDetailsTotalAmountCell.identifier, for: indexPath) as? AddBillerDetailsTotalAmountCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                cell.lblName.text = "Bill Amount"
                cell.lblValue.text = amountValue
                
                return cell
            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillDetailsCustomerParamCell.identifier, for: indexPath) as? MyBillDetailsCustomerParamCell else {
                    fatalError("XIB doesn't exist.")
                }
                
                cell.lblName.text = customerParams[indexPath.row].paramName
                cell.lblDescription.text = customerParams[indexPath.row].value
                cell.separatorInset = UIEdgeInsets()
                return cell
            }
        }
    }
    
}
