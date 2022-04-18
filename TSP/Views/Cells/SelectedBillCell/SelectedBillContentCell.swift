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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tblView.register(MyBillDetailsCustomerParamCell.nib, forCellReuseIdentifier: MyBillDetailsCustomerParamCell.identifier)
        self.tblView.register(AddBillerDetailsTotalAmountCell.nib, forCellReuseIdentifier: AddBillerDetailsTotalAmountCell.identifier)
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
        return customerParams.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == customerParams.count {
            return 70
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
