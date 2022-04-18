//
//  SpendAnalysisViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Alamofire

class SpendAnalysisViewModel: NSObject {
    
    var aryOfSpendAnalysisHistory : [SpendAnalysisElement] = []
    
    //Remain
    func getSpendAnalysisHistory(clientId:String, fromDate:String, monthConstant:String, toDate:String, completion : @escaping (_ response:Bool) -> Void){

        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["clientId":clientId,"fromDate":fromDate,"monthConstant":monthConstant,"toDate": toDate]
                
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.GET_SPEND_ANALYSIS_HISTORY, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(SpendAnalysis.self, from: response.responseData!)
                self.aryOfSpendAnalysisHistory = json!
                completion(true)
            }
        }
    }
    
}



class SpendAnalysisListViewModel: NSObject {
    
    var aryOfSpendAnalysisHistoryList : [SpendAnalysisListElement] = []
    
    ////Remain
    func getSpendAnalysisListHistory(categoryId:String, fromDate:String, monthConstant:String, status:String, toDate:String, transactionRefId:String, completion : @escaping (_ response:Bool) -> Void){

        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["categoryId":categoryId,"fromDate":fromDate,"monthConstant":monthConstant,"status":status,"toDate": toDate,"transactionRefId":transactionRefId]
                
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.GET_SPEND_ANALYSIS_HISTORY_LIST, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(SpendAnalysisList.self, from: response.responseData!)
                self.aryOfSpendAnalysisHistoryList = json!
                completion(true)
            }
        }
    }
    
}
