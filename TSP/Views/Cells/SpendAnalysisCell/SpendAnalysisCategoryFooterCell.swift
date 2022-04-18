//
//  SpendAnalysisCategoryFooterCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/09/21.
//

import UIKit

class SpendAnalysisCategoryFooterCell: UITableViewCell {
    
    @IBOutlet weak var lblBillCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
