//
//  MobileOperatorOrCircleCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 16/11/21.
//

import UIKit

class MobileOperatorOrCircleCell: UITableViewCell {
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var imgItemIcon: UIImageView!
    @IBOutlet weak var lblItem: UILabel!
    
    @IBOutlet weak var consLbltemLeadingForCircle: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgItemIcon.layer.cornerRadius = imgItemIcon.frame.size.width / 2
    }
    
    func setupUI(isOperator : Bool) {
        if isOperator {
            consLbltemLeadingForCircle.priority = UILayoutPriority(250)
            imgItemIcon.isHidden = false
        } else {
            consLbltemLeadingForCircle.priority = UILayoutPriority(999)
            imgItemIcon.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
