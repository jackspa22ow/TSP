//
//  PopularHelpTopicItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/11/21.
//

import UIKit

class PopularHelpTopicItemCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblQuestionTitle: UILabel!
    @IBOutlet weak var lblQuestionDescription: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
