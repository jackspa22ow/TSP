//
//  HomeCategoryCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 26/07/21.
//

import UIKit

class HomeCategoryCell: UICollectionViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
