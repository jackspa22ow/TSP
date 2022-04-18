//
//  HelpVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 14/07/21.
//

import UIKit
import DXPopover
class HelpVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    let historyViewModel = HistoryViewModel()
    
    var selectedCategoryID = String()
    var selectedFromDate = String()
    var selectedStatus = String()
    var selectedToDate = String()
    var selectedTransactionRefId = String()
    var filePathURL:URL!
    @IBOutlet var popView: UIView!
    @IBOutlet weak var popViewBorder: UILabel!
    @IBOutlet weak var popViewIcon: UIView!
    @IBOutlet weak var popViewOpenbtn: UIButton!
    
    var heightForLastCell : Float = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.register(HelpRecentOrderCell.nib, forCellReuseIdentifier: HelpRecentOrderCell.identifier)
        tblView.register(HelpChoosServiceCell.nib, forCellReuseIdentifier: HelpChoosServiceCell.identifier)
        tblView.register(PopularHelpTopicsCell.nib, forCellReuseIdentifier: PopularHelpTopicsCell.identifier)
        
        let date = Date()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Utilities.sharedInstance.historyDateFormate

        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())

        self.selectedFromDate = dateFormatter.string(from: previousMonth ?? Date())

        self.selectedToDate = dateFormatter.string(from: date)
        
        
        fetchTransactions()
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
        
        self.tblView.contentInsetAdjustmentBehavior = .never
    }
    
    func fetchTransactions(){
        self.historyViewModel.getListOfTransactions(categoryId: self.selectedCategoryID, fromDate: self.selectedFromDate, status: self.selectedStatus, toDate: self.selectedToDate, transactionRefId: self.selectedTransactionRefId) { success in
//                if self.historyViewModel.aryOfTransactionsList.count > 0 {
//                    self.tblView.isHidden = false
                    self.fetchServiceGroup()
//                }else{
//                    self.tblView.dataSource = self
//                    self.tblView.delegate = self
//                    self.tblView.reloadData()
//                }
            
        }
    }
    
    func fetchServiceGroup(){
        self.historyViewModel.getServiceGroup { response in
            if (self.historyViewModel.aryOfServiceGroupList.count > 0) {
                self.fetchServiceQuestion(groupName: self.historyViewModel.aryOfServiceGroupList[0].groupName ?? "")
            } else {
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
            }
        }
    }
    
    func fetchServiceQuestion(groupName: String){
        self.historyViewModel.getServiceQuestion(groupName: groupName) { response in
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
        }
    }
    
    

    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonHandlerViewAll(_ sender: UIButton) {
        if sender.tag == 1{
            let nextVC = HELP_STORYBOARD.instantiateViewController(withIdentifier: "HelpDetailsVC")as! HelpDetailsVC
            nextVC.selectedIndex = 1
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if sender.tag == 2{
            let nextVC = HELP_STORYBOARD.instantiateViewController(withIdentifier: "HelpDetailsVC")as! HelpDetailsVC
            nextVC.selectedIndex = 2
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let nextVC = HELP_STORYBOARD.instantiateViewController(withIdentifier: "HelpDetailsVC")as! HelpDetailsVC
            nextVC.selectedIndex = 3
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func btnViewAllHandler(sender : UIButton) {
        guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }

        tabbarController.selectedIndex = 3

        self.navigationController?.popViewController(animated: false)
    }

    var selectedIndex = 0

    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("HelpTransactionsPopView", owner: self, options: nil)
        let appview: UIView? = apparray?.first as! UIView?
        appview?.autoresizingMask = []
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
                        print("View Transaction")
                        let obj = self.historyViewModel.aryOfTransactionsList[selectedIndex]
                        let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
                        nextVC.transactionID = obj.txnid ?? ""
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else{
                        print("Download")
                        let obj = self.historyViewModel.aryOfTransactionsList[selectedIndex]
                        if let str = obj.txnid{
                            self.downloadSingleHistory(transactionID: str)
                        }else{
                            Utilities.sharedInstance.showAlertView(title: "",message: "TransactionID is not available")
                        }
                    }
                }
            }
        })
    }
    @IBAction func buttonOpenPDF(_ sender: Any) {
        self.popView.removeFromSuperview()
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HistoryPDFViewerVC")as! HistoryPDFViewerVC
        nextVC.filePathURL = self.filePathURL
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func downloadSingleHistory(transactionID:String){
        self.historyViewModel.downloadSingleHistory(transactionID: transactionID) { success,filePathURL  in
            self.filePathURL = filePathURL
            self.popViewBorder.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
            self.popViewOpenbtn.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
            self.popViewOpenbtn.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
            
            Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
        }
    }
    
}

extension HelpVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1; //self.historyViewModel.aryOfTransactionsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.historyViewModel.aryOfTransactionsList.count > 3 {
                return (90 * 3) + 44
            } else {
                if self.historyViewModel.aryOfTransactionsList.count == 0 {
                    
                    return 44 + 44
                } else {
                    return CGFloat((90 * self.historyViewModel.aryOfTransactionsList.count) + 44)
                }
            }
        } else if indexPath.section == 1{
            return 222
        } else {
            return CGFloat(heightForLastCell)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpRecentOrderCell.identifier, for: indexPath) as? HelpRecentOrderCell else {
                fatalError("XIB doesn't exist.")
            }
            cell.aryOfTransactionsList = self.historyViewModel.aryOfTransactionsList
            cell.btnViewAll.addTarget(self, action: #selector(btnViewAllHandler), for: .touchUpInside)
            cell.btnMoreAction = { sender in
                self.btnMore(sender: sender)
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpChoosServiceCell.identifier, for: indexPath) as? HelpChoosServiceCell else {
                fatalError("XIB doesn't exist.")
            }
            cell.aryOfServiceGroupList = self.historyViewModel.aryOfServiceGroupList
            cell.selectedGroup = { groupName in
                self.fetchServiceQuestion(groupName: groupName)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularHelpTopicsCell.identifier, for: indexPath) as? PopularHelpTopicsCell else {
                fatalError("XIB doesn't exist.")
            }
            cell.aryOfServiceQuestionList = self.historyViewModel.aryOfServiceQuestionList
            if self.historyViewModel.aryOfServiceQuestionList.count > 0 {
                cell.tblView.reloadData()
            }
            cell.showHideTable()
            
            cell.helpTableHeight = { height in
                if height != (self.heightForLastCell + 44){
                    self.heightForLastCell = Float(height) + 44
                    self.tblView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                }
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20)
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
