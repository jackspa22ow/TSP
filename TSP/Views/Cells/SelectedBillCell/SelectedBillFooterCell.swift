//
//  SelectedBillFooterCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class SelectedBillFooterCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var lblTotalBillAcount: UILabel!
    @IBOutlet weak var lblTotalBillAmount: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblFooter: UILabel!
    @IBOutlet weak var viewPay: UIView!
    @IBOutlet weak var viewCancel: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
