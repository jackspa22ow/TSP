//
//  SplashVC.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class SplashVC: UIViewController {
    
    let splashViewModel = SplashViewModel()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch client config data
        self.getClinetConfiguration()
    }
    
    func getClinetConfiguration(){
        self.splashViewModel.getClientConfiguration{
//            if TSP_SSO_TYPE == "custom"{
//                self.customSSOLogin()
//            }else{
//                if let _ = UserDefaults.standard.value(forKey: Constant.Access_Token)as? String{
//                    let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "TabBarVC")as! TabBarVC
//                    self.navigationController?.pushViewController(nextVC, animated: false)
//                }else{
//                    let nextVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "LoginVC")as! LoginVC
//                    self.navigationController?.pushViewController(nextVC, animated: false)
//                }
//            }
                        
            if let _ = UserDefaults.standard.value(forKey: Constant.Access_Token)as? String{
                let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "TabBarVC")as! TabBarVC
                self.navigationController?.pushViewController(nextVC, animated: false)
            }else{
                let nextVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "LoginVC")as! LoginVC
                self.navigationController?.pushViewController(nextVC, animated: false)
            }

            
        }
    }
    
    func customSSOLogin(){
        let custID = self.random(digits: 10)
        let request = CustomSSO_Login_Param(authKey: TSP_AuthKey, custId: custID, tenantName: HeaderValue.TenantValue, token: TSP_SSOTOKEN)
        
        self.loginViewModel.hitCustomSSOLoginApi(request: request) {
            let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "TabBarVC")as! TabBarVC
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    
}

