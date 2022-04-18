//
//  ForgetPasswordVC.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnForgetPassword: UIButton!

    @IBOutlet weak var lblBackToLogin: UILabel!
    @IBOutlet weak var txtUserName: TSPTextField!
    
    let forgetPasswordViewModel = ForgetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide Keyboard on click of anywhere
        self.hideKeyboardWhenTappedAround()

        //setup theme based app
        self.setupTheme()
        
    }
    
    func setupTheme(){
                
        let fileUrl = URL(string: TSP_ClientLogo)
        self.imgLogo.sd_setImage(with: fileUrl)

        self.btnForgetPassword.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        self.lblBackToLogin.font = Utilities.AppFont.black.size(14)
        self.lblBackToLogin.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)

    }
    
    @IBAction func btnSendEmailAction(_ sender: Any) {
        let request = ForgotPassword_Param(username: self.txtUserName.text!, isDisplayAler: true)
        self.forgetPasswordViewModel.hitForgotPasswordApi(request: request) {
            self.txtUserName.text = ""
        }
    }
    
    @IBAction func btnBackToLoginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
