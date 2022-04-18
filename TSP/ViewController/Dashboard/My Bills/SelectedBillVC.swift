//
//  SelectedBillVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 22/07/21.
//

import UIKit

class SelectedBillSection {
    var title : String?
    var list : [String]?
    var isColleps : Bool?
    init() {
    }
    
    init(title : String? , list : [String]?, isColleps : Bool?) {
        self.title = title
        self.list = list
        self.isColleps = isColleps
    }
}

class SelectedBillVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var arrayOfIcons = ["Credit_card_Bill","loan repayment","insurance premium"]
    
    var data : [SlideMenuSection] = [SlideMenuSection(title: "Airtel Postpaid", list: ["Airtel Postpaid"], isColleps: false),SlideMenuSection(title: "my_home_bill\nMSEDCL CO LTD", list: ["my_home_bill\nMSEDCL CO LTD"], isColleps: false),SlideMenuSection(title: "TATA Power", list: ["TATA Power"], isColleps: false)]
        
    var aryOfSubTitle = ["9984328711","8435279521","432154789"]
    
    var aryOfPrice = ["₹ 1250","₹ 800","₹ 1200"]
    
    var aryOfDue = [true,true,true]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(SelectedBillHeaderCell.nib, forCellReuseIdentifier: SelectedBillHeaderCell.identifier)
        self.tblView.register(SelectedBillContentCell.nib, forCellReuseIdentifier: SelectedBillContentCell.identifier)
        self.tblView.register(SelectedBillFooterCell.nib, forCellReuseIdentifier: SelectedBillFooterCell.identifier)
        
        self.tblView.estimatedSectionHeaderHeight = 60

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Button action arrow in header
    @objc func buttonHandlerSectionArrowTap(sender : UIButton)  {
        let sectionData = data[sender.tag]
        sectionData.isColleps = !sectionData.isColleps!
        self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    

}


extension SelectedBillVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.data.count-1 == section{
            return 230
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : SelectedBillHeaderCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SelectedBillHeaderCell.self)) as! SelectedBillHeaderCell
        
        let sectionData = data[section]
        header.lblTitle.text = sectionData.title
        header.imgIcon.image = UIImage(named: self.arrayOfIcons[section])
      
        if sectionData.list != nil{
            ///arrow rotate
            header.imgArrow.isHidden = false
            header.buttonHandlerAction.transform = CGAffineTransform(rotationAngle: (sectionData.isColleps)! ? 0.0 : .pi)
            header.buttonHandlerAction.tag = section
            header.buttonHandlerAction.addTarget(self, action: #selector(buttonHandlerSectionArrowTap(sender:)), for: .touchUpInside)
            
            ///change cell color and arrow to updown
            if sectionData.isColleps == true{
                header.imgArrow.image = UIImage(named: "ic_up")
            }else{
                header.imgArrow.image = UIImage(named: "ic_down")
            }
            
        }else{
            header.imgArrow.isHidden = true
        }
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let header : SelectedBillFooterCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SelectedBillFooterCell.self)) as! SelectedBillFooterCell

        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data[section].isColleps ?? false ? (data[section].list?.count ?? 0) : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        288
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedBillContentCell.identifier, for: indexPath) as? SelectedBillContentCell else {
            fatalError("XIB doesn't exist.")
        }
        
        return cell
    }
    
}
