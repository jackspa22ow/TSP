//
//  BillerCategoryStep2Cell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/11/21.
//

import UIKit

class BillerCategoryStep2Cell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var tableView: UITableView!
    
    var aryOfBillerList : [AddBillerModelContent] = []

    var selectedBiller:((_ index : Int) -> ())?

    var contacts = [FetchedContact]()
    var isMobilePrepaidSeleted : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        tableView.register(BillerCategoryStep2ItemCell.nib, forCellReuseIdentifier: BillerCategoryStep2ItemCell.identifier)
        tableView.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.identifier)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BillerCategoryStep2Cell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isMobilePrepaidSeleted) {
            return contacts.count
        } else {
            return aryOfBillerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isMobilePrepaidSeleted) {
            return 55
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (isMobilePrepaidSeleted) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
            cell.lblContactName.text = "\(contacts[indexPath.row].firstName) \(contacts[indexPath.row].lastName)"
            cell.lblContactNumber.text = contacts[indexPath.row].telephone
            
            if contacts[indexPath.row].firstName.count > 0 {
                if contacts[indexPath.row].lastName.count > 0 {
                    cell.lblShorName.text = "\(contacts[indexPath.row].firstName.prefix(1))\(contacts[indexPath.row].lastName.prefix(1))"

                } else {
                    cell.lblShorName.text = "\(contacts[indexPath.row].firstName.prefix(1))"
                }
            } else {
                cell.lblShorName.text = ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BillerCategoryStep2ItemCell.identifier, for: indexPath) as! BillerCategoryStep2ItemCell
            
            let obj = aryOfBillerList[indexPath.item]
            
            if let str = obj.billerName{
                cell.lblBillerName.text = str
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBiller?(indexPath.row)
    }
}
