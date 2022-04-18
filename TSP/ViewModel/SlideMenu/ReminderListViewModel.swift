//
//  ReminderListViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 01/10/21.
//

import UIKit
import Alamofire

class ReminderListViewModel: NSObject {
    
    var dicOfReminderList : ReminderListModel!
    var dicOfReminderSubtype : ReminderSubtypeList!
    var dicOfReminderUpdate : ReminderUpdate!
    var dicOfReminderByBill : RemindersForBillModel!

    
    //Remain
    func getReminderList(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_REMIDER_LIST, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ReminderListModel.self, from: response.responseData!)
                self.dicOfReminderList = json!
                completion(true)
            }
        }
    }
    
    //remain
    func deleteReminder(reminderID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.GET_REMIDER_LIST)\(reminderID)"
        let requestHelper = RequestHelper(url: urlString, method: .delete, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                completion(true)
            }
        }
    }
    
    //Remain
    func fetchReminderByUserBillID(billID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.GET_REMINDER_BY_USER_BILL_ID)\(billID)"
        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ReminderListModel.self, from: response.responseData!)
                self.dicOfReminderList = json!
                completion(self.dicOfReminderList.payload.count > 0 ? true : false)
            }
        }
    }
    
    func getReminderSubType(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_REMINDER_OPTIONS, method: .get, encoding: URLEncoding.queryString, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ReminderSubtypeList.self, from: response.responseData!)
                self.dicOfReminderSubtype = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func updateReminderByReminderID(reminderID:String, billID:String, daysAfter: Int, dayBefore: Int, eventSubType: Int, isEnable: Bool, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        let param : [String: Any] = ["billId": billID, "daysAfterBillGenerated": daysAfter, "daysBeforeDueDate": dayBefore, "eventSubType": eventSubType, "eventType": 2, "isEnable": isEnable]

        print(param)

        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let urlString = "\(API.PUT_REMINDER_DESABLE)\(reminderID)"
        let requestHelper = RequestHelper(url: urlString, method: .put, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ReminderUpdate.self, from: response.responseData!)
                self.dicOfReminderUpdate = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func getReminderByBillID(billID:String, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.GET_REMINDERS_BY_BILL_ID)\(billID)"
        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(RemindersForBillModel.self, from: response.responseData!)
                self.dicOfReminderByBill = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func setReminderByBillID(billID : String, requestParam: [[String: Any]], completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        let param : [[String: Any]] = requestParam

        print(param)

        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let urlString = "\(API.PUT_REMINDERS_BY_BILL_ID)\(billID)"
        let requestHelper = RequestHelper(url: urlString, method: .put, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(RemindersForBillModel.self, from: response.responseData!)
                self.dicOfReminderByBill = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func desableReminderByBillID(billID : Int, completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let urlString = "\(API.PUT_REMINDERS_BY_BILL_DESABLE)\(billID)/status/false"
        let requestHelper = RequestHelper(url: urlString, method: .put, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(RemindersForBillModel.self, from: response.responseData!)
                self.dicOfReminderByBill = json!
                completion(true)
            }
        }
    }
}
