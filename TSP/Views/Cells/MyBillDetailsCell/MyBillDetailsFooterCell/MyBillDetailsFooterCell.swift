//
//  MyBillDetailsFooterCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 11/10/21.
//

import UIKit

class MyBillDetailsFooterCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var viewConfirm: UIView!
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
