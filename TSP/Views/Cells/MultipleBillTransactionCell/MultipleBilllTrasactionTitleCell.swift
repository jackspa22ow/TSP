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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
