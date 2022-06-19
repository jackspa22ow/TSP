//
//  HomeBillItemsCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 09/07/21.
//

import UIKit
import DXPopover

protocol HomeBillItemsCellDelegate {
    func selectBillDetail(index:Int)
    func switchAutoPAuAction(index:Int)
}

class HomeBillItemsCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNoBillsAvailable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var viewBack: UIView!
    var selectedMoreIndex:((_ index : Int) -> ())?
    var btnMoreAction:((_ sender : UIButton) -> ())?

    var selectedIndex : Int = 0
    
    var modeValue : Int = 0
    var aryOfMyBills : [MyBillsContent] = []{
        didSet {
            if aryOfMyBills.count > 0{
                self.lblNoBillsAvailable.isHidden = true
                self.collectionView.isHidden = false
                if aryOfMyBills.count > 4{
                    self.viewBack.isHidden = false
                    self.viewNext.isHidden = false
                }else{
                    self.viewBack.isHidden = true
                    self.viewNext.isHidden = true
                }
            }else{
                self.lblNoBillsAvailable.isHidden = false
                self.collectionView.isHidden = true
                self.viewBack.isHidden = true
                self.viewNext.isHidden = true
            }
        }
    }
    
    var delegate:HomeBillItemsCellDelegate?
                                                                                            
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: ((collectionView.frame.size.width / 2)), height: 316)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
        collectionView!.collectionViewLayout = layout
        
        collectionView.register(HomeBillCell.nib, forCellWithReuseIdentifier: HomeBillCell.identifier)
        collectionView.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func scrollToNext(){
        if self.aryOfMyBills.count > index + 4 {
            index = index + 4
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0) , at: .top, animated: false)
        }
    }
    func scrollToPrev(){
        if index > 0 {
            index = index - 4
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0) , at: .centeredVertically, animated: false)
        }
    }
    

    @objc func btnMore(sender : UIButton) {
        self.selectedMoreIndex?(sender.tag)
        self.btnMoreAction?(sender)
    }
    
    @objc func btnPayNowAction(sender : UIButton) {
        self.delegate?.selectBillDetail(index: sender.tag)
    }
    @objc func btnAutoPaySwitchAction(sender : UIButton) {
        self.delegate?.switchAutoPAuAction(index: sender.tag)
    }
}

extension HomeBillItemsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modeValue = 0
//        modeValue = aryOfMyBills.count % 4
        if modeValue == 0 {
            return aryOfMyBills.count
        } else {
            return aryOfMyBills.count + (4 - modeValue)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBillCell.identifier, for: indexPath) as? HomeBillCell  else { fatalError("XIB doesn't exist.") }
        
        if modeValue > 0 && (indexPath.row >= aryOfMyBills.count) {
            cell.viewEmptyCell.isHidden = false
        } else {
            cell.viewEmptyCell.isHidden = true
            let json = self.aryOfMyBills[indexPath.row]
            
            //cell.billerLogo.image = UIImage(named: aryOfImg[indexPath.row])
            cell.billerLogo.image = #imageLiteral(resourceName: "ic_bharatbillpay")
            
            cell.billerName.text = json.billNickName
            cell.lblItemTitleHeight.constant = json.billerName != "" ? 15 : 0
            
            cell.billerShortName.text = json.billerShortName
            cell.lblItemSubTitleTopSpace.constant = json.billerShortName != "" ? 2 : 0
            
            //            cell.btnDue.isHidden = json.billDue == true ? false : true

            if json.billDue == true || json.billDue == nil{
                cell.lblDue.text = "DUE"
                cell.btnPayNow.isHidden = false
                cell.imgPayNow.isHidden = false
                cell.lblDue.backgroundColor = UIColor.red
            } else {
                cell.lblDue.text = "PAID"
                cell.btnPayNow.isHidden = true
                cell.imgPayNow.isHidden = true
                cell.lblDue.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            }
            cell.switchAutoPay.isOn = json.autoPay == true ? true : false
            cell.switchAutoPay.onTintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            
            let customerIDArray = json.customerParams.filter{ $0.primary == true}
            if customerIDArray.count > 0 {
                cell.billerPayuId.text = customerIDArray[0].value
            } else {
                cell.billerPayuId.text = ""
            }
            
            cell.lblDueDate.text = json.dueDate
            
            if let amount = json.amount {
                cell.lblAmount.text = "₹ \(amount)"
            } else {
                cell.lblAmount.text = "₹ 0.00"

            }
            cell.switchAutoPay.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            cell.switchAutoPay.onTintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(self.btnMore), for: .touchUpInside)
            cell.btnPayNow.tag = indexPath.row
            cell.btnPayNow.addTarget(self, action: #selector(btnPayNowAction), for: .touchUpInside)
            cell.btnAutoPaySwitch.addTarget(self, action: #selector(btnAutoPaySwitchAction), for: .touchUpInside)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 5
        return CGSize(width: width, height: 233)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.selectBillDetail(index: indexPath.row)
    }
    
}
