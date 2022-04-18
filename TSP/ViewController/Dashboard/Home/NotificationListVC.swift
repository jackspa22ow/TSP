//
//  NotificationListVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/02/22.
//

import UIKit

class NotificationListVC: UIViewController {

    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    let notificationListViewModel = NotificationListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.estimatedRowHeight = 81
        self.tblView.register(NotificationListCell.nib, forCellReuseIdentifier: NotificationListCell.identifier)
        
        self.getNotificationList()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNotificationList(){
        let str = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let fromDate = str!.string(format: Utilities.sharedInstance.historyDateFormate)
        
        let toDate = Date().string(format: Utilities.sharedInstance.historyDateFormate)
        
        self.notificationListViewModel.getNotificationList(fromDate: fromDate, toDate: toDate) { response in
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()
        }        
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        return dateFormatter.string(from: date!)
    }

}


extension NotificationListVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationListViewModel.dicOfNotification.content.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListCell.identifier, for: indexPath) as? NotificationListCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = self.notificationListViewModel.dicOfNotification.content[indexPath.row]

        cell.lblTitle.text = obj.name
        cell.lblDescription.text = obj.description
        
        
        if let str = obj.time{
            cell.lblDate.text = self.convertDateFormater(str)
        }else{
            cell.lblDate.text = ""
        }
        
        return cell
    }
    
}
