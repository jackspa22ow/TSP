//
//  LoginVC.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblSignup: UILabel!
    
    let loginViewModel = LoginViewModel()
    let splashViewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.txtUsername.text = "jack"
//        self.txtPassword.text = "Pentagon@123"
        
        self.txtUsername.text = "TusharG"
        self.txtPassword.text = "!Tushar@25890"
//        
//        self.txtUsername.text = "tushargabani@gmail.com"
//        self.txtPassword.text = "!Tushar@25890"
        
//        self.txtUsername.text = "9876543210"
//        self.txtPassword.text = "Test@123"
        
//        self.txtUsername.text = "Ankur.."
//        self.txtPassword.text = "Pentagon@123"
        
        
        //hide Keyboard on click of anywhere
        self.hideKeyboardWhenTappedAround()
        
        //setup theme based app
        self.setupTheme()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTheme(){
                
        let fileUrl = URL(string: TSP_ClientLogo)
        self.imgLogo.sd_setImage(with: fileUrl)
        
        self.btnForgotPassword.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
        
        self.btnLogin.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        self.txtUsername.placeholder = TSP_Allow_Login.capitalized
        
        let value = "Don't have an account yet? Sign Up"
        let attrString = NSMutableAttributedString.init(string:value)
        let nsRange = NSString(string: value).range(of: "Sign Up", options: String.CompareOptions.caseInsensitive)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), NSAttributedString.Key.font: Utilities.AppFont.black.size(14) as Any], range: nsRange)
        self.lblSignup.attributedText = attrString
    }
    
    @IBAction func buttonHandlerLogin(_ sender: UIButton) {
        
        let request = Login_Param(username: self.txtUsername.text!, password: self.txtPassword.text)
        
        self.loginViewModel.hitLoginApi(request: request) {
            let nextVC = DASHBOARD_STORYBOARD.instantiateViewController(withIdentifier: "TabBarVC")as! TabBarVC
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    @IBAction func buttonHandlerSignUp(_ sender: UIButton) {
        let nextVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "SignupVC")as! SignupVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func buttonHandlerForgotPassword(_ sender: UIButton) {
        let nextVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "ForgetPasswordVC")as! ForgetPasswordVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
