//
//  MyBillDetailShortNameCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 16/05/22.
//

import UIKit

class MyBillDetailShortNameCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var vwTxtContainer: TSPView!
    @IBOutlet weak var txtShortNAme: TSPTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
