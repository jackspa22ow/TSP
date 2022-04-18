//
//  MobileRechargePlanCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 16/11/21.
//

import UIKit

class MobileRechargePlanCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanDescription: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
