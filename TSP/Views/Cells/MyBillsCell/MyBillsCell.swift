//
//  MyBillsCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 21/07/21.
//

import UIKit

class MyBillsCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var viewRadioContainer: UIView!
    @IBOutlet weak var viewRadio: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgDue: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var consDisplayRadioButton: NSLayoutConstraint!
    @IBOutlet weak var imgDot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
