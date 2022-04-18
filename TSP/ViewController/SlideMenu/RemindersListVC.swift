//
//  RemindersListVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 30/09/21.
//

import UIKit
import DXPopover

class RemindersListVC: UIViewController {

    @IBOutlet weak var lblNoReminderFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var lblPopViewMessage: UILabel!
    @IBOutlet weak var popViewLeftHeader: UILabel!
    @IBOutlet weak var popViewIcon: UIView!
    let homeViewModel = HomeViewModel()

    let reminderListViewModel = ReminderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(MyBillsCell.nib, forCellReuseIdentifier: MyBillsCell.identifier)
        self.tblView.estimatedRowHeight = 70
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRemiders()
    }
    
    func getRemiders(){
        self.reminderListViewModel.getReminderList { success in
            Utilities.sharedInstance.dismissSVProgressHUD()
            if self.reminderListViewModel.dicOfReminderList.payload.count > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoReminderFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoReminderFound.isHidden = false
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonClosePopView(_ sender: Any) {
        self.popView.removeFromSuperview()
        self.lblPopViewMessage.text = "Reminder successfully deleted"
    }
    
    @IBAction func buttonPopUpActions(_ sender: UIButton) {
        let index = sender.tag
        self.view.subviews.forEach({
            view in
            if view.isMember(of: DXPopover.self){
                if let popOver =  view as? DXPopover{
                    popOver.dismiss()
                    if index == 1{
                        print("Edit")
                        self.homeViewModel.getMyBills { success in
                            
                            for var obj in self.homeViewModel.dicOfMyBillList.content {
                                if let billId = obj.id {
                                    let json = self.reminderListViewModel.dicOfReminderList.payload[self.selectedIndex]

                                    if billId == json.billId {
                                        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
                                        nextVC.isReminderEdit = true
                                        obj.enableReminder = json.isEnable
                                        nextVC.billID = "\(json.billId ?? 0)"
                                        nextVC.reminderObj = json
                                        nextVC.isReminderEditMode = obj.enableReminder ?? false
                                        
                                        nextVC.isReminderUpdated = { value in
                                            self.lblPopViewMessage.text = "Reminder set"
                                            self.popViewLeftHeader.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                                            self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
                                            Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
                                        }
                                        self.navigationController?.pushViewController(nextVC, animated: true)
                                        break
                                    }
                                }
                            }
                        }
                        
                    }else{
                        print("Delete")
                        let json = self.reminderListViewModel.dicOfReminderList.payload[selectedIndex]
                        self.showAlertBeforeDeleteBill(reminderID: "\(json.id!)")
                    }
                }
            }
        })
    }
    
    func showAlertBeforeDeleteBill(reminderID:String){
        let alert = UIAlertController(title: "",
                                      message: "Are you sure you want to delete this reminder?",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.deleteBill(reminderID: reminderID)
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in}
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    func deleteBill(reminderID:String){
        self.reminderListViewModel.deleteReminder(reminderID: reminderID) { success in
            self.popViewLeftHeader.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
            Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
            self.getRemiders()
        }
    }
    
    var selectedIndex = 0
    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("ReminderPopView", owner: self, options: nil)
        let appview: UIView? = apparray?.first as! UIView?
        appview?.autoresizingMask = []
        let popover = DXPopover()
        popover.frame = CGRect.zero
        let centerPoints = CGPoint.init(x: sender.bounds.midX, y: sender.bounds.midY)
        let point = sender.convert(centerPoints, to: self.view)
        popover.show(at: point, popoverPostion: .down, withContentView: appview, in: self.view)
    }

}


extension RemindersListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminderListViewModel.dicOfReminderList.payload.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBillsCell.identifier, for: indexPath) as? MyBillsCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let json = self.reminderListViewModel.dicOfReminderList.payload[indexPath.row]
        
        cell.imgIcon.image = #imageLiteral(resourceName: "ic_bharatbillpay")
        
        cell.lblTitle.text = json.billerName
        //cell.lblSubTitle.text = json.billerShortName
        cell.lblPrice.text = "₹ \(json.billAmount!)"
        
        cell.btnMore.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)
        
        cell.imgDue.isHidden = json.billDue == true ? false : true
        
        return cell
    }
    
   
}
