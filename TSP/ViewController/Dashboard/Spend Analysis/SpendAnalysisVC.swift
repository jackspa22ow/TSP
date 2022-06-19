//
//  SpendAnalysisVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Fastis

class SpendAnalysisVC: UIViewController {
    
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblExpenses: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    
    var aryOfColors = ["ED963E","46B5BA","3299E4","ED5F7F","ECC154","FFBF00","FF7F50","DE3163","9FE2BF","9FE2BF","6495ED","CCCCFF"]
    
    let spendAnalysisViewModel = SpendAnalysisViewModel()
    
    var selectedFromDate = String()
    var selectedToDate = String()
    
    var currentValue: FastisValue?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM, yyyy"
            if let rangeValue = self.currentValue as? FastisRange{
                self.lblExpenses.text = "Expenses from \(formatter.string(from: rangeValue.fromDate) + " to " + formatter.string(from: rangeValue.toDate))"
                self.selectedFromDate = rangeValue.fromDate.string(format: Utilities.sharedInstance.historyDateFormate)
                self.fetchSpendAnalysisHistory()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)], for: .selected)
        
        self.tblView.register(SpendAnalysisCell.nib, forCellReuseIdentifier: SpendAnalysisCell.identifier)
        
        self.selectedToDate = Date().string(format: Utilities.sharedInstance.historyDateFormate)
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        self.selectedFromDate = sevenDaysAgo!.string(format: Utilities.sharedInstance.historyDateFormate)
        self.btnHelp.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)

        self.fetchSpendAnalysisHistory()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonSegmentControl(_ sender: UISegmentedControl) {
        if self.segmentControl.selectedSegmentIndex == 0{
            self.lblExpenses.text = "Expenses in last 7 days"
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            self.selectedFromDate = sevenDaysAgo!.string(format: Utilities.sharedInstance.historyDateFormate)
            self.fetchSpendAnalysisHistory()
        }else if self.segmentControl.selectedSegmentIndex == 1{
            self.lblExpenses.text = "Expenses in last 1 month"
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            self.selectedFromDate = oneMonthAgo!.string(format: Utilities.sharedInstance.historyDateFormate)
            self.fetchSpendAnalysisHistory()
        }else if self.segmentControl.selectedSegmentIndex == 2{
            self.lblExpenses.text = "Expenses in last 3 month"
            let threeMonthAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())
            self.selectedFromDate = threeMonthAgo!.string(format: Utilities.sharedInstance.historyDateFormate)
            self.fetchSpendAnalysisHistory()
        }else{
            self.showDateRangeSelection()
        }
    }
    
    func showDateRangeSelection(){
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.initialValue = self.currentValue as? FastisRange
        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.doneHandler = { newValue in
            self.currentValue = newValue
        }
        fastisController.present(above: self)
    }
    
    
    
    func fetchSpendAnalysisHistory(){
        self.spendAnalysisViewModel.getSpendAnalysisHistory(clientId: "", fromDate: self.selectedFromDate, monthConstant: "", toDate: self.selectedToDate) { success in
            if self.spendAnalysisViewModel.aryOfSpendAnalysisHistory.count > 0{
                self.setPieChart()
                self.tblView.dataSource = self
                self.tblView.delegate = self
                self.tblView.reloadData()
                self.lblNoDataFound.isHidden = true
                self.pieChartView.isHidden = false
                self.historyView.isHidden = false
            }else{
                self.lblNoDataFound.isHidden = false
                self.pieChartView.isHidden = true
                self.historyView.isHidden = true
            }
        }
    }
    
    func setPieChart(){
        
        let count = self.spendAnalysisViewModel.aryOfSpendAnalysisHistory.count
        var items: [PNPieChartDataItem] = []
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        for i in 0..<count{
            let obj = self.spendAnalysisViewModel.aryOfSpendAnalysisHistory[i]
            let item = PNPieChartDataItem(dateValue: CGFloat(obj.totalAmount!), dateColor: Utilities.sharedInstance.hexStringToUIColor(hex: self.aryOfColors[i]))
            items.append(item)
        }
        
        let pieChart = PNPieChart(frame: frame, items: items)
        pieChart.isUserInteractionEnabled = false
        self.pieChartView.addSubview(pieChart)
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


extension SpendAnalysisVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spendAnalysisViewModel.aryOfSpendAnalysisHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendAnalysisCell.identifier, for: indexPath) as? SpendAnalysisCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = self.spendAnalysisViewModel.aryOfSpendAnalysisHistory[indexPath.row]

        cell.viewLeftBorder.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: self.aryOfColors[indexPath.row])
        cell.viewLeftBorder.roundCorners(corners: [.topLeft,.bottomLeft], radius: 2)
        
        cell.lblTitle.text = obj.categoryName
        cell.lblPrice.text = (String(format: "₹%.2f", obj.totalAmount ?? 0))
        cell.lblCount.text = "\(obj.txnCount ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.spendAnalysisViewModel.aryOfSpendAnalysisHistory[indexPath.row]
        let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "SpendAnalysisListVC")as! SpendAnalysisListVC
        nextVC.categoryName = obj.categoryName!
        nextVC.categoryId = "\(obj.categoryId!)"
        nextVC.fromDate = self.selectedFromDate
        nextVC.toDate = self.selectedToDate
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
