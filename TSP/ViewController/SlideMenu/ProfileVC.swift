//
//  ProfileVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/07/21.
//

import UIKit

class ProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewMobileNumber: UIView!
    @IBOutlet weak var viewEmail: UIView!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var changePasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var imageChangePasswordUpDownArrow: UIImageView!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    var imagePicker = UIImagePickerController()

    let profileViewModel = ProfileViewModel()
    var isProfileChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        DispatchQueue.main.async {
            self.setData()
//        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonEditUserName(_ sender: Any) {
        self.txtUserName.becomeFirstResponder()
        self.btnDone.isHidden = false
    }
    
    
    func setData(){
        self.lblName.text = dicOfUserProfile.firstName
        self.lblMobileNumber.text = dicOfUserProfile.username
        self.txtUserName.text = "\(dicOfUserProfile.firstName ?? "") \(dicOfUserProfile.lastName ?? "")"
        self.txtMobileNumber.text = dicOfUserProfile.username
        self.txtEmail.text = dicOfUserProfile.email
    }
        
    @IBAction func buttonHandlerDone(_ sender: Any) {
        if self.isProfileChanged == true{
            if let imageData = self.imageProfile.image!.jpeg(.medium) {
                let strBase64:String = imageData.base64EncodedString()
                self.profileViewModel.postUserProfile(base64String: strBase64) { response in
                    print(response)
                    if let str = response.value(forKey: "uploadURL")as? String{
                        let ary = str.components(separatedBy: "?")
                        let finalURL = ary[0]
                        self.putUserProfile(finalURL: finalURL) {
                            print("Done")
                        }
                    }
                }
            }
        }else{
            self.putUserProfile(finalURL: "") {
                print("Done")
            }
        }
    }
    
    private func putUserProfile(finalURL:String,complition:(() -> Void)?) {
        
        let name = self.txtMobileNumber.text!
        
        var firstname = ""
        var lastname = ""
        
        if name.contains(" "){
            let ary = name.components(separatedBy: " ")
            firstname = ary[0]
            lastname = ary[1]
        }else{
            firstname = name
        }
        
        let request = UserProfile_Param(firstName: firstname, lastName: lastname, email: self.txtEmail.text!, username: self.txtUserName.text!, password: self.txtNewPassword.text!, confirmPassword: txtConfirmPassword.text!, role: "Customer", profilePicUrl: finalURL)
        
        profileViewModel.hitUserProfileApi(request: request) {
            print("Done")
        }
        
    }
    
    @IBAction func buttonHandlerChoosePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        //uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.imageProfile.image = image
        self.isProfileChanged = true
        self.btnDone.isHidden = false
    }
    
    
    @IBAction func buttonHandlerChangePassword(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            profileViewModel.isChangePassword = true
            self.changePasswordView.isHidden = false
            self.changePasswordHeight.constant = 300
            self.scrollViewHeight.constant = 870
            self.imageChangePasswordUpDownArrow.image = #imageLiteral(resourceName: "ic_up")
        }else{
            sender.tag = 0
            profileViewModel.isChangePassword = false
            self.changePasswordView.isHidden = true
            self.changePasswordHeight.constant = 60
            self.scrollViewHeight.constant = 630
            self.imageChangePasswordUpDownArrow.image = #imageLiteral(resourceName: "ic_down")
        }
    }
    
    @IBAction func buttonHandlerLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: Constant.Access_Token)
            let nextVC = AUTHORIZATION_STORYBOARD.instantiateViewController(withIdentifier: "LoginVC")as! LoginVC
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in}
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
        
    }
   
    
}
