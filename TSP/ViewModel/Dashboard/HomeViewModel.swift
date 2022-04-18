//
//  HomeViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Alamofire

class HomeViewModel: NSObject {
    
    var dicOfGroups : Groups!
    var aryOfBannerList : [BannerList] = []
    var dicOfMyBillList : MyBills!
    var dicOfMyBillAutoPayDetail : AutopayListModel?
    var dicAutoPayPrePayment: AutoPreparePayment!
    var dicAutoPayUpdatePrePayment: AutoPayUpdatePreparePayment!
    
    
    // MARK: -  Call api to fetch list of groups
    func getListOfGroups(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_GROUPS, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(Groups.self, from: response.responseData!)
                self.dicOfGroups = json
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to fetch Users Profile
    func getUserProfile(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.USER_PROFILE, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(UserProfile.self, from: response.responseData!)
                dicOfUserProfile = json
                completion(true)
            }
        }
    }
    
    // MARK: - Call api to fetch Banners
    func getBanners(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_BANNER_LIST, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([BannerList].self, from: response.responseData!)
                self.aryOfBannerList = json!
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to fetch bills
    func getMyBills(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_BILLS, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(MyBills.self, from: response.responseData!)
                self.dicOfMyBillList = json
                completion(true)
            }
        }
    }
    
    //Remain
    // MARK: - Call api to GET bill detail for autopay status
    //            https://api1.usprojects.co/tsp/bill-details/v1/api/si/bill/126

    func getBillAutoPayDetailByBillID(billID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = API.GET_SINGLE_BILL_DETAILS_BY_BILL_ID_FOR_AUTOPAY + billID

        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AutopayListModel.self, from: response.responseData!)
                self.dicOfMyBillAutoPayDetail = json!
                completion(true)
            }
        }
    }
    
    //remain
    // MARK: - Call api to POST bill detail for autopay status
    func setAutoPay(param: [String: Any], completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue,
                                    HeaderValue.ContentType:HeaderValue.ContentValue]
        
        let urlString = API.POST_AUTO_PAY_FOR_BILL

        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: urlString, method: .post, encoding: body, headers: headers)

        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AutoPreparePayment.self, from: response.responseData!)
                self.dicAutoPayPrePayment = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func setAutoPay(autoPayID: String, param: [String: Any], completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue,
                                    HeaderValue.ContentType:HeaderValue.ContentValue]
        
        let urlString = API.POST_AUTO_PAY_FOR_BILL + autoPayID

        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: urlString, method: .put, encoding: body, headers: headers)

        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AutoPayUpdatePreparePayment.self, from: response.responseData!)
                self.dicAutoPayUpdatePrePayment = json!
                completion(true)
            }
        }
    }

}
