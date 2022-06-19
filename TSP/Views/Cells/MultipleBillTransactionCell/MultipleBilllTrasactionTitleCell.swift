//
//  MultipleBilllTrasactionTitleCell.swift
//  TSP
//
//  Created by Yagnesh Dobariya on 19/04/22.
//

import UIKit

class MultipleBilllTrasactionTitleCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    @IBOutlet weak var lblTransactionMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblTransactionMsg.font = Utilities.AppFont.black.size(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
