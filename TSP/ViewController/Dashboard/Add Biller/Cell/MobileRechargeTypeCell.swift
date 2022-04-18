//
//  MobileRechargeTypeCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 15/11/21.
//

import UIKit

class MobileRechargeTypeCell: UICollectionViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}
