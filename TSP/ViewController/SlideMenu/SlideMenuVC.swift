//
//  SlideMenuVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 07/07/21.
//

import UIKit

class SlideMenuSection {
    var title : String?
    var list : [String]?
    var isColleps : Bool?
    init() {
    }
    
    init(title : String? , list : [String]?, isColleps : Bool?) {
        self.title = title
        self.list = list
        self.isColleps = isColleps
        
    }
}

class SlideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    var arrayOfIcons = ["ic_menu_billers","ic_menu_history","ic_menu_reminders","ic_menu_auto_play","ic_menu_contact_us","ic_menu_spend_analysis","ic_menu_help"]
    
    var data:[SlideMenuSection] = []
    
    var aryOfBillers:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TSP_Allow_Multiple_Billpay != "true"{
            self.aryOfBillers = ["My Bills", "Add Biller"]
        }else{
            self.aryOfBillers = ["My Bills", "Add Biller", "Multiple Bill Payment"]
        }
        
        if TSP_Allow_Setting_Reminders == Constant.Client && TSP_Allow_Setting_Autopay == Constant.Client{
            self.data = [SlideMenuSection(title: "Billers", list: self.aryOfBillers, isColleps: false),SlideMenuSection(title: "History", list: ["Transaction History", "Complaints"], isColleps: false),SlideMenuSection(title: "Contact Us", list: nil, isColleps: false),SlideMenuSection(title: "Spend Analysis", list: nil, isColleps: false),SlideMenuSection(title: "Help", list: nil, isColleps: false)]
        }else if TSP_Allow_Setting_Reminders == Constant.User && TSP_Allow_Setting_Autopay == Constant.Client{
            self.data = [SlideMenuSection(title: "Billers", list: self.aryOfBillers, isColleps: false),SlideMenuSection(title: "History", list: ["Transaction History", "Complaints"], isColleps: false),SlideMenuSection(title: "Reminders", list: nil, isColleps: false),SlideMenuSection(title: "Contact Us", list: nil, isColleps: false),SlideMenuSection(title: "Spend Analysis", list: nil, isColleps: false),SlideMenuSection(title: "Help", list: nil, isColleps: false)]
        }else if TSP_Allow_Setting_Reminders == Constant.Client && TSP_Allow_Setting_Autopay == Constant.User{
            self.data = [SlideMenuSection(title: "Billers", list: self.aryOfBillers, isColleps: false),SlideMenuSection(title: "History", list: ["Transaction History", "Complaints"], isColleps: false),SlideMenuSection(title: "Auto Pay", list: nil, isColleps: false),SlideMenuSection(title: "Contact Us", list: nil, isColleps: false),SlideMenuSection(title: "Spend Analysis", list: nil, isColleps: false),SlideMenuSection(title: "Help", list: nil, isColleps: false)]
        }else{
            self.data = [SlideMenuSection(title: "Billers", list: self.aryOfBillers, isColleps: false),SlideMenuSection(title: "History", list: ["Transaction History", "Complaints"], isColleps: false),SlideMenuSection(title: "Reminders", list: nil, isColleps: false),SlideMenuSection(title: "Auto Pay", list: nil, isColleps: false),SlideMenuSection(title: "Contact Us", list: nil, isColleps: false),SlideMenuSection(title: "Spend Analysis", list: nil, isColleps: false),SlideMenuSection(title: "Help", list: nil, isColleps: false)]
        }
        
        self.lblName.text = "\(dicOfUserProfile.firstName!) \(dicOfUserProfile.lastName!)"
        self.lblMobileNumber.text = dicOfUserProfile.phoneNumber
        
        //setup theme based app
        self.setupTheme()
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
        // Do any additional setup after loading the view.
    }
    
    func setupTheme(){
        self.view.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
    }
    
    @IBAction func buttonHandlerDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func buttonHandlerProfile(_ sender: Any) {
        let nextVC = SLIDEMENU_STORYBOARD.instantiateViewController(withIdentifier: "ProfileVC")as! ProfileVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : SlideMenuHeaderCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SlideMenuHeaderCell.self)) as! SlideMenuHeaderCell
        
        let sectionData = data[section]
        header.labelTitle.text = sectionData.title
        header.imageIcon.image = UIImage(named: self.arrayOfIcons[section])
        header.buttonHandlerAction.tag = section
        header.buttonHandlerAction.addTarget(self, action: #selector(buttonHandlerSectionArrowTap(sender:)), for: .touchUpInside)
        
        if sectionData.list != nil{
            ///arrow rotate
            header.imageDropDown.isHidden = false
            header.buttonHandlerAction.transform = CGAffineTransform(rotationAngle: (sectionData.isColleps)! ? 0.0 : .pi)
            
            ///change cell color and arrow to updown
            if sectionData.isColleps == true{
                header.imageDropDown.image = UIImage(named: "ic_upArrow")
                header.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                header.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                header.labelTitle.font = Utilities.AppFont.black.size(20)
            }else{
                header.imageDropDown.image = UIImage(named: "ic_downArrow")
                header.contentView.backgroundColor = UIColor.clear
                header.backgroundColor = UIColor.clear
                header.labelTitle.font = Utilities.AppFont.book.size(20)
            }
            
        }else{
            header.imageDropDown.isHidden = true
        }
        
        return header.contentView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  data[section].isColleps ?? false ? (data[section].list?.count ?? 0) : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SlideMenuContentCell = tableView.dequeueReusableCell(withIdentifier: String(describing : SlideMenuContentCell.self)) as! SlideMenuContentCell
        
        let listData = data[indexPath.section].list
        cell.labelTitle.text = listData?[indexPath.row]
        
        let sectionData = data[indexPath.section]
        
        if sectionData.list != nil {
            
            if sectionData.isColleps == true{
                cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            } else {
                cell.contentView.backgroundColor = UIColor.clear
            }
        } else {
            cell.contentView.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.navigationController?.popViewController(animated: false)
                guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }
                tabbarController.selectedIndex = 1
            }else if indexPath.row == 1{
                self.navigationController?.popViewController(animated: false)
                guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }
                tabbarController.selectedIndex = 2
            }else{
                let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "MultipleBillPaymentVC")as! MultipleBillPaymentVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        else if indexPath.section == 1 {
            self.navigationController?.popViewController(animated: false)
            guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }
            if indexPath.row == 0{
                
            } else {
                IsComplaintsMenuSelected = true
            }
            tabbarController.selectedIndex = 3
            
        }
    }
    
    ///Button action arrow in header
    @objc func buttonHandlerSectionArrowTap(sender : UIButton)  {
        let indexpath = sender.tag
        if indexpath == 0 || indexpath == 1{
            let sectionData = data[sender.tag]
            sectionData.isColleps = !sectionData.isColleps!
            self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
        }else if indexpath == 2{
            let nextVC = SLIDEMENU_STORYBOARD.instantiateViewController(withIdentifier: "RemindersListVC")as! RemindersListVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if indexpath == 3{
            let nextVC = SLIDEMENU_STORYBOARD.instantiateViewController(withIdentifier: "AutoPayListVC")as! AutoPayListVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if indexpath == 4{
            
        }else if indexpath == 5{
            self.navigationController?.popViewController(animated: false)
            guard let tabbarController = UIApplication.shared.tabbarController() as? TabBarVC else { return }
            tabbarController.selectedIndex = 4
        }else if indexpath == 6 {
            let nextVC = HELP_STORYBOARD.instantiateViewController(withIdentifier: "HelpVC")as! HelpVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            
        }
    }
    
    
}
