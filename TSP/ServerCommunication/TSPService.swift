//
//  TSPService.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/10/21.
//

import UIKit
import Alamofire

class TSPService: NSObject {
    
    static let sharedInstance: TSPService = TSPService()
  
    func request(with requestHelper: RequestHelper?,completion : ((_ response : ResponseHelper) -> Void)?) {
        
        /// Create request
        guard let requestData = requestHelper, let url = try? requestData.url.asURL() else {
            let responseData = ResponseHelper(responseData: nil, error: nil)
            completion?(responseData)
            return
        }

        /// API call
        if TSPService.isConnectedToInternet(){
            Utilities.sharedInstance.showSVProgressHUD()
            AF.request(url, method: requestData.method, parameters:requestData.parameters, encoding: requestData.encoding, headers: requestData.headers)
                .validate()
                .responseJSON {
                    response in
                    Utilities.sharedInstance.dismissSVProgressHUD()
                    
                    print("API:==> \(url)")
                    print("Body:==> \(requestData.encoding)")
                    print("Headers:==> \(requestData.headers as Any)")
                    print("Status Code:==> \(response.response?.statusCode as Any)")
                    print("Response is===>\(response.result)")

                    switch response.result {
                    case .success:
                                                
                        let responseData = ResponseHelper(responseData: response.data, error: response.error)
                        completion?(responseData)
                        break
                    case .failure(let error):
                        print(error)
                        if response.data != nil{
                            
                            if let encryptedData:Data = response.data {
                                print("Response:==> \(NSString(data: encryptedData, encoding: String.Encoding.utf8.rawValue)! as String)")
                            }
                            
                            let json = try? JSONDecoder().decode(ServerErrorModel.self, from: response.data!)
                            if let str = json?.httpStatus{
                                Utilities.sharedInstance.showAlertView(title: "", message: str)
                            }else if let str = json?.message{
                                Utilities.sharedInstance.showAlertView(title: "", message: str)
                            }else if let str = json?.debugMessage{
                                Utilities.sharedInstance.showAlertView(title: "", message: str)
                            }else{
                                Utilities.sharedInstance.showAlertView(title: "", message: Constant.Error_SomethingWrong)
                            }
                        }else{
                            UserDefaults.standard.removeObject(forKey: Constant.Access_Token)
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let loginVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            let nav = UINavigationController(rootViewController: loginVC)
                            appdelegate.window!.rootViewController = nav
                        }
                        break
                    }
                }
        }else{
            Utilities.sharedInstance.showAlertView(title: Constant.InternetErrorTitle, message: Constant.InternetErrorDescription)
        }
    }
    
    /// Internet rechability checking
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

/// Request helper struct
struct RequestHelper {
    let url: URLConvertible
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders? = nil
    
    init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders) {
        self.url = url
        self.method = method
        self.headers = headers
    }
    
    init(url: URLConvertible, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
    
    init(url: URLConvertible, method: HTTPMethod, encoding: ParameterEncoding, headers: HTTPHeaders) {
        self.url = url
        self.method = method
        self.encoding = encoding
        self.headers = headers
    }
  
    init(url: URLConvertible, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}

/// Response Helper struct
struct ResponseHelper {
    let responseData : Data?
    let error : Error?
    init(responseData : Data?, error : Error?) {
        self.responseData = responseData
        self.error = error
    }
}




