//
//  SpendAnalysisCategoryCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/09/21.
//

import UIKit

class SpendAnalysisCategoryCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblBillerNickName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblBillerNickName.font = Utilities.AppFont.black.size(13)
        self.lblTitle.font = Utilities.AppFont.black.size(13)
        self.lblBillerNickName.textColor = .black
        self.lblTitle.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
