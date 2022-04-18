//
//  SignupViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 05/07/21.
//

import UIKit
import Alamofire

class SignupViewModel: NSObject {
    //Remain
    // MARK: - Signup validation and Signup api integration
    func hitSignupApi(request: Signup_Param,completion:@escaping() -> Void){
        
        if request.firstName!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_Firstname)
            return
        }
        
        if request.firstName!.count < 3{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_FirstnameLength)
            return
        }
        
        if request.lastName!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_Lastname)
            return
        }
        
        if request.lastName!.count < 3{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_LastnameLength)
            return
        }
        
        if request.username!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_Username)
            return
        }
        
        if request.username!.count < 3{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_UsernameLength)
            return
        }
        
        if request.phoneNumber!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_MobileNumber)
            return
        }
        
        if request.phoneNumber!.count < 10{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_InvalidNumber)
            return
        }
        
        if request.email!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_Email)
            return
        }
        
        if !Utilities.sharedInstance.isValidEmail(request.email!){
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_InvalidEmail)
            return
        }
        
        if request.password!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_Password)
            return
        }
        
        if !Utilities.sharedInstance.isValidPassword(request.password!){
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_PasswordRegex)
            return
        }
        
        if request.confirmPassword!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_ConfirmPassword)
            return
        }
        
        if request.password! != request.confirmPassword!{
            Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_PasswordNotMatch)
            return
        }
        
        let param = ["firstName":request.firstName!,
                     "lastName":request.lastName!,
                     "username":request.username!,
                     "phoneNumber": request.phoneNumber!,
                     "email":request.email!,
                     "password":request.password!,
                     "confirmPassword":request.confirmPassword!]
        
        let headers: HTTPHeaders = [HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.SIGNUP, method: .post, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ServerErrorModel.self, from: response.responseData!)
                Utilities.sharedInstance.showAlertView(title: "", message: json?.message ?? "")
                completion()
            }
        }
    }
    
}
