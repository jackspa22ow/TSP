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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtViewDescription.text = self.placeHolderText
        self.txtViewDescription.textColor = UIColor.lightGray
        getComplaintTypes()
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
