//
//  MobileOperatorOrCircleVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 16/11/21.
//

import UIKit

class MobileOperatorOrCircleVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblOperatorOrCircleHeaderTitle: UILabel!
    @IBOutlet weak var consTblVwHeight: NSLayoutConstraint!
    
    var selectedItem:((_ index : Int, _ value : String, _ isOperator: Bool) -> ())?

    var headertText = ""
    var arrayObject : Int = 0
    
    var addBillerViewModel = AddBillerViewModel()
    var contentOperator: [GetAllOperatorsContent] = []
    var contentCircle: [GetAllCirclesContent] = []
    var isOperator : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.register(MobileOperatorOrCircleCell.nib, forCellReuseIdentifier: MobileOperatorOrCircleCell.identifier)
        tblView.delegate = self
        tblView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblOperatorOrCircleHeaderTitle.text = headertText
        
        if isOperator {
            if contentOperator.count > 10 {
                self.consTblVwHeight.constant = CGFloat(440)
                self.tblView.isScrollEnabled = true
            } else {
                self.consTblVwHeight.constant = CGFloat(contentOperator.count * 44)
                self.tblView.isScrollEnabled = false
            }
        } else {
            if contentCircle.count > 10 {
                self.consTblVwHeight.constant = CGFloat(440)
                self.tblView.isScrollEnabled = true
            } else {
                self.consTblVwHeight.constant = CGFloat(contentCircle.count * 44)
                self.tblView.isScrollEnabled = false
            }
        }
    }
    
    @IBAction func btnOperatorOrCircleSelectionViewAction(_ sender: Any) {
        self.dismiss(animated: true) {

        }
    }
}

extension MobileOperatorOrCircleVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOperator {
            return contentOperator.count
        } else {
            return contentCircle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MobileOperatorOrCircleCell.identifier, for: indexPath) as! MobileOperatorOrCircleCell
        
        if isOperator {
            cell.setupUI(isOperator: true)
            cell.lblItem.text = self.contentOperator[indexPath.row].operatorName
        } else {
            cell.lblItem.text = self.contentCircle[indexPath.row].circleName
            cell.setupUI(isOperator: false)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            if self.headertText.contains("Operator") {
                self.selectedItem?(indexPath.row, "Text", true)
            } else {
                self.selectedItem?(indexPath.row, "Text", false)
            }
        }
    }
}
