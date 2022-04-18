//
//  NotificationListViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/02/22.
//

import UIKit
import Alamofire

class NotificationListViewModel: NSObject {
    
    var dicOfNotification : NotificationListModel!
    
    func getNotificationList(fromDate:String, toDate:String, completion : @escaping (_ response:Bool) -> Void){

        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["fromDate":fromDate,"toDate": toDate]
                
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.NOTIFICATION_LIST, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(NotificationListModel.self, from: response.responseData!)
                self.dicOfNotification = json!
                completion(true)
            }
        }
        
        
        
        
    }
    
}
