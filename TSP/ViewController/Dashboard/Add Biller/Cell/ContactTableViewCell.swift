//
//  ContactTableViewCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 15/11/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblShorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblShorName.layer.cornerRadius = lblShorName.frame.size.width / 2
        lblShorName.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
