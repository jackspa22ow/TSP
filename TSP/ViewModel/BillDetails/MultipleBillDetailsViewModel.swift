//
//  MultipleBillDetailsViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 20/04/22.
//

import UIKit
import Alamofire

class MultipleBillDetailsViewModel: NSObject {
    
    var aryOfMultipleBillDetails : [MultipleBillDetails] = []

    //Remain
    // MARK: - Call api to fetch Users Profile
    func getMultipleBillDetails(transactionIDs:String ,completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let apiString = API.GET_MULTIPLE_BILL_DETAILS + transactionIDs
        let requestHelper = RequestHelper(url: apiString, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let ary = try? JSONDecoder().decode([MultipleBillDetails].self, from: response.responseData!)
                self.aryOfMultipleBillDetails = ary!
                completion(true)
            }
        }
    }
}
