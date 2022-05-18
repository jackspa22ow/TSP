//
//  SpendAnalysisListVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 24/09/21.
//

import UIKit

class SpendAnalysisListVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    var categoryName = String()
    var categoryId = String()
    var fromDate = String()
    var toDate = String()
    
    let spendAnalysisListViewModel = SpendAnalysisListViewModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.lblCategoryName.text = self.categoryName
        
        self.tblView.register(SpendAnalysisCategoryCell.nib, forCellReuseIdentifier: SpendAnalysisCategoryCell.identifier)

        self.tblView.register(SpendAnalysisCategoryFooterCell.nib, forCellReuseIdentifier: SpendAnalysisCategoryFooterCell.identifier)
        
        self.spendAnalysisListViewModel.getSpendAnalysisListHistory(categoryId: self.categoryId, fromDate: self.fromDate, monthConstant: "", status: "", toDate: self.toDate, transactionRefId: "") { success in
            self.tblView.dataSource = self
            self.tblView.delegate = self
            self.tblView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}


extension SpendAnalysisListVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList.count == indexPath.row{
            return 100
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList.count == indexPath.row{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendAnalysisCategoryFooterCell.identifier, for: indexPath) as? SpendAnalysisCategoryFooterCell else {
                fatalError("XIB doesn't exist.")
            }
            
            let obj = self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList
            
            var finalAmount = Double()
            for j in obj{
                finalAmount = finalAmount + j.amount!
            }
        
            cell.lblBillCount.text = "( Total \(obj.count) Billers )"
            cell.lblPrice.text = (String(format: "₹%.2f", finalAmount))

            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendAnalysisCategoryCell.identifier, for: indexPath) as? SpendAnalysisCategoryCell else {
                fatalError("XIB doesn't exist.")
            }
            
            let obj = self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList[indexPath.row]
            
            cell.lblBillerNickName.text = obj.billNickName ?? ""
            cell.lblTitle.text = obj.billerName ?? ""
            cell.lblSubTitle.text = obj.txnid ?? ""
            cell.lblPrice.text = (String(format: "₹%.2f", obj.amount ?? 0))
            
            if let str = obj.paymentDate{
                let dateAry = str.components(separatedBy: "T")
                let dateValue = dateAry[0]
                cell.lblDate.text = self.convertDateFormater(dateValue)
            }else{
                cell.lblDate.text = ""
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList.count != indexPath.row{
            
            let obj = self.spendAnalysisListViewModel.aryOfSpendAnalysisHistoryList[indexPath.row]
            
            let nextVC = BILLDETAILS_STORYBOARD.instantiateViewController(withIdentifier: "SingleBillDetailsVC")as! SingleBillDetailsVC
            nextVC.transactionID = obj.txnid ?? ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
}
