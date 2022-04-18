//
//  MyBillsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import DXPopover

class MyBillsVC: UIViewController{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var popViewLeftHeader: UILabel!
    @IBOutlet weak var popViewIcon: UIView!
    
    let homeViewModel = HomeViewModel()
    let myBillsViewModel = MyBillsViewModel()
           
    @IBOutlet weak var consBtnAutoPayHeight: NSLayoutConstraint!
    @IBOutlet weak var consBtnSetReminderHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        Utilities.sharedInstance.showSVProgressHUD()
        
        self.tblView.register(MyBillsCell.nib, forCellReuseIdentifier: MyBillsCell.identifier)
        self.tblView.estimatedRowHeight = 70
        
        self.homeViewModel.getMyBills { success in
            Utilities.sharedInstance.dismissSVProgressHUD()
            if self.homeViewModel.dicOfMyBillList.content.count > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoDataFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoDataFound.isHidden = false
            }
        }

        // Do any additional setup after loading the view.
    }
    
    var selectedIndex = 0
    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("MyBillsVCPopView", owner: self, options: nil)
        let appview: UIView? = apparray?.first as! UIView?
        if TSP_Allow_Setting_Autopay != Constant.User {
            self.consBtnAutoPayHeight.constant = 0
            appview?.frame = CGRect(x: appview?.frame.origin.x ?? 0, y: appview?.frame.origin.y ?? 0, width: appview?.frame.size.width ?? 0, height: (appview?.frame.size.height ?? 0) - 30)
        }
        if TSP_Allow_Setting_Reminders != Constant.User {
            self.consBtnSetReminderHeight.constant = 0
            appview?.frame = CGRect(x: appview?.frame.origin.x ?? 0, y: appview?.frame.origin.y ?? 0, width: appview?.frame.size.width ?? 0, height: (appview?.frame.size.height ?? 0) - 30)
        }
        appview?.autoresizingMask = []
        let popover = DXPopover()
        popover.frame = CGRect.zero
        let centerPoints = CGPoint.init(x: sender.bounds.midX, y: sender.bounds.midY)
        let point = sender.convert(centerPoints, to: self.view)
        popover.show(at: point, popoverPostion: .down, withContentView: appview, in: self.view)
    } //avo code kya che homeVC ma?
    
    @IBAction func buttonClosePopView(_ sender: Any) {
        self.popView.removeFromSuperview()
    }
    
    
    @IBAction func buttonPopUpActions(_ sender: UIButton) {
        let index = sender.tag
        self.view.subviews.forEach({
            view in
            if view.isMember(of: DXPopover.self){
                if let popOver = view as? DXPopover{
                    popOver.dismiss()
                    if index == 1{
                        print("Edit")
                    }else if index == 2{
                        print("Delete")
                        let json = self.homeViewModel.dicOfMyBillList.content[selectedIndex]
                        self.showAlertBeforeDeleteBill(billID: "\(json.id!)")
                    }else if index == 3{
                        print("Set Reminders")
                        let json = self.homeViewModel.dicOfMyBillList.content[selectedIndex]
                        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
                        nextVC.billID = "\(json.id ?? 0)"
                        nextVC.isAutoPayHide = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else{
                        print("Enable Autoplay")
                        let json = self.homeViewModel.dicOfMyBillList.content[selectedIndex]
                        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
                        nextVC.billID = "\(json.id ?? 0)"
                        nextVC.isAutoPayEdit = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        })
    }
    
    func showAlertBeforeDeleteBill(billID:String){
        let alert = UIAlertController(title: "",
                                      message: "Are you sure you want to delete this bill?",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.deleteBill(billID: billID)
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in}
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    func deleteBill(billID:String){
        self.myBillsViewModel.deleteBill(billID: billID) { success in
            self.popViewLeftHeader.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
            Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
            IsMyBillDeleted = true
            self.homeViewModel.getMyBills { success in
                if self.homeViewModel.dicOfMyBillList.content.count > 0{
                    self.tblView.isHidden = false
                    self.tblView.dataSource = self
                    self.tblView.delegate = self
                    self.tblView.reloadData()
                    self.lblNoDataFound.isHidden = true
                }else{
                    self.tblView.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }
            }
        }
    }
    
                                                                                
}


extension MyBillsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.dicOfMyBillList.content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillsCell.identifier, for: indexPath) as? MyBillsCell else {
            fatalError("XIB doesn't exist.")
        }
        
        cell.consDisplayRadioButton.priority = UILayoutPriority(250)
        cell.viewRadioContainer.isHidden = true
        let json = self.homeViewModel.dicOfMyBillList.content[indexPath.row]
        
//        let fileUrl = URL(string: json.customerParams)
//        cell.imgIcon.sd_setImage(with: fileUrl)
        cell.lblNickName.text = json.billNickName
        cell.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
        
        cell.lblTitle.text = json.billerName
        
        for obj in json.customerParams{
            let val = obj.primary
            if val == true{
                cell.lblSubTitle.text = obj.value
                break
            }
        }
        
        cell.lblPrice.text = "₹ \(json.amount!)"
        
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)
        
        cell.imgDue.isHidden = (json.billDue == true || json.billDue == nil) ? false : true
        
        return cell
    }
    
   
}
        
