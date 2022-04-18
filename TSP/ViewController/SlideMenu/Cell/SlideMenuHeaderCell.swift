//
//  SlideMenuHeaderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 07/07/21.
//

import UIKit

class SlideMenuHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageDropDown: UIImageView!
    @IBOutlet weak var buttonHandlerAction: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
