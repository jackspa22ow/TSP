//
//  SelectedBillHeaderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class SelectedBillHeaderCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgDue: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var buttonHandlerAction: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
