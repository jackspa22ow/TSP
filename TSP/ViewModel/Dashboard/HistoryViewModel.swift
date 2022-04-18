//
//  HistoryViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Alamofire

class HistoryViewModel: NSObject {
    
    var aryOfTransactionsList : [TransactionsModel] = []
    var aryOfServiceGroupList : [ServiceGroupModel] = []
    var aryOfServiceQuestionList : [ServiceQuestionModel] = []
    
    var dicOfComplaintsList : ComplaintsModel!
    
    //Remain
    func getListOfTransactions(categoryId:String, fromDate:String, status:String, toDate:String, transactionRefId:String, completion : @escaping (_ response:Bool) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["categoryId":categoryId,"fromDate":fromDate,"status":status,"toDate": toDate,"transactionRefId": transactionRefId]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.GET_ALL_TRANSACTIONS, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([TransactionsModel].self, from: response.responseData!)
                self.aryOfTransactionsList = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func getListOfComplaints(completion : @escaping (_ response:Bool) -> Void){
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_ALL_COMPLAINTS, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ComplaintsModel.self, from: response.responseData!)
                self.dicOfComplaintsList = json
                completion(true)
            }
        }
    }
    
    //Remain
    func downloadAllHistory(categoryId:String, fromDate:String, status:String, toDate:String, transactionRefId:String, completion : @escaping (_ response:Bool , _ pathURL:URL) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["categoryId":categoryId,"fromDate":fromDate,"status":status,"toDate": toDate,"transactionRefId": transactionRefId]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let name = Date().string(format: "ddMMyyyyHHmmss")
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(name).pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if TSPService.isConnectedToInternet(){
            Utilities.sharedInstance.showSVProgressHUD()
            AF.download(
                API.DOWNLOAD_ALL_TRANSACTIONS,
                method: .post,
                encoding: body,
                headers: headers,
                to: destination).downloadProgress(closure: { (progress) in
                }).response(completionHandler: { (DefaultDownloadResponse) in
                    Utilities.sharedInstance.dismissSVProgressHUD()
                    completion(true,DefaultDownloadResponse.fileURL!)
                })
        }else{
            Utilities.sharedInstance.showAlertView(title: Constant.InternetErrorTitle, message: Constant.InternetErrorDescription)
        }
    }
    
    //Remain
    func downloadSingleHistory(transactionID:String, completion : @escaping (_ response:Bool , _ pathURL:URL) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let name = Date().string(format: "ddMMyyyyHHmmss")
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(name).pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if TSPService.isConnectedToInternet(){
            Utilities.sharedInstance.showSVProgressHUD()
            let url = "\(API.DOWNLOAD_SINGLE_TRANSACTION)\(transactionID)/download"
            AF.download(
                url,
                method: .get,
                headers: headers,
                to: destination).downloadProgress(closure: { (progress) in
                }).response(completionHandler: { (DefaultDownloadResponse) in
                    Utilities.sharedInstance.dismissSVProgressHUD()
                    completion(true,DefaultDownloadResponse.fileURL!)
                })
        }else{
            Utilities.sharedInstance.showAlertView(title: Constant.InternetErrorTitle, message: Constant.InternetErrorDescription)
        }
    }
    
    func getServiceGroup(completion : @escaping (_ response:Bool) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
                        
        let requestHelper = RequestHelper(url: API.GET_SERVICE_GROUP, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([ServiceGroupModel].self, from: response.responseData!)
                self.aryOfServiceGroupList = json!
                completion(true)
            }
        }
    }
    
    func getServiceQuestion(groupName: String, completion : @escaping (_ response:Bool) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
                        
        let urlEncoded = groupName.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""

        let urlString = API.GET_SERVICE_QUESTION + urlEncoded

        let requestHelper = RequestHelper(url: urlString, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([ServiceQuestionModel].self, from: response.responseData!)
                self.aryOfServiceQuestionList = json!
                completion(true)
            }
        }
    }
}


