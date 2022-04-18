//
//  SplashViewModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 05/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD


class SplashViewModel: NSObject {
    
    // MARK: - client config api integration
    func getClientConfiguration(completion : @escaping () -> Void){
        
        let headers: HTTPHeaders = [HeaderValue.TenantName:HeaderValue.TenantValue]
        let requestHelper = RequestHelper(url: API.GET_CLIENT_CONFIG, method: .get, headers: headers)
        
        TSPService.sharedInstance.request(with: requestHelper) { response in
            if response.error != nil{
                Utilities.sharedInstance.showAlertView(title: "", message: response.error!.localizedDescription)
            }else{
                let json = try? JSONDecoder().decode(ClientConfiguration.self, from: response.responseData!)
                
                TSP_ClientName = json?.name ?? "PayU India"
                TSP_ClientLogo = json?.logo ?? "https://tsp-media.s3.ap-south-1.amazonaws.com/1633886690471.jpg"
                
                let totalConfig = json?.clientConfigs.count ?? 0
                for i in 0..<totalConfig{
                    let dic = json?.clientConfigs[i]
                    let name = dic?.name
                    
                    if name == "--primary-color"{
                        TSP_PrimaryColor = dic?.value ?? "40B895"
                    }
                    
                    if name == "--dark-mode"{
                        TSP_DARK_MODE = dic?.value ?? "C2F0E2"
                    }
                    
                    if name == "--secondary-color"{
                        TSP_SecondaryColor = dic?.value ?? "C2F0E2"
                    }
                    
                    if name == "--font-name"{
                        TSP_Font_Name = dic?.value ?? "Email"
                    }
                    
                    if name == "allowlogin"{
                        TSP_Allow_Login = dic?.value ?? "Email"
                    }
                    
                    if name == "allow_setting_reminders"{
                        TSP_Allow_Setting_Reminders = dic?.value ?? "default"
                    }

                    if name == "allow_setting_autopay"{
                        TSP_Allow_Setting_Autopay = dic?.value ?? "default"
                    }
                    
                    if name == "can_customer_edit_payment_date"{
                        TSP_Can_Customer_edit_Paymentdate = dic?.value ?? "default"
                    }
                    
                    if name == "allow_add_terms_conditions"{
                        TSP_Allow_Add_Terms_Conditions = dic?.value ?? "default"
                    }
                    
                    if name == "standing_instruction"{
                        TSP_Standing_Instruction = dic?.value ?? "default"
                    }
                    
                    if name == "allow_adding_banners"{
                        TSP_Allow_Adding_Banners = dic?.value ?? "default"
                    }
                    
                    if name == "allow_multiple_bill_pay"{
                        TSP_Allow_Multiple_Billpay = dic?.value ?? "default"
                    }
                    
                    if name == "sso_type"{
                        TSP_SSO_TYPE = dic?.value ?? "default"
                    }
                    
                    if name == "sso_auth_url"{
                        TSP_SSO_Auth_Url = dic?.value ?? "default"
                    }
                    
                    if name == "sso_verify_url"{
                        TSP_SSO_Verify_Url = dic?.value ?? "default"
                    }
                    
                    if name == "sso_logout_url"{
                        TSP_SSO_Logout_Url = dic?.value ?? "default"
                    }
                    
                    if name == "hide_header"{
                        TSP_Hide_Header = dic?.value ?? "default"
                    }
                    
                    if name == "spend_analysis"{
                        TSP_Spend_Analysis = dic?.value ?? "default"
                    }
                    
                    if name == "CUSTOM_PAYMENT_URL"{
                        TSP_Custom_Payment_Url = dic?.value ?? "default"
                    }
                }
                completion()
            }
        }
    }
    
}

