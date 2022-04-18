//
//  AutopayListViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 01/10/21.
//

import UIKit
import Alamofire

class AutopayListViewModel: NSObject {
    
    var aryOfAutoPayList : [AutopayListModel] = []
    var autoPayDetail : AutopayListModel!

    //Remain
    func getAutoPayList(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_AUTOPAY_LIST, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([AutopayListModel].self, from: response.responseData!)
                self.aryOfAutoPayList = json!
                completion(true)
            }
        }
    }

    //Remain
    func getAutoPayByID(autoPayID: String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = API.GET_AUTOPAY_DETAIL_BY_ID + autoPayID

        let requestHelper = RequestHelper(url: urlString, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AutopayListModel.self, from: response.responseData!)
                self.autoPayDetail = json!
                completion(true)
            }
        }
    }
}
