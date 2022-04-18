//
//  MyBillDetailsReminderItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 24/11/21.
//

import UIKit

class MyBillDetailsReminderItemCell: UITableViewCell {

    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblReminderTitle: UILabel!
    @IBOutlet weak var txtNoOfDays: UITextField!
    @IBOutlet weak var imgCheckUncheck: UIImageView!
    @IBOutlet weak var btnCheckUncheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
