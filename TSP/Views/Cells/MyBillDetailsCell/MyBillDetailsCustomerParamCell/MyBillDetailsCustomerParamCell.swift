//
//  MyBillDetailsCustomerParamCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 11/10/21.
//

import UIKit

class MyBillDetailsCustomerParamCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
