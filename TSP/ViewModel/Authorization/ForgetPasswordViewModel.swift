//
//  ForgetPasswordViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 23/11/21.
//

import Alamofire
import Foundation

class ForgetPasswordViewModel: NSObject {
    
    var forgotPasswordMsg: String = ""
    //Remain
    // MARK: - Forgot password validation and forgot password api integration
    func hitForgotPasswordApi(request: ForgotPassword_Param,completion:@escaping() -> Void){
        
        if request.username!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_EnterValue)
            return
        }
                
        let param = ["username":request.username!]
        
        let headers: HTTPHeaders = [HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.FORGOT_PASSWROD, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ServerErrorModel.self, from: response.responseData!)
                self.forgotPasswordMsg = json?.message ?? ""
                if request.isDisplayAler ?? true {
                    Utilities.sharedInstance.showAlertView(title: "", message: json?.message ?? "")
                }
                completion()
            }
        }
    }
    
    
    
    
    
    
}
