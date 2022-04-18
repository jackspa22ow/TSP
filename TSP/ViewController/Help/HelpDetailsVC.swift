//
//  HelpDetailsVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 15/07/21.
//

import UIKit

class HelpDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var labelNavigationBarTitle: UILabel!
    
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedIndex == 1{
            self.labelNavigationBarTitle.text = "Recent Orders"
        }else if self.selectedIndex == 2{
            self.labelNavigationBarTitle.text = "Choose a Service"
        }else{
            self.labelNavigationBarTitle.text = "Popular HelpTopics"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == 1{
            return 80
        }else if self.selectedIndex == 2{
            return 90
        }else{
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedIndex == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            
            return cell
        }else if self.selectedIndex == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            
            return cell
        }
    }
    

}
