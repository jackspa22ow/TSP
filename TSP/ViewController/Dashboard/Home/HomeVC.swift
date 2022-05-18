//
//  HomeVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import DXPopover
import zlib
import Contacts

class HomeVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    
    let homeViewModel = HomeViewModel()
    let myBillsViewModel = MyBillsViewModel()
    
    var selectedIndex: Int = 0
    var currenrBillerPageIndex = 0
    var isBillerCellReload = false
    var isBillerCellPrevBtnClick = false

    @IBOutlet weak var consBtnAutoPayHeight: NSLayoutConstraint!
    @IBOutlet weak var consBtnSetReminderHeight: NSLayoutConstraint!

    var isViewWillDisappear = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide navigationBar
        self.navigationController?.isNavigationBarHidden = true
        
        //setup theme based app
        self.setupTheme()
        
        // Set delegate and data source, register cell xib etc.
        tableViewSetup()
        
        //call all apis that have to load in dashboard
        self.loadDashboard()
        
        //taken contact permission from user
        fetchContactPermision()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (dicOfUserProfile != nil) {
            self.lblUsername.text = "\(dicOfUserProfile.firstName ?? "") \(dicOfUserProfile.lastName ?? "")"
        }
        

        if IsMyBillDeleted {
            IsMyBillDeleted = false
            self.homeViewModel.getMyBills { success in
                self.currenrBillerPageIndex = 0
                self.tblView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            }
        }
        if isViewWillDisappear {
            self.isViewWillDisappear = false
            self.getListOfMyBills {
                self.tblView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewWillDisappear = true
    }
    
    func fetchContactPermision() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted{
                print("access succedd")
            }else{
                print("access denied")
            }
        }
    }
    
    func setupTheme(){
        self.btnHelp.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
        if TSP_Spend_Analysis == "Yes"{
            if let tabBarController = self.tabBarController{
                let indexToRemove = 4
                if indexToRemove < tabBarController.viewControllers!.count {
                    var viewControllers = tabBarController.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    tabBarController.viewControllers = viewControllers
                }
            }
        }
    }
    
    private func loadDashboard() {
        Utilities.sharedInstance.showSVProgressHUD()
        
        let disgroup = DispatchGroup()
        
        disgroup.enter()
        self.getUserProfile{
            disgroup.leave()
            
            self.lblUsername.text = "\(dicOfUserProfile.firstName!) \(dicOfUserProfile.lastName!)"
            self.lblHello.isHidden = false
        }
        
        disgroup.enter()
        self.getListOfGroups{
            disgroup.leave()
        }
        
        disgroup.enter()
        self.getListOfBanners {
            disgroup.leave()
        }
        
        disgroup.enter()
        self.getListOfMyBills {
            disgroup.leave()
        }
        
        disgroup.notify(queue: .main) {
            Utilities.sharedInstance.dismissSVProgressHUD()
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
        }
        
    }
    
    private func getUserProfile(complition:(() -> Void)?) {
        self.homeViewModel.getUserProfile { success in
            complition?()
        }
    }
    
    private func getListOfGroups(complition:(() -> Void)?) {
        self.homeViewModel.getListOfGroups { success in
            complition?()
        }
    }
    
    private func getListOfBanners(complition:(() -> Void)?) {
        self.homeViewModel.getBanners { success in
            complition?()
        }
    }
    
    private func getListOfMyBills(complition:(() -> Void)?) {
        self.homeViewModel.getMyBills { success in
            complition?()
        }
    }
    
    @IBAction func buttonHandlerOpenMenuBar(_ sender: UIButton) {
        let nextVC = SLIDEMENU_STORYBOARD.instantiateViewController(withIdentifier: "SlideMenuVC")as! SlideMenuVC
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @IBAction func buttonHandlerHelp(_ sender: UIButton) {
        let nextVC = HELP_STORYBOARD.instantiateViewController(withIdentifier: "HelpVC")as! HelpVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func buttonHandlerPushNotification(_ sender: Any) {
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "NotificationListVC")as! NotificationListVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    
    @objc func btnNextBillItemLoad(sender : UIButton) {
        let cell = tblView.cellForRow(at: IndexPath(row: 1, section: 0)) as! HomeBillItemsCell
        cell.scrollToNext()
        currenrBillerPageIndex = cell.index
        if (cell.index + 4) >= cell.aryOfMyBills.count {
            cell.imgNext.image = UIImage(named: "ic_lightnext")
        } else {
            cell.imgNext.image = UIImage(named: "ic_darknext")
        }
        
        if cell.index <= 0 {
            cell.imgBack.image = UIImage(named: "ic_lightback")
        } else {
            cell.imgBack.image = UIImage(named: "ic_darkback")
        }
        
        if (cell.index + 4) > cell.aryOfMyBills.count && !isBillerCellReload{
            isBillerCellReload = true
            self.tblView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    @objc func btnPreBillItemLoad(sender : UIButton) {
        let cell = tblView.cellForRow(at: IndexPath(row: 1, section: 0)) as! HomeBillItemsCell
        cell.scrollToPrev()
        currenrBillerPageIndex = cell.index
        if cell.index >= cell.aryOfMyBills.count {
            cell.imgNext.image = UIImage(named: "ic_lightnext")
        } else {
            cell.imgNext.image = UIImage(named: "ic_darknext")
        }
        
        if cell.index <= 0 {
            cell.imgBack.image = UIImage(named: "ic_lightback")
        } else {
            cell.imgBack.image = UIImage(named: "ic_darkback")
        }
        if isBillerCellReload {
            isBillerCellReload = false
            isBillerCellPrevBtnClick = true
            self.tblView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    @objc func btnViewAll(sender: UIButton){
        let index = sender.tag
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "ViewAllCategoryVC")as! ViewAllCategoryVC
        
        let obj = homeViewModel.dicOfGroups[index]
        nextVC.categoryList = obj.displayCategories
        nextVC.categoryName = obj.groupName ?? ""
        nextVC.selectedCategory = { category in
            self.tabBarController?.selectedIndex = 2
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("HomeVCPopView", owner: self, options: nil)
        let appview: UIView? = apparray?.first as! UIView?
        if TSP_Allow_Setting_Autopay != "" && TSP_Allow_Setting_Autopay != Constant.User {
            self.consBtnAutoPayHeight.constant = 0
            appview?.frame = CGRect(x: appview?.frame.origin.x ?? 0, y: appview?.frame.origin.y ?? 0, width: appview?.frame.size.width ?? 0, height: (appview?.frame.size.height ?? 0) - 30)
        }
        if TSP_Allow_Setting_Reminders != "" && TSP_Allow_Setting_Reminders != Constant.User {
            self.consBtnSetReminderHeight.constant = 0
            appview?.frame = CGRect(x: appview?.frame.origin.x ?? 0, y: appview?.frame.origin.y ?? 0, width: appview?.frame.size.width ?? 0, height: (appview?.frame.size.height ?? 0) - 30)
        }
        appview?.autoresizingMask = []
        appview?.backgroundColor = UIColor.clear
        let popover = DXPopover()
        popover.frame = CGRect.zero
        let centerPoints = CGPoint.init(x: sender.bounds.midX, y: sender.bounds.midY)
        let point = sender.convert(centerPoints, to: self.view)
       
        popover.show(at: point, popoverPostion: .down, withContentView: appview, in: self.view)
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
                        let json = self.homeViewModel.dicOfMyBillList.content[selectedIndex]
                        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
                        nextVC.billID = "\(json.id ?? 0)"
                        nextVC.isAutoPayHide = true
                        nextVC.isAutoPayEdit = false
                        nextVC.isReminderHide = true
                        nextVC.isShortNameEdit = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else if index == 2{
                        print("Delete")
                        let json = self.homeViewModel.dicOfMyBillList.content[selectedIndex]
                        self.showAlertBeforeDeleteBill(billID: "\(json.id!)")
                    }else if index == 3 {
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
                        nextVC.isAutoPayFromHomeMore = true

                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        })
    }

}


extension HomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableViewSetup(){
        self.tblView.register(HomeSliderCell.nib, forCellReuseIdentifier: HomeSliderCell.identifier)
        
        //home bill item xib
        self.tblView.register(HomeBillItemsCell.nib, forCellReuseIdentifier: HomeBillItemsCell.identifier)
        
        //home bill cell xib
        self.tblView.register(HomeBillCell.nib, forCellReuseIdentifier: HomeBillCell.identifier)
        
        //home category item xib
        self.tblView.register(HomeCategoryItemCell.nib, forCellReuseIdentifier: HomeCategoryItemCell.identifier)
        
        //home category cell xib
        self.tblView.register(HomeCategoryCell.nib, forCellReuseIdentifier: HomeCategoryCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = homeViewModel.dicOfGroups.count
        return count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return self.homeViewModel.aryOfBannerList.count > 0 ? 150 : 0
        }else if indexPath.row == 1{
            if homeViewModel.dicOfMyBillList != nil{
                let billCount = homeViewModel.dicOfMyBillList.content.count
                if billCount > 0{
                    if billCount > 2{
                        if (billCount - currenrBillerPageIndex) > 2{
                            return 510
                        }else{
                            return 280
                        }
                    }else{
                        return 280
                    }
                }else{
                    return 100
                }
            }else{
                return 100
            }
        }else{
            let groupObj = homeViewModel.dicOfGroups[indexPath.row-2]
            let groupCount = groupObj.displayCategories?.count ?? 0
            if groupCount > 0{
                return 135
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSliderCell.identifier, for: indexPath) as? HomeSliderCell else {
                fatalError("XIB doesn't exist.")
            }
            
            if homeViewModel.aryOfBannerList.count > 0{
                cell.imageArray = homeViewModel.aryOfBannerList
            }
            
            return cell
        }else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeBillItemsCell.identifier, for: indexPath) as? HomeBillItemsCell else {
                fatalError("XIB doesn't exist.")
            }
            
            cell.btnNext.addTarget(self, action: #selector(self.btnNextBillItemLoad), for: .touchUpInside)
            cell.btnBack.addTarget(self, action: #selector(self.btnPreBillItemLoad), for: .touchUpInside)
            cell.delegate = self
            cell.index = currenrBillerPageIndex
            cell.aryOfMyBills = homeViewModel.dicOfMyBillList.content
            print("Delete")
            cell.collectionView.reloadData()
            cell.selectedMoreIndex = { index in
                self.selectedIndex = index
            }
            
            if cell.index <= 0 {
                cell.imgBack.image = UIImage(named: "ic_lightback")
            } else {
                cell.imgBack.image = UIImage(named: "ic_darkback")
            }
            
            if (cell.index + 4) >= cell.aryOfMyBills.count {
                cell.imgNext.image = UIImage(named: "ic_lightnext")
            } else {
                cell.imgNext.image = UIImage(named: "ic_darknext")
            }
            if isBillerCellPrevBtnClick {
                isBillerCellPrevBtnClick = false
                cell.collectionView.scrollToItem(at: IndexPath(row: currenrBillerPageIndex, section: 0), at: .top, animated: true)
            }
            
            cell.btnMoreAction = { sender in
                self.btnMore(sender: sender)
            }
            
            if cell.index > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.5))) {
                    cell.collectionView.scrollToItem(at: IndexPath(row: cell.index, section: 0), at: .top, animated: false)
                    
                }
            }
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCategoryItemCell.identifier, for: indexPath) as? HomeCategoryItemCell else {
                fatalError("XIB doesn't exist.")
            }
            
            let listObj = homeViewModel.dicOfGroups[indexPath.row - 2]
            cell.objGroupList = listObj
            
            cell.btnViewAll.tag = indexPath.row - 2
            cell.btnViewAll.addTarget(self, action: #selector(btnViewAll(sender:)), for: .touchUpInside)
            
            cell.selectedCategory = { category in
                self.tabBarController?.selectedIndex = 2
            }
            
            if listObj.displayCategories?.count ?? 0 > 6{
                cell.btnViewAll.isHidden = false
            }else{
                cell.btnViewAll.isHidden = true
            }
            
            return cell
        }
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
            //            self.popViewLeftHeader.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            //            self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
            //            Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
            
            self.homeViewModel.getMyBills { success in
                self.tblView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
//                if self.homeViewModel.dicOfMyBillList.content.count > 0{
//                    self.tblView.reloadData()
//                }
            }
        }
    }
    
}

extension HomeVC : HomeBillItemsCellDelegate{
    func selectBillDetail(index:Int){
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC")as! HomeDetailsVC
        nextVC.billID = "\(self.homeViewModel.dicOfMyBillList.content[index].id ?? 0)"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func switchAutoPAuAction(index:Int){
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HomeDetailsVC") as! HomeDetailsVC
        nextVC.billID = "\(self.homeViewModel.dicOfMyBillList.content[index].id ?? 0)"
        nextVC.isAutoPayEdit = true
        nextVC.isAutoPayFromHomeMore = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

