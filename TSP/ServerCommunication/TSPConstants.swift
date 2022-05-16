//
//  ServerConstants.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//


import UIKit
import Foundation


//MARK: This class created for handling Environment and API end points in Project
/*===============================================
 * Struct Purpose: -> Call this struct for getting environment stage, which is
 either developement or production.
 
 * How to Use: -> var baseURL = Environment.Development
 * ==============================================*/
struct Environment {
    static let Development = "https://api1.usprojects.co/"
    static let Production = ""
}
//===========end Struct===========================


//Base URL
var baseURL = Environment.Development


/*==============================================
 * Struct Purpose: -> Call this struct for getting API endpoints.
 
 * How to Use: -> API.Login
 * =============================================*/
struct API {
    
    //Authorization
    static let GET_CLIENT_CONFIG = baseURL + "tsp/user/v1/api/client-details"
    static let LOGIN = baseURL + "tsp-auth/users/signin"
    static let SIGNUP = baseURL + "tsp-auth/users/create"
    static let FORGOT_PASSWROD = baseURL + "tsp-auth/users/forgot"
    static let USER_PROFILE = baseURL + "tsp-auth/users/"
    static let PROFILE_UPLOAD = "https://9xcjjhqcg5.execute-api.us-east-2.amazonaws.com/default/getPresignedMediaURL"

    //Banner
    static let GET_BANNER_LIST = baseURL + "tsp/user/v1/api/client-banner/client/"
    
    //Bills
    static let GET_BILLS = baseURL + "tsp/bill-details/v1/api/bill/"
    static let DELETE_BILL = baseURL + "tsp/bill-details/v1/api/bill/"
    static let GET_SINGLE_BILL_DETAILS = baseURL + "tsp/bill-details/v1/api/payment/transaction/"
    static let POST_AUTO_PAY_FOR_BILL = baseURL + "tsp/bill-details/v1/api/si/"    
    static let GET_SINGLE_BILL_DETAILS_BY_BILL_ID_FOR_AUTOPAY = baseURL + "tsp/bill-details/v1/api/si/bill/"
    static let GET_SINGLE_BILL_DETAILS_BY_BILL_ID = baseURL + "tsp/bill-details/v1/api/bill/"
    
    //Groups
    static let GET_GROUPS = baseURL + "tsp/bill-details/v1/api/group/all"
    
    //Spend Analysis
    static let GET_SPEND_ANALYSIS_HISTORY = baseURL + "tsp/bill-details/v1/api/transaction-summary/category/all"
    static let GET_SPEND_ANALYSIS_HISTORY_LIST = baseURL + "tsp/bill-details/v1/api/transaction/search"
    
    //AutoPay
    static let GET_AUTOPAY_LIST = baseURL + "tsp/bill-details/v1/api/si/all"
    static let GET_AUTOPAY_DETAIL_BY_ID = baseURL + "tsp/bill-details/v1/api/si/"

    //Billers
    static let GET_BILLERS = baseURL + "tsp/bill-details/v1/api/biller/search?displayCategory="
    static let GET_BILLER_DETAIL = baseURL + "tsp/bill-details/v1/api/si/bill"

    //Reminder
    static let GET_REMIDER_LIST = baseURL + "tsp/bill-details/v1/api/reminders/"
    static let GET_REMINDER_BY_USER_BILL_ID = baseURL + "tsp/bill-details/v1/api/reminders/userBillId/"
    static let GET_REMINDER_OPTIONS = baseURL + "tsp/bill-details/v1/api/reminders/events/subtypes/2"
    static let PUT_REMINDER_DESABLE = baseURL + "tsp/bill-details/v1/api/reminders/"
    static let GET_REMINDERS_BY_BILL_ID = baseURL + "tsp/bill-details/v1/api/reminders/bill/"
    static let PUT_REMINDERS_BY_BILL_ID = baseURL + "tsp/bill-details/v1/api/reminders/bill/"
    static let PUT_REMINDERS_BY_BILL_DESABLE = baseURL + "tsp/bill-details/v1/api/reminders/bill/"

    //Help
    static let GET_HELP = baseURL + "tsp/user/v1/api/faq/group/"
    static let GET_HELP_DETAILS = baseURL + "tsp/user/v1/api/faq/group?groupName="
    
    //Transactions
    static let GET_ALL_TRANSACTIONS        = baseURL + "tsp/bill-details/v1/api/transaction/search"
    static let GET_SERVICE_GROUP           = baseURL + "tsp/user/v1/api/faq/group/"
    static let GET_SERVICE_QUESTION           = baseURL + "tsp/user/v1/api/faq/group?groupName="

    static let DOWNLOAD_ALL_TRANSACTIONS   = baseURL + "tsp/bill-details/v1/api/transaction/download"
    static let DOWNLOAD_SINGLE_TRANSACTION = baseURL + "tsp/bill-details/v1/api/transaction/"
    
    //Complaints
    static let GET_ALL_COMPLAINTS  = baseURL + "tsp/bill-details/v1/api/complaints/check-complaint/all"
    static let GET_COMPLAIN_DETAIL = baseURL + "tsp/bill-details/v1/api/complaints/transaction/"
    static let GET_COMPLAIN_TYPES  = baseURL + "tsp/bill-details/v1/api/complaints/messages/"
    static let RAISE_COMPLAIN      = baseURL + "tsp/bill-details/v1/api/complaints/"
    
    //Recharge
    static let GET_OPERATOR_CIRCLE_INFO = baseURL + "tsp/bill-details/v1/api/operator/operator-circle-info"
    static let GET_ALL_OPERATORS = baseURL + "tsp/bill-details/v1/api/operator/"
    static let GET_ALL_CIRCLES = baseURL + "tsp/bill-details/v1/api/mobile-prepaid/plans/circles"
    static let GET_PLAN_TYPES = baseURL + "tsp/bill-details/v1/api/mobile-prepaid/plans/types"
    static let GET_RECHARGE_PLANS = baseURL + "tsp/bill-details/v1/api/mobile-prepaid/plans"
    static let ADD_MOBILE_PREPAID_RECHARGE_BILL = baseURL + "tsp/bill-details/v1/api/bill/mobile-prepaid?isUserBill="
    static let ADD_BILLER_DATA_VALIDATION = baseURL + "tsp/bill-details/v1/api/bill/?isUserBill="

    static let GET_PLAN_DETAIL_BY_PLAN_ID = baseURL + "tsp/bill-details/v1/api/mobile-prepaid/plans/"
    
    //Payment
    static let PREPARE_PAYMENT = baseURL + "tsp/bill-details/v1/api/payment/prepare_payment"
    static let GENERATE_HASH = baseURL + "tsp/bill-details/v1/api/payment/generate/hash"
    static let VERIFY_PAYMENT = baseURL + "tsp/bill-details/v1/api/payment/verify_payment/"
    
    static let MULTIPLE_BILL_TRANSACTION_LIST = baseURL + "tsp/bill-details/v1/api/payment/transactions/list/"
    
    //SSO
    static let SSO = baseURL + "tsp-auth/v1/api/custom-sso/login"
    
    //Notification
    static let NOTIFICATION_LIST = baseURL + "tsp/bill-details/v1/api/dashboard/notifications/"
    
    //Uodate short name
    static let PUT_BILL_NICK_NAME = baseURL + "tsp/bill-details/v1/api/bill/"

}
//=============end Struct========================



//MARK: This class created for creating server response's keywords
/*==============================================================================
 * Variables Purpose: -> Use this variable for handling api response.
 
 * How to Use: ->  ServerConstants.Success
 * =============================================================================*/
struct Constant {
    static let InternetErrorTitle = "Could Not Connect"
    static let InternetErrorDescription = "Make sure you are connected to Wi-Fi or your cellular network."
    static let InternetError          = "Please check your internet connection"
    static let Error_Firstname        = "Please enter firstname"
    static let Error_FirstnameLength  = "First name should contain atleast 3 characters"
    static let Error_Lastname         = "Please enter lastname"
    static let Error_LastnameLength   = "Last name should contain atleast 3 characters"
    static let Error_Username         = "Please enter username"
    static let Error_UsernameLength   = "Username should contain atleast 3 characters"
    static let Error_Password         = "Please enter password"
    static let Error_ConfirmPassword  = "Please enter confirm password"
    static let Error_MobileNumber     = "Please enter mobile number"
    static let Error_InvalidNumber    = "Mobile number should be 10 digit"
    static let Error_Email            = "Please enter email address"
    static let Error_InvalidEmail     = "Please enter valid email address"
    static let Error_PasswordNotMatch = "Password did not match"
    static let Error_PasswordRegex    = "Password must contain at least 8 characters long, 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character"
    static let Error_Token            = "Token is invalid"
    static let Error_SomethingWrong   = "something went wrong please try again"
    static let Error_SessionExpired   = "Your session has expired. Please relogin"
    static let Access_Token           = "access_token"
    static let NoTransactionsAvailable = "No Transactions Available"
    static let NoComplaintsAvailable  = "No Complaints Available"
    static let Error_EnterValue       = "Please enter mobile number or email"
    static let User                   = "User"
    static let Client                 = "Client"
}
//===================================== end ======================================

struct HeaderValue{
    static let TenantName       = "tenantname"
    static let TenantValue      = "dlb"
    static let ContentType       = "Content-Type"
    static let ContentValue = "application/json"
    static let Authorization = "Authorization"
}


let AUTHORIZATION_STORYBOARD = UIStoryboard(name: "Authorization", bundle: nil)
let DASHBOARD_STORYBOARD = UIStoryboard(name: "Dashboard", bundle: nil)
let SLIDEMENU_STORYBOARD = UIStoryboard(name: "SlideMenu", bundle: nil)
let HELP_STORYBOARD = UIStoryboard(name: "Help", bundle: nil)
let BILLDETAILS_STORYBOARD = UIStoryboard(name: "BillDetails", bundle: nil)




//Client Configuration
var TSP_PrimaryColor = "40B895"
var TSP_SecondaryColor = "1EAD7F"
var TSP_DARK_MODE = ""
var TSP_Font_Name = ""
var TSP_Allow_Login = ""
var TSP_Allow_Setting_Reminders = ""
var TSP_Allow_Setting_Autopay = ""
var TSP_Can_Customer_edit_Paymentdate = ""
var TSP_Allow_Add_Terms_Conditions = ""
var TSP_Spend_Analysis = ""
var TSP_Standing_Instruction = ""
var TSP_Allow_Adding_Banners = ""
var TSP_Allow_Multiple_Billpay = ""
var TSP_SSO_TYPE = ""
var TSP_SSO_Auth_Url = ""
var TSP_SSO_Verify_Url = ""
var TSP_SSO_Logout_Url = ""
var TSP_Hide_Header = ""
var TSP_Custom_Payment_Url = ""









var TSP_ClientName = "PayU India"

var TSP_ClientLogo = "https://tsp-media.s3.ap-south-1.amazonaws.com/1633886690471.jpg"
var TSP_FontSize:CGFloat = 20








var SelectedCategoryForBillerFromHomeVC : GroupDisplayCategory!
var IsComplaintsMenuSelected : Bool = false


var dicOfUserProfile : UserProfile!
var IsMyBillDeleted : Bool = false




public var TSP_AuthKey = "7-f65b8223-1866-43ad-a4fa-85522a5fa053"
public var TSP_SSOTOKEN = "7-3004ce5c-1269-4f1d-ae4a-322079e3aeaec1f0a6af-d6b4-44f8-ac07-617ebb27fa467c9fa508-3c57-4568-8a32-e8241133694a"
