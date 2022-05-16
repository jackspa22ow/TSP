//
//  MobileRechargeCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 15/11/21.
//

import UIKit

class MobileRechargeCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var lblOperator: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgAddToMyBill: UIImageView!
    @IBOutlet weak var tblPlanList: UITableView!
    
    var selectedIndex : Int = 0
    
    var arrayOfPlanType : [String] = []
    
    var isOperatorSelected:((_ isOperator : Bool) -> ())?
    var selectedPlanType:((_ planType : String) -> ())?
    var rechargePlanTableHeight:((_ height : Float) -> ())?
    var rechargePlanSelect:((_ index : Int,_ isAddToMyBill : Bool) -> ())?

    var rechargePlans: [GetRechargePlansContent] = []
    @IBOutlet weak var consAddToMyBillsHightZero: NSLayoutConstraint!
    
    var isHeightCalculated : Bool = false
    var isAddToMyBill : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        tblPlanList.register(MobileRechargePlanCell.nib, forCellReuseIdentifier: MobileRechargePlanCell.identifier)

        collectionView.register(MobileRechargeTypeCell.nib, forCellWithReuseIdentifier: MobileRechargeTypeCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        tblPlanList.delegate = self
        tblPlanList.dataSource = self
        
        tblPlanList.rowHeight = 100
        tblPlanList.estimatedRowHeight = UITableView.automaticDimension
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(selectedOperator: String, selectedCircle: String) {
        if selectedOperator.count > 0 {
            lblOperator.text = selectedOperator
        }
        if selectedCircle.count > 0 {
            lblCircle.text = selectedCircle
        }
    }
    @IBAction func btnOperatorAction(_ sender: Any) {
        isOperatorSelected?(true)
    }
    
    @IBAction func btnCircleAction(_ sender: Any) {
        isOperatorSelected?(false)
    }
    
    @IBAction func btnAddTomyBillAction(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            imgAddToMyBill.image = UIImage(named: "ic_check")
            self.isAddToMyBill = true
        } else {
            sender.tag = 0
            imgAddToMyBill.image = UIImage(named: "ic_uncheck")
            self.isAddToMyBill = false
        }
    }
    
}

extension MobileRechargeCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rechargePlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MobileRechargePlanCell.identifier, for: indexPath) as! MobileRechargePlanCell
        cell.lblPlanDescription.text = rechargePlans[indexPath.row].packageDescription
        cell.lblDays.text = rechargePlans[indexPath.row].validity
        cell.lblPrice.text = "₹\(rechargePlans[indexPath.row].price ?? "")"
        cell.lblPrice.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)

        cell.lblData.text = ""
        
        cell.viewPrice.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rechargePlanSelect?(indexPath.row, isAddToMyBill)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!isHeightCalculated) {
            isHeightCalculated = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.rechargePlanTableHeight?(Float(tableView.contentSize.height))
            }
        }
        return UITableView.automaticDimension
    }
}


extension MobileRechargeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPlanType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MobileRechargeTypeCell.identifier, for: indexPath) as? MobileRechargeTypeCell else {
            fatalError("XIB doesn't exist.")
        }

        cell.lblItem.text = arrayOfPlanType[indexPath.row]
        
        if selectedIndex == indexPath.row {
            cell.lblItem.textColor = UIColor.black
        } else {
            cell.lblItem.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = selectedIndex
        selectedIndex = indexPath.row

        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        

        collectionView.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        isHeightCalculated = false

        self.selectedPlanType?(arrayOfPlanType[indexPath.row])

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 3, height: 60)
    }

}
