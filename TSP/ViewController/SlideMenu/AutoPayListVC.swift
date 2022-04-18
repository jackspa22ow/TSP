//
//  AutoPayListVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 30/09/21.
//

import UIKit
import DXPopover

class AutoPayListVC: UIViewController {

    @IBOutlet weak var lblNoAutoPayFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    let autoPayListViewModel = AutopayListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MyBillsCell.nib, forCellReuseIdentifier: MyBillsCell.identifier)
        self.tblView.estimatedRowHeight = 70
        
        self.getAutoPay()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAutoPay(){
        self.autoPayListViewModel.getAutoPayList { success in
            Utilities.sharedInstance.dismissSVProgressHUD()
            if self.autoPayListViewModel.aryOfAutoPayList.count > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoAutoPayFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoAutoPayFound.isHidden = false
            }
        }
    }
    
    @IBAction func buttonPopUpActions(_ sender: UIButton) {
        self.view.subviews.forEach({
            view in
            if view.isMember(of: DXPopover.self){
                if let popOver =  view as? DXPopover{
                    popOver.dismiss()
                    print("Edit")
                    
                    let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
                    nextVC.isAutoPayEdit = true
                    nextVC.billID = "\(self.autoPayListViewModel.aryOfAutoPayList[sender.tag].billId ?? 0)"
                    nextVC.autoPayID = "\(self.autoPayListViewModel.aryOfAutoPayList[sender.tag].id ?? 0)"

                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        })
    }
    
    var selectedIndex = 0
    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("AutoPayPopView", owner: self, options: nil)
        let appview: UIView? = apparray?.first as! UIView?
        appview?.autoresizingMask = []
        let popover = DXPopover()
        popover.frame = CGRect.zero
        let centerPoints = CGPoint.init(x: sender.bounds.midX, y: sender.bounds.midY)
        let point = sender.convert(centerPoints, to: self.view)
        popover.show(at: point, popoverPostion: .down, withContentView: appview, in: self.view)
    }
    
    
}



extension AutoPayListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autoPayListViewModel.aryOfAutoPayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillsCell.identifier, for: indexPath) as? MyBillsCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let json = self.autoPayListViewModel.aryOfAutoPayList[indexPath.row]
        
        cell.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
        
        cell.lblNickName.text = json.billNickName
        cell.lblTitle.text = json.billerName
        cell.lblSubTitle.text = json.preferredPaymentMode
        cell.lblPrice.text = "₹ \(json.billAmount!)"
        
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)
        
        cell.imgDue.isHidden = json.billDue == true ? false : true
        
        return cell
    }
    
   
}
