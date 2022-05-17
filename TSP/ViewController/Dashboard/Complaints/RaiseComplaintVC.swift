//
//  RaiseComplaintVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/11/21.
//

import UIKit
import ActionSheetPicker_3_0

class RaiseComplaintVC: UIViewController {
    var placeHolderText = "Message"
    
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtIssueName: UITextField!
    @IBOutlet weak var lblDahsedLine: UILabel!
    
    var aryOfIssueType : [String] = []

    let raiseComplaintViewModel = RaiseComplaintViewModel()
    var refID: String = ""
    var billerId: String = ""
    var complainTypeIndex : Int = 0
    @IBOutlet weak var lblBillerName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnRaiseTicket: UIButton!
    var dicOfSingleBillDetails : SingleBillDetails!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtViewDescription.text = self.placeHolderText
        self.txtViewDescription.textColor = UIColor.lightGray
        
        self.lblBillerName.text = dicOfSingleBillDetails.billerName ?? ""
        self.lblAmount.text = (String(format: "₹%.2f", dicOfSingleBillDetails.amount ?? 0))
        getComplaintTypes()
        
        self.lblBillerName.font = Utilities.AppFont.black.size(13)
        self.lblAmount.font = Utilities.AppFont.black.size(20)
        self.lblAmount.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        self.btnRaiseTicket.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        if let billDate = dicOfSingleBillDetails.paymentDate{
            if billDate.contains("T"){
                let val = billDate.components(separatedBy: "T")
                let str = self.convertDateFormaterr(val[0])
                self.lblDate.text = str
            }else{
                self.lblDate.text = ""
            }
        }else{
            self.lblDate.text = ""
        }
    }
    
    func convertDateFormaterr(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date!)
    }
    func getComplaintTypes(){
        self.raiseComplaintViewModel.getComplaintTypes { response in
            self.txtIssueName.text = self.raiseComplaintViewModel.aryOfComplaintTypeList[0].messageDeposition
            
            for obj in self.raiseComplaintViewModel.aryOfComplaintTypeList {
                self.aryOfIssueType.append(obj.messageDeposition ?? "")
            }
        }
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnIssueAction(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Payment Method", rows: self.aryOfIssueType
                                     , initialSelection: 0, doneBlock: {
            picker, values, indexes in
            self.complainTypeIndex = values
            self.txtIssueName.text = "\(indexes!)"
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return
            
        }, origin: sender)
    }
    
    @IBAction func btnRaiseTicketAction(_ sender: Any) {
        let complainType = self.raiseComplaintViewModel.aryOfComplaintTypeList[complainTypeIndex].type ?? ""
        self.raiseComplaintViewModel.raiseComplaint(complaintType: complainType, description: self.txtViewDescription.text!, disposition: self.txtIssueName.text ?? "", payuBillerId: self.billerId, refId: self.refID) { response in
            print("Done")
        }
    }
}

extension RaiseComplaintVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
}
