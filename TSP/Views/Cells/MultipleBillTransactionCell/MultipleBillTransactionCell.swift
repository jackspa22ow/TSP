//
//  MultipleBillTransactionCell.swift
//  TSP
//
//  Created by Yagnesh Dobariya on 19/04/22.
//

import UIKit

class MultipleBillTransactionCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var btnExpandCollaps: UIButton!
    @IBOutlet weak var ingArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
