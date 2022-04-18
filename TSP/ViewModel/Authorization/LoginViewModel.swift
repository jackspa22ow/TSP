//
//  LoginViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 05/07/21.
//

import UIKit
import Alamofire
                                                                     
class LoginViewModel: NSObject {
    
    // MARK: - Login validation and login api integration
    func hitLoginApi(request: Login_Param,completion:@escaping() -> Void){
        
        if TSP_Allow_Login != "Email"{
            if request.username!.isEmpty{
                Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Username)
                return
            }
            
            if request.username!.count < 3{
                Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_UsernameLength)
                return
            }
        }else{
            if request.username!.isEmpty{
                Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Email)
                return
            }
            
            if !Utilities.sharedInstance.isValidEmail(request.username!){
                Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_InvalidEmail)
                return
            }
        }
        
        if request.password!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Password)
            return
        }

        let param = ["username":request.username!,
                     "password":request.password!]
        
        let headers: HTTPHeaders = [HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)

        let requestHelper = RequestHelper(url: API.LOGIN, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(LoginModel.self, from: response.responseData!)
                print("Access Token is: \(json?.access_token ?? "")")
                UserDefaults.standard.setValue(json?.access_token, forKey: Constant.Access_Token)
                completion()
            }
        }
    }
    
    
    // MARK: - CustomSSO Login
    func hitCustomSSOLoginApi(request: CustomSSO_Login_Param,completion:@escaping() -> Void){

        let param = ["authKey":request.authKey!,
                     "custId":request.custId!,
                     "tenantName":request.tenantName!,
                     "token":request.token!]
        
        let headers: HTTPHeaders = [HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)

        let requestHelper = RequestHelper(url: API.SSO, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(LoginModel.self, from: response.responseData!)
                UserDefaults.standard.setValue(json?.access_token, forKey: Constant.Access_Token)
                completion()
            }
        }
    }
    
}



