//
//  ProfileViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/07/21.
//

import UIKit
import Alamofire

class ProfileViewModel: NSObject {
    
    var isChangePassword = Bool()
    
    //Remain
    // MARK: - Call api to send Users Profile
    func hitUserProfileApi(request: UserProfile_Param,completion:@escaping() -> Void){
        
        if request.username!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Username)
            return
        }
        
        if request.firstName!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_MobileNumber)
            return
        }
        
        if request.email!.isEmpty{
            Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Email)
            return
        }
        
        if isChangePassword == true{
            if request.password!.isEmpty{
                Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_Password)
                return
            }
            
            if request.confirmPassword!.isEmpty{
                Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_ConfirmPassword)
                return
            }
            
            if request.password! != request.confirmPassword!{
                Utilities.sharedInstance.showAlertView(title: "",message: Constant.Error_PasswordNotMatch)
                return
            }
        }
        
        let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                    HeaderValue.ContentType:HeaderValue.ContentValue,
                                    HeaderValue.TenantName:HeaderValue.TenantValue]
        
        let param = ["firstName":request.firstName!,
                     "lastName":request.lastName!,
                     "email":request.email!,
                     "username":request.username!,
                     "password":request.password!,
                     "confirmPassword":request.confirmPassword!,
                     "role":request.role!,
                     "profilePicUrl": request.profilePicUrl!]
                        
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let body : ParameterEncoding = Utilities.MyCustomEncoding(data: data)
        
        let requestHelper = RequestHelper(url: API.USER_PROFILE, method: .put, encoding: body, headers: headers)
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                completion()
            }
        }
    }
    
    
    
    //Remain
    // MARK: - Call api to send Users Profile
    func postUserProfile(base64String:String , completion : @escaping (_ response:NSDictionary) -> Void){
        if TSPService.isConnectedToInternet(){
            Utilities.sharedInstance.showSVProgressHUD()
            
            AF.request(API.PROFILE_UPLOAD, method: .put, encoding: base64String)
                .validate()
                .responseJSON { response in
                    Utilities.sharedInstance.dismissSVProgressHUD()
                    switch (response.result) {
                    case .success(let value):
                        if let json = value as? NSDictionary{
                            completion(json)
                        }
                    case .failure(let error):
                        Utilities.sharedInstance.showAlertView(title: "",message: error.localizedDescription)
                    }
                }
        }else{
            Utilities.sharedInstance.showAlertView(title: Constant.InternetErrorTitle, message: Constant.InternetErrorDescription)
        }
    }
}
