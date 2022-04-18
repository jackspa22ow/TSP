//
//  SingleBillDetailsViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/09/21.
//

import UIKit
import Alamofire

class SingleBillDetailsViewModel: NSObject {
    var dicOfSingleBillDetails : SingleBillDetails!

    //Remain
    // MARK: - Call api to fetch Users Profile
    func getSingleBillDetails(transactionID:String ,completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let apiString = API.GET_SINGLE_BILL_DETAILS + transactionID
        let requestHelper = RequestHelper(url: apiString, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(SingleBillDetails.self, from: response.responseData!)
                self.dicOfSingleBillDetails = json
                completion(true)
            }
        }
    }
}
