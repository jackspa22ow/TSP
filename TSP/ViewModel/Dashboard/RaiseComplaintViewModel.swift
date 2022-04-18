//
//  RaiseComplaintViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 26/11/21.
//

import Foundation
import Alamofire

class RaiseComplaintViewModel: NSObject {
    
    var aryOfComplaintTypeList : [ComplaintsTypesModel] = []
    
    //Remain
    func getComplaintTypes(completion : @escaping (_ response:Bool) -> Void){

        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let requestHelper = RequestHelper(url: API.GET_COMPLAIN_TYPES, method: .get, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode([ComplaintsTypesModel].self, from: response.responseData!)
                self.aryOfComplaintTypeList = json!
                completion(true)
            }
        }
    }
    
    //Remain
    func raiseComplaint(complaintType:String, description:String, disposition:String, payuBillerId:String, refId: String, completion : @escaping (_ response:Bool) -> Void){

        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["complaintType":complaintType,"description":description,"disposition":disposition,"payuBillerId": payuBillerId, "refId": refId]
        
        print(param)
                
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.RAISE_COMPLAIN, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ServerErrorModel.self, from: response.responseData!)
                Utilities.sharedInstance.showAlertView(title: "", message: json?.message ?? "")
                completion(true)
            }
        }
    }
}
