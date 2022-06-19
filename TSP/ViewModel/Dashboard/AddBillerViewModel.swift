//
//  AddBillerViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Alamofire

class AddBillerViewModel: NSObject {
    
    var dicOfBillerList : AddBillerModel!
    var dicOfOperatorCircleInfo : GetOperatorCircleInfoModel!
    var dicOfOperator : GetAllOperatorsModel!
    var dicOfCircles : GetAllCirclesModel!
    var dicOfPlanTypes : GetPlanTypesModel!
    var dicOfRechargePlans : GetRechargePlansModel!
    var dicOfPlanDetailByPlanID : GetPlanDetailByPlanIDModel!
    var dicOfAddedBill : AddBillModel!
    var dicOfPreparePayment : PreparePayment!
    var dicOfGenerateHash : GenerateHashModel!
    var aryOfVerifyPaymentModel : [VerifyPaymentModel] = []
    
    // MARK: - Call api to fetch billers
    func getBillers(name:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = API.GET_BILLERS + name + "&page=0&size=10000&sortAscending=true&sortingField=name"
        let requestHelper = RequestHelper(url: urlString, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AddBillerModel.self, from: response.responseData!)
                if json != nil{
                    self.dicOfBillerList = json!
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
    }
    
    
    // MARK: - Call api to Get Operator Circle Info
    func getOperatorCircleInfo(phoneNumer:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let param = ["phoneNumber":phoneNumer]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_OPERATOR_CIRCLE_INFO, method: .post, parameters: param, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetOperatorCircleInfoModel.self, from: response.responseData!)
                self.dicOfOperatorCircleInfo = json!
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to Get All Operators
    func getAllOperators(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_ALL_OPERATORS, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetAllOperatorsModel.self, from: response.responseData!)
                self.dicOfOperator = json!
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to Get All Operators
    func getAllCircles(operatorId:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let param = ["operatorId":operatorId,
                     "size":"1000"]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_ALL_CIRCLES, method: .get, parameters: param, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetAllCirclesModel.self, from: response.responseData!)
                self.dicOfCircles = json!
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to Get Plan Types
    func getGetPlanTypes(circleId:String, operatorId:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let param = ["circleId":circleId,
                     "operatorId":operatorId,
                     "size":"1000"]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_PLAN_TYPES, method: .get, parameters: param, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetPlanTypesModel.self, from: response.responseData!)
                self.dicOfPlanTypes = json!
                completion(true)
            }
        }
    }
    
    
    // MARK: - Call api to Get Recharge Plans
    func getRechargePlans(circleId:String, operatorId:String, planTypeSearch:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let param = ["circleId":circleId,
                     "operatorId":operatorId,
                     "planTypeSearch":planTypeSearch]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_RECHARGE_PLANS, method: .get, parameters: param, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetRechargePlansModel.self, from: response.responseData!)
                self.dicOfRechargePlans = json!
                completion(true)
            }
        }
    }   
    
    
    // MARK: - Call api to Get Plan Detail By PlanID
    func getPlanDetailByPlanID(planId:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = API.GET_PLAN_DETAIL_BY_PLAN_ID + planId
        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GetPlanDetailByPlanIDModel.self, from: response.responseData!)
                self.dicOfPlanDetailByPlanID = json!
                completion(true)
            }
        }
    }
    
    
    //Remain
    // MARK: - Call api to Add Mobile Prepaid Bill
    func addMobilePrepeaidBill(isUserBill:String, param:[String:Any], completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let urlString = API.ADD_MOBILE_PREPAID_RECHARGE_BILL + isUserBill
        let requestHelper = RequestHelper(url: urlString, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AddBillModel.self, from: response.responseData!)
                self.dicOfAddedBill = json
                completion(true)
            }
        }
    }
    
    // MARK: - Call api to Add Biller data validation
    func addBillerDataValidation(isUserBill:String, param:[String:Any], completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let urlString = API.ADD_BILLER_DATA_VALIDATION + isUserBill
        let requestHelper = RequestHelper(url: urlString, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(AddBillModel.self, from: response.responseData!)
                self.dicOfAddedBill = json
                completion(true)
            }
        }
    }
    
    
    //Remain
    // MARK: - Call api to Add Mobile Prepaid Bill
    func preparePayment(param:[String : Any], completion:@escaping(_ response:Bool) -> Void){
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.PREPARE_PAYMENT, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(PreparePayment.self, from: response.responseData!)
                self.dicOfPreparePayment = json
                completion(true)
            }
        }
    }
    
    // MARK: - Call api to Add Mobile Prepaid Bill
    func preparePaymentForMultipleBillPayment(param:[[String : Any]], completion:@escaping(_ response:Bool) -> Void){
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.PREPARE_PAYMENT_MULTIPLE_BILL_, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(PreparePayment.self, from: response.responseData!)
                self.dicOfPreparePayment = json
                completion(true)
            }
        }
    }
    
    //Remain
    // MARK: - Call api to Add Mobile Prepaid Bill
    func generateHash(hashStringWithoutSalt:String, completion:@escaping(_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        let param = ["paymentDetails":hashStringWithoutSalt]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.GENERATE_HASH, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(GenerateHashModel.self, from: response.responseData!)
                self.dicOfGenerateHash = json
                completion(true)
            }
        }
    }
    
    //Remain
    // MARK: - Call api to Verify Payment
    func verifyPayment(transactionID:String, completion:@escaping(_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue]
        
        let urlString = API.VERIFY_PAYMENT + transactionID
        
        print(headers)
        print(urlString)

        let requestHelper = RequestHelper(url: urlString, method: .put, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([VerifyPaymentModel].self, from: response.responseData!)
                self.aryOfVerifyPaymentModel = json!
                completion(true)
            }
        }
    }
    
    
}
