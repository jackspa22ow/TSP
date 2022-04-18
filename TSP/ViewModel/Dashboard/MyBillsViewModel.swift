//
//  MyBillsViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Alamofire

class MyBillsViewModel: NSObject {
    
    var dicOfBillDetail : BillDetailModel!

    //Remain
    func deleteBill(billID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.DELETE_BILL)\(billID)/unlink"
        let requestHelper = RequestHelper(url: urlString, method: .put, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                completion(true)
            }
        }
    }
    
    //Remain
    func getBillDetailByID(billID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.GET_SINGLE_BILL_DETAILS_BY_BILL_ID)\(billID)/"
        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(BillDetailModel.self, from: response.responseData!)
                self.dicOfBillDetail = json!
                completion(true)
            }
        }
    }
    
    
}
