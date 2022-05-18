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
    
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var imgVwFirstNameEditIcon: UIImageView!
    @IBOutlet weak var imgVwLastNameEditIcon: UIImageView!
    @IBOutlet weak var btnFirstNameEdit: UIButton!
    @IBOutlet weak var btnLastNameEdit: UIButton!
    
    @IBOutlet weak var txtFirstName: UITextField!
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
    let homeViewModel = HomeViewModel()
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
    
    @IBAction func buttonEditFirstName(_ sender: UIButton) {
        self.txtFirstName.isUserInteractionEnabled = true
        self.txtFirstName.becomeFirstResponder()
        self.btnDone.isHidden = false
        sender.isHidden = true
        self.imgVwFirstNameEditIcon.isHidden = true
    }
    
    @IBAction func buttonEditLastName(_ sender: UIButton) {
        self.txtLastName.isUserInteractionEnabled = true
        self.txtLastName.becomeFirstResponder()
        self.btnDone.isHidden = false
        sender.isHidden = true
        self.imgVwLastNameEditIcon.isHidden = true
    }
    
    
    func setData(){
        self.lblName.text = "\(dicOfUserProfile.firstName ?? "") \(dicOfUserProfile.lastName ?? "")"
        self.lblMobileNumber.text = dicOfUserProfile.phoneNumber
        self.txtUserName.text = dicOfUserProfile.username
        self.txtFirstName.text = "\(dicOfUserProfile.firstName ?? "")"
        self.txtLastName.text = "\(dicOfUserProfile.lastName ?? "")"
        self.txtMobileNumber.text = dicOfUserProfile.phoneNumber
        self.txtEmail.text = dicOfUserProfile.email
        
        btnDone.setTitleColor(Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor), for: .normal)
        self.navigationController?.navigationItem.titleView?.tintColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
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
            self.putUserProfile(finalURL: dicOfUserProfile.profilePicUrl ?? "") {
                print("Done")
            }
        }
    }
    
    private func putUserProfile(finalURL:String,complition:(() -> Void)?) {
        
        let firstname = self.txtFirstName.text ?? ""
        let lastname = self.txtLastName.text ?? ""
                
        let request = UserProfile_Param(firstName: firstname, lastName: lastname, email: self.txtEmail.text!, username: self.txtUserName.text!, password: self.txtNewPassword.text!, confirmPassword: self.txtConfirmPassword.text!, phoneNumber: dicOfUserProfile.phoneNumber, profilePicUrl: finalURL)
        
        profileViewModel.hitUserProfileApi(request: request) {
            self.homeViewModel.getUserProfile { success in
                self.txtFirstName.isUserInteractionEnabled = false
                self.txtLastName.isUserInteractionEnabled = false
                self.imgVwFirstNameEditIcon.isHidden = false
                self.imgVwLastNameEditIcon.isHidden = false
                self.btnFirstNameEdit.isHidden = false
                self.btnLastNameEdit.isHidden = false
                self.setData()
                self.btnDone.isHidden = true
                print("Done")
            }
            
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
            self.scrollViewHeight.constant = self.scrollViewHeight.constant + 240
            self.imageChangePasswordUpDownArrow.image = #imageLiteral(resourceName: "ic_up")
        }else{
            sender.tag = 0
            profileViewModel.isChangePassword = false
            self.changePasswordView.isHidden = true
            self.changePasswordHeight.constant = 60
            self.scrollViewHeight.constant = self.scrollViewHeight.constant - 240
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
