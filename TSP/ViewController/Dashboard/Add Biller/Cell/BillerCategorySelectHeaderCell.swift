//
//  BillerCategorySelectHeaderCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/11/21.
//

import UIKit

class BillerCategorySelectHeaderCell: UITableViewHeaderFooterView {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var selectedCategory: UILabel!
    @IBOutlet weak var lblSelectedTitle: UILabel!
    @IBOutlet weak var lblStep: UILabel!

    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!

    var closeCategory:((_ close : Bool) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnCloseCategoryAction(_ sender: Any) {
        closeCategory?(true)
    }
    
    func setupHeader(stepsText: String, selectedHeaderText: String, title : String, titleFontSize: Int) {
        lblStep.text = stepsText
        lblSelectedTitle.text = selectedHeaderText
        selectedCategory.text = title
        selectedCategory.font = Utilities.AppFont.black.size(CGFloat(titleFontSize))
    }

}
