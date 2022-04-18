//
//  AddBillerDetailHeaderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 17/11/21.
//

import UIKit

class AddBillerDetailHeaderCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
