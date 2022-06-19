//
//  HomeBillCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 09/07/21.
//

import UIKit

class HomeBillCell: UICollectionViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var billerLogo: UIImageView!
    @IBOutlet weak var billerName: UILabel!
    @IBOutlet weak var lblItemTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var billerShortName: UILabel!
    @IBOutlet weak var lblItemSubTitleTopSpace: NSLayoutConstraint!
    @IBOutlet weak var lblDue: UILabel!
    @IBOutlet weak var billerPayuId: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var switchAutoPay: UISwitch!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var imgPayNow: UIImageView!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var viewEmptyCell: UIView!
    @IBOutlet weak var btnAutoPaySwitch: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPayNow.layer.cornerRadius = 4
        
        self.btnPayNow.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor).withAlphaComponent(0.1)

    }

}
