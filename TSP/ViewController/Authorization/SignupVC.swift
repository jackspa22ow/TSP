//
//  SignupVC.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class SignupVC: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnSignup: UIButton!
    
    let signupViewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide Keyboard on click of anywhere
        self.hideKeyboardWhenTappedAround()
        
        //setup theme based app
        self.setupTheme()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTheme(){
        
        let fileUrl = URL(string: TSP_ClientLogo)
        self.imgLogo.sd_setImage(with: fileUrl, placeholderImage: UIImage(named: "ic_logo"))

        self.btnSignup.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        let value = "Already have an account? Login"
        let attrString = NSMutableAttributedString.init(string:value)
        let nsRange = NSString(string: value).range(of: "Login", options: String.CompareOptions.caseInsensitive)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), NSAttributedString.Key.font: Utilities.AppFont.black.size(14) as Any], range: nsRange)
        self.lblLogin.attributedText = attrString
        
    }
    
    @IBAction func buttonHandlerSignUp(_ sender: UIButton) {
 
        let request = Signup_Param(firstName: self.txtFirstName.text!, lastName: self.txtLastName.text!, username: self.txtUserName.text!, phoneNumber: self.txtMobileNumber.text!, email: self.txtEmail.text!, password: self.txtPassword.text!, confirmPassword: self.txtConfirmPassword.text!)
        
        signupViewModel.hitSignupApi(request: request) {
            self.txtFirstName.text = ""
            self.txtLastName.text = ""
            self.txtUserName.text = ""
            self.txtMobileNumber.text = ""
            self.txtEmail.text = ""
            self.txtPassword.text = ""
            self.txtConfirmPassword.text = ""
        }
    }
    
    @IBAction func buttonHandlerLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
}



extension SignupVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtMobileNumber{
            let maxLength = 10
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
