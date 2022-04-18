//
//  HomeDetailsItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 16/07/21.
//

import UIKit

class HomeDetailsItemCell: UICollectionViewCell {
    class var identifier : String { return String(describing: self) }

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgVwBg: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        imgVwBg.layer.cornerRadius = 2
        imgVwBg.layer.borderWidth = 0.5
        imgVwBg.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: "A7A7AA").cgColor
    }
}
