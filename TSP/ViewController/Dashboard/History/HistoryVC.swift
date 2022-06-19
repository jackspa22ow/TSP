//
//  HistoryVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import PDFKit
import DXPopover
import iOSDropDown

class HistoryVC: UIViewController {
    
    @IBOutlet weak var btnTransaction: UIButton!
    @IBOutlet weak var btnComplaints: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var lblComplaints: UILabel!
    
    @IBOutlet weak var transactionsBottomView: UILabel!
    @IBOutlet weak var complaintsBottomView: UILabel!
    
    @IBOutlet weak var viewTransactions: UIView!
    @IBOutlet weak var viewComplaints: UIView!
    
    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var viewTopHeaderTopSpace: NSLayoutConstraint!
    @IBOutlet weak var viewTopHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtSelectMonth: DropDown!
    @IBOutlet weak var txtSelectStatus: DropDown!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var popViewBorder: UILabel!
    @IBOutlet weak var popViewIcon: UIView!
    @IBOutlet weak var popViewOpenbtn: UIButton!
    @IBOutlet weak var btnHelp: UIButton!

    var selectedCategoryID = String()
    var selectedFromDate = String()
    var selectedStatus = String()
    var selectedToDate = String()
    var selectedTransactionRefId = String()
    var filePathURL:URL!
        
    let historyViewModel = HistoryViewModel()

    var isTransaction = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(TransactionsCell.nib, forCellReuseIdentifier: TransactionsCell.identifier)
        self.tblView.register(ComplaintsCell.nib, forCellReuseIdentifier: ComplaintsCell.identifier)
        
        self.transactionsBottomView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        self.btnHelp.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)

        self.setupMonth()
        self.setupStatus()
        
        self.fetchTransactions()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if IsComplaintsMenuSelected {
            IsComplaintsMenuSelected = false
            self.buttonTransactionsAndComplaints(self.btnComplaints)
        }
    }
    
    @IBAction func buttonOpenPDF(_ sender: Any) {
        self.popView.removeFromSuperview()
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "HistoryPDFViewerVC")as! HistoryPDFViewerVC
        nextVC.filePathURL = self.filePathURL
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonTransactionsAndComplaints(_ sender: UIButton) {
        if sender.tag == 1{
            self.isTransaction = true
            self.tblView.isHidden = true
            self.lblTransactions.font = Utilities.AppFont.black.size(13)
            self.lblComplaints.font = Utilities.AppFont.book.size(13)
            self.transactionsBottomView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.complaintsBottomView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "C7C7CC")
            self.viewTransactions.backgroundColor = UIColor.white
            self.viewComplaints.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EDF1F8")
            
            self.viewTopHeader.isHidden = false
            self.viewTopHeaderTopSpace.constant = 16
            self.viewTopHeaderHeight.constant = 50
            self.fetchTransactions()
        }else{
            self.isTransaction = false
            self.tblView.isHidden = true
            self.lblTransactions.font = Utilities.AppFont.book.size(13)
            self.lblComplaints.font = Utilities.AppFont.black.size(13)
            self.transactionsBottomView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "C7C7CC")
            self.complaintsBottomView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            self.viewTransactions.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: "EDF1F8")
            self.viewComplaints.backgroundColor = UIColor.white
            
            self.viewTopHeader.isHidden = true
            self.viewTopHeaderTopSpace.constant = 0
            self.viewTopHeaderHeight.constant = 0
            self.fetchComplaints()
        }
    }
    
    @IBAction func buttonDownloadHistory(_ sender: Any) {
        if self.historyViewModel.aryOfTransactionsList.count > 0{
            self.historyViewModel.downloadAllHistory(categoryId: self.selectedCategoryID, fromDate: self.selectedFromDate, status: self.selectedStatus, toDate: self.selectedToDate, transactionRefId: self.selectedTransactionRefId) { success,filePathURL  in
                self.filePathURL = filePathURL
                self.popViewBorder.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                self.popViewIcon.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_SecondaryColor)
                self.popViewOpenbtn.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
                self.popViewOpenbtn.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
                
                Utilities.sharedInstance.displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: self.popView)
            }
        }else{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.NoTransactionsAvailable)
        }
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
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
    
    func setupMonth(){
        self.txtSelectMonth.optionArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        self.txtSelectMonth.didSelect{(selectedText , index ,id) in
            self.txtSelectMonth.text = selectedText
            
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "LLLL"
            if let date = df.date(from: selectedText) {
                let month = Calendar.current.component(.month, from: date)
                
                let calendar = Calendar.current
                var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
                component.month = month
                
                let date: Date? = Calendar.current.date(from: component)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Utilities.sharedInstance.historyDateFormate
                
                let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date!)
                let startOfMonth = Calendar.current.date(from: comp)!
                self.selectedFromDate = dateFormatter.string(from: startOfMonth)
                
                var comps2 = DateComponents()
                comps2.month = 1
                comps2.day = -1
                let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
                self.selectedToDate = dateFormatter.string(from: endOfMonth!)
                
                self.fetchTransactions()
            }
        }
    }
    
    func setupStatus(){
        self.txtSelectStatus.optionArray = ["Initiated","Failure","Success"]
        self.txtSelectStatus.didSelect{(selectedText , index ,id) in
            self.txtSelectStatus.text = selectedText
            self.selectedStatus = selectedText
            self.fetchTransactions()
        }
    }
    
    func fetchTransactions(){
        self.historyViewModel.getListOfTransactions(categoryId: self.selectedCategoryID, fromDate: self.selectedFromDate, status: self.selectedStatus, toDate: self.selectedToDate, transactionRefId: self.selectedTransactionRefId) { success in
            if self.historyViewModel.aryOfTransactionsList.count > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoDataFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoDataFound.isHidden = false
                self.lblNoDataFound.text = Constant.NoTransactionsAvailable
            }
        }
    }
    
    func fetchComplaints(){
        self.historyViewModel.getListOfComplaints { success in
            if self.historyViewModel.dicOfComplaintsList?.payload?.count ?? 0 > 0{
                self.tblView.isHidden = false
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoDataFound.isHidden = true
            }else{
                self.tblView.isHidden = true
                self.lblNoDataFound.isHidden = false
                self.lblNoDataFound.text = Constant.NoComplaintsAvailable
            }
        }
    }
    
    var selectedIndex = 0
    @objc func btnMore(sender : UIButton) {
        selectedIndex = sender.tag
        let apparray = Bundle.main.loadNibNamed("TransactionsPopView", owner: self, options: nil)
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
    
}



extension HistoryVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isTransaction{
            return self.historyViewModel.aryOfTransactionsList.count
        }else{
            return self.historyViewModel.dicOfComplaintsList?.payload?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isTransaction{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsCell.identifier, for: indexPath) as? TransactionsCell else {
                fatalError("XIB doesn't exist.")
            }
            
            let obj = self.historyViewModel.aryOfTransactionsList[indexPath.row]
            
            cell.lblNickName.text = obj.billNickName ?? ""
            cell.lblTitle.text = obj.billerName ?? ""
            cell.lblTitle.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            cell.lblSubTitle.text = obj.txnid
            cell.lblPrice.text = "₹ \(obj.amount ?? 0)"
            cell.lblPrice.textColor = obj.status == "SUCCESS" ? Utilities.sharedInstance.hexStringToUIColor(hex: "020202") : Utilities.sharedInstance.hexStringToUIColor(hex: "EB0202")
            cell.lblFailed.isHidden = obj.status == "SUCCESS" ? true : false
            
            if let str = obj.paymentDate{
                let dateAry = str.components(separatedBy: "T")
                let dateValue = dateAry[0]
                cell.lblDate.text = self.convertDateFormater(dateValue)
            }else{
                cell.lblDate.text = ""
            }
            
            cell.btnDots.tag = indexPath.row
            cell.btnDots.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ComplaintsCell.identifier, for: indexPath) as? ComplaintsCell else {
                fatalError("XIB doesn't exist.")
            }
            if let payload = self.historyViewModel.dicOfComplaintsList?.payload {
                let obj = payload[indexPath.row]
                
                cell.lblSortName.text = obj.billNickName ?? ""
                cell.lblTitle.text = obj.billerName ?? ""
                cell.lblTitle.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                cell.lblDescription.text = obj.customerParams?[0].value
                
                cell.lblPrice.text = "₹ \(obj.billAmount ?? 0)"
                
                if let str = obj.paymentDate{
                    let dateAry = str.components(separatedBy: "T")
                    let dateValue = dateAry[0]
                    cell.lblDate.text = self.convertDateFormater(dateValue)
                }else{
                    cell.lblDate.text = ""
                }
                
                let status = obj.complaintStatus
                
                cell.lblStatus.text = status
                if status == "SUCCESS"{
                    cell.lblStatus.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
                    cell.subView.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).withAlphaComponent(0.6)
                }else{
                    cell.lblStatus.textColor = UIColor.red
                    cell.subView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                }
                
                cell.mainView.roundCorners(corners: [.bottomLeft], radius: 10)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTransaction {
            let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
            let obj = self.historyViewModel.aryOfTransactionsList[indexPath.row]
            nextVC.transactionID = obj.txnid ?? ""
            nextVC.isFromHomeDetail = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
            nextVC.transactionID = self.historyViewModel.dicOfComplaintsList?.payload?[indexPath.row].txnId ?? ""
            nextVC.isFromHomeDetail = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
