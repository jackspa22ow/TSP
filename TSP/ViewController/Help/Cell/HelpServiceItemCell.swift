//
//  HelpServiceItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/11/21.
//

import UIKit

class HelpServiceItemCell: UICollectionViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
