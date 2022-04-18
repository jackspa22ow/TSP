//
//  PopularHelpTopicsCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/11/21.
//

import UIKit

class PopularHelpTopicsCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var tblView: UITableView!
    var isHeightCalculated : Bool = false
    var helpTableHeight:((_ height : Float) -> ())?
    @IBOutlet weak var lblNoDataMessage: UILabel!
    var aryOfServiceQuestionList : [ServiceQuestionModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        tblView.register(PopularHelpTopicItemCell.nib, forCellReuseIdentifier: PopularHelpTopicItemCell.identifier)
        
        tblView.rowHeight = 100
        tblView.estimatedRowHeight = UITableView.automaticDimension

        tblView.delegate = self
        tblView.dataSource = self
        
        self.btnViewAll.isHidden = self.aryOfServiceQuestionList.count > 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showHideTable(){
        if self.aryOfServiceQuestionList.count > 0 {
            self.lblNoDataMessage.isHidden = true
            self.tblView.isHidden = false
        } else {
            self.lblNoDataMessage.isHidden = false
            self.tblView.isHidden = true
        }
    }
    
}

extension PopularHelpTopicsCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryOfServiceQuestionList.count > 4 ? 4 : aryOfServiceQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularHelpTopicItemCell.identifier, for: indexPath) as? PopularHelpTopicItemCell else {
            fatalError("XIB doesn't exist.")
        }
        let obj = aryOfServiceQuestionList[indexPath.row]
        cell.lblQuestionTitle.text = obj.question ?? ""
        cell.lblQuestionDescription.text = obj.answer ?? ""
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!isHeightCalculated) {
            isHeightCalculated = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.helpTableHeight?(Float(tableView.contentSize.height))
            }
        }
        return UITableView.automaticDimension
    }
}
