//
//  HistoryCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 31/08/21.
//

import UIKit

class TransactionsCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDots: UIButton!
    @IBOutlet weak var lblFailed: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        self.lblNickName.font = Utilities.AppFont.black.size(13)
        self.lblTitle.font = Utilities.AppFont.black.size(13)
        self.lblNickName.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        self.lblTitle.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
