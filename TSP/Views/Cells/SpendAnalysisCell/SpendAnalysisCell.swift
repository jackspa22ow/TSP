//
//  SpendAnalysisCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 03/09/21.
//

import UIKit

class SpendAnalysisCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewLeftBorder: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgView.layer.cornerRadius = 2
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.masksToBounds = false
        self.bgView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.bgView.layer.shadowColor = UIColor.darkGray.cgColor
        self.bgView.layer.shadowOpacity = 0.30
        self.bgView.layer.shadowRadius = 3
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
