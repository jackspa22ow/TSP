//
//  TSPTests.swift
//  TSPTests
//
//  Created by Ankur Kathiriya on 13/01/22.
//

import XCTest
@testable import TSP

class TSPTests: XCTestCase {
    
    var validation : ValidationService!
    var groupDisplayCategory: GroupDisplayCategory!
    //    var tspTestConstant = TSPTestConstant()
    override func setUp() {
        super.setUp()
        validation = ValidationService()
        
    }
    
    override func tearDown() {
        super.tearDown()
        validation = nil
    }
    
    func test_01_is_valid_username() throws {
        XCTAssertNoThrow(try validation.validateUsername("Ankur Kathiriya"))
    }
    
    func test_02_is_valid_password() throws {
        XCTAssertNoThrow(try validation.validatePassword("123456789"))
    }
    
    func test_03_LoginAPI() throws {
        UserDefaults.standard.removeObject(forKey: "access_token")
        
        let request = Login_Param(username: "Ankur..", password: "Pentagon@123")
        let loginViewModel = LoginViewModel()
        let expectation = self.expectation(description: "LoginAPI")
        
        loginViewModel.hitLoginApi(request: request) {
            let token = UserDefaults.standard.value(forKey: "access_token")as! String
            XCTAssert(token.count > 0, "Token should not be empty.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5 , handler: nil)
    }
    
    func test_04_GetListOfGroups() throws {
        let expectation = self.expectation(description: "test_04_GetListOfGroups")
        
        let homeViewModel = HomeViewModel()
        homeViewModel.getListOfGroups { success in
            print("getListOfGroups api")
            var displayCategories = [GroupDisplayCategory]()
            
            for dicGroupsContent in homeViewModel.dicOfGroups! {
                if let categoryArray = dicGroupsContent.displayCategories {
                    displayCategories += categoryArray
                }
            }
            print("Totala count:\(displayCategories.count)")
            XCTAssert(displayCategories.count >= 0, "Issue while fetch category")
            //            self.groupDisplayCategory = displayCategories[0]
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_05_GetUserProfile() throws {
        let expectation = self.expectation(description: "test_05_GetUserProfile")
        
        let homeViewModel = HomeViewModel()
        homeViewModel.getUserProfile() {success in
            print("First Name:%@", (dicOfUserProfile.firstName ?? ""))
            print("Last Name:%@", (dicOfUserProfile.lastName ?? ""))
            
            XCTAssert((dicOfUserProfile.firstName ?? "").count > 0, "First name should not be empty.")
            XCTAssert((dicOfUserProfile.lastName ?? "").count > 0, "Last name should not be empty.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_06_GetBanners() throws {
        let expectation = self.expectation(description: "test_06_GetBanners")
        
        let homeViewModel = HomeViewModel()
        homeViewModel.getBanners() {success in
            print("Banner Count:%@", homeViewModel.aryOfBannerList.count)
            
            XCTAssert(homeViewModel.aryOfBannerList.count > 0, "Banner should not be empty.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_07_GetMyBills() throws {
        let expectation = self.expectation(description: "test_07_GetMyBills")
        
        let homeViewModel = HomeViewModel()
        homeViewModel.getMyBills() {success in
            XCTAssert(homeViewModel.dicOfMyBillList != nil, "Bills should not be nill.")
            XCTAssert(homeViewModel.dicOfMyBillList.content.count > 0, "My bills count should be greater then zero.")
            print("My Bill:\(homeViewModel.dicOfMyBillList.content.count)")
            
            
            myBillIDTestCase = "\(homeViewModel.dicOfMyBillList.content[0].id ?? 0)"
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_08_GetBillerByName() throws {
        let expectation = self.expectation(description: "test_08_GetBillerByName")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getBillers(name: "EDUCATION") { success in
            print(addBillerViewModel.dicOfBillerList.content.count)
            XCTAssert(addBillerViewModel.dicOfBillerList.content.count > 0, "Billers should not be nill.")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_09_GetOperatorCircleInfo() throws {
        let expectation = self.expectation(description: "test_09_GetOperatorCircleInfo")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getOperatorCircleInfo(phoneNumer: "+918866639059") { success in
            
            if let operatorCode = addBillerViewModel.dicOfOperatorCircleInfo.payload.operatorCode {
                operatorCodeForTestCase = operatorCode
                print("Operator Code:\(operatorCodeForTestCase ?? "")")
                XCTAssert(operatorCode.count > 0, "Operator Code should not be nill.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_10_GetAllOperators() throws {
        let expectation = self.expectation(description: "test_10_GetAllOperators")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getAllOperators(completion: { success in
            
            let operatorObj = addBillerViewModel.dicOfOperator.content[0]
            let operatorName = operatorObj.operatorName ?? ""
            operatorCodeForTestCase = operatorObj.operatorCode
            print("Operator Name:\(operatorName)")
            XCTAssert(operatorName.count > 0, "Operator name should not be nill.")
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_11_GetAllCircles() throws {
        let expectation = self.expectation(description: "test_11_GetAllCircles")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getAllCircles(operatorId: operatorCodeForTestCase ?? "") { success in
            let circleName = addBillerViewModel.dicOfCircles.content[0].circleName ?? ""
            print("Circle name: \(circleName)")
            circleIdForTestCase = addBillerViewModel.dicOfCircles.content[0].circleId ?? ""
            
            XCTAssert(circleName.count > 0, "Circle name should not be nill.")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_12_GetGetPlanTypes() throws {
        let expectation = self.expectation(description: "test_12_GetGetPlanTypes")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getGetPlanTypes(circleId: circleIdForTestCase ?? "", operatorId: operatorCodeForTestCase ?? "") { success in
            
            planTypeForTestCase = addBillerViewModel.dicOfPlanTypes.content[0] ?? ""
            print("Plan type:\(planTypeForTestCase)")
            XCTAssert(planTypeForTestCase.count > 0, "Plan type should not be nill.")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_13_GetRechargePlans() throws {
        let expectation = self.expectation(description: "test_13_GetRechargePlans")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getRechargePlans(circleId: circleIdForTestCase ?? "", operatorId: operatorCodeForTestCase ?? "", planTypeSearch: planTypeForTestCase ?? "") { success in
            
            let planName = addBillerViewModel.dicOfRechargePlans.content[0].planName ?? ""
            let price = addBillerViewModel.dicOfRechargePlans.content[0].price ?? ""
            let validity = addBillerViewModel.dicOfRechargePlans.content[0].validity ?? ""
            
            print("Plan name:\(planName)")
            print("Price:\(price)")
            print("Validity:\(validity)")
            planIDForTestCase = "\(addBillerViewModel.dicOfRechargePlans.content[0].id ?? 0)"
            XCTAssert(planName.count > 0, "Plan name should not be nill.")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_14_GetPlanDetailByPlanID() throws {
        let expectation = self.expectation(description: "test_14_GetPlanDetailByPlanID")
        
        let addBillerViewModel = AddBillerViewModel()
        addBillerViewModel.getPlanDetailByPlanID(planId: planIDForTestCase) { success in
            
            print("Operator Name:\(addBillerViewModel.dicOfPlanDetailByPlanID.operatorName ?? "")")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_15_GetNotificationList() throws {
        let expectation = self.expectation(description: "test_15_GetNotificationList")
        
        let str = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let fromDate = str!.string(format: Utilities.sharedInstance.historyDateFormate)
        
        let toDate = Date().string(format: Utilities.sharedInstance.historyDateFormate)
        
        let notificationListViewModel = NotificationListViewModel()
        notificationListViewModel.getNotificationList(fromDate: fromDate, toDate: toDate) { success in
            
            print("Notification Count:\(notificationListViewModel.dicOfNotification.content.count)")
            print("Notification Name:\(notificationListViewModel.dicOfNotification.content[0].name ?? "")")
            XCTAssert(notificationListViewModel.dicOfNotification.content.count > 0, "Notification should not be nill")
            XCTAssert((notificationListViewModel.dicOfNotification.content[0].name ?? "").count > 0, "Notification name should not be nill")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
        
    }
    
    func test_16_getDateFormatFromPlaceholder() throws {
        let testDate1 = "BillingDate(yyyy-MM-dd)"
        let testDate2 = "BillingDate(yyyy-MM-DD)"
        let testDate3 = "yyyy-MM-dd"
        let testDate4 = "BillingDate(yyyy*MM*dd)"
        let testDate5 = "BillingDate_YYYY-MM-dd"
        let testDate6 = ""
        
        let vc = BillerCategoryStep3ItemCell()
        
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate1) == "yyyy-MM-dd", "Issue while get date formater.");
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate2) == "yyyy-MM-dd", "Issue while get date formater.");
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate3) == "dd-MM-YYYY", "Issue while get date formater.");
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate4) == "yyyyMMdd", "Issue while get date formater.");
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate5) == "dd-MM-YYYY", "Issue while get date formater.");
        XCTAssert(vc.getDateFormatFromPlaceholder(value: testDate6) == "dd-MM-YYYY", "Issue while get date formater.");
    }
    
    func test_17_GetServiceGroup() throws {
        let expectation = self.expectation(description: "test_17_GetServiceGroup")
        
        let historyViewModel = HistoryViewModel()
        
        historyViewModel.getServiceGroup { response in
            
            XCTAssert(historyViewModel.aryOfServiceGroupList.count > 0, "History service group array should not be nill")
            XCTAssert(historyViewModel.aryOfServiceGroupList[0].groupName?.count ?? 0 > 0, "History service group should not be nill")
            serviceGroupName = historyViewModel.aryOfServiceGroupList[0].groupName ?? ""
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_18_FetchServiceQuestion() throws {
        let expectation = self.expectation(description: "test_18_FetchServiceQuestion")
        
        let historyViewModel = HistoryViewModel()
        
        historyViewModel.getServiceQuestion(groupName: serviceGroupName) { response in
            
            XCTAssert(historyViewModel.aryOfServiceQuestionList.count > 0, "History service group question array should not be nill")
            
            XCTAssert(historyViewModel.aryOfServiceQuestionList[0].question?.count ?? 0 > 0, "History service group question should not be nill")
            
            XCTAssert(historyViewModel.aryOfServiceQuestionList[0].answer?.count ?? 0 > 0, "History service group answer should not be nill")

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_19_GetClientConfiguration() throws {
        let expectation = self.expectation(description: "test_15_GetNotificationList")
        
        let splashViewModel = SplashViewModel()
        
        splashViewModel.getClientConfiguration {
            
            XCTAssert(TSP_ClientName.count > 0, "Issue while fetch client configuration")
            XCTAssert(TSP_ClientLogo.count > 0, "Issue while fetch client configuration")

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_20_HitCustomSSO() throws {
        let expectation = self.expectation(description: "test_20_HitCustomSSO")
        
        let loginViewModel = LoginViewModel()
        
        var number = String()
        for _ in 1...10 {
            number += "\(Int.random(in: 1...9))"
        }
        let custID = number
        let request = CustomSSO_Login_Param(authKey: TSP_AuthKey, custId: custID, tenantName: HeaderValue.TenantValue, token: TSP_SSOTOKEN)
        
        loginViewModel.hitCustomSSOLoginApi(request: request) {
            
            let token = UserDefaults.standard.value(forKey: Constant.Access_Token)as! String
            XCTAssert(token.count > 0, "Issue while fetch Access token")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_21_HitForgotPasswordApi() throws {
        
        let expectation = self.expectation(description: "test_21_HitForgotPasswordApi")

        let request = ForgotPassword_Param(username: "8866639039", isDisplayAler: false)
        
        let forgetPasswordViewModel = ForgetPasswordViewModel()

        forgetPasswordViewModel.hitForgotPasswordApi(request: request) {
            print(forgetPasswordViewModel.forgotPasswordMsg)
            XCTAssert(forgetPasswordViewModel.forgotPasswordMsg.count > 0, "Issue while forgot password msg")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }
    
    func test_22_GetReminderSubType() throws {
        
        let expectation = self.expectation(description: "test_22_GetReminderSubType")
        
        let reminderListViewModel = ReminderListViewModel()

        reminderListViewModel.getReminderSubType { response in
            XCTAssert(reminderListViewModel.dicOfReminderSubtype.payload?.count ?? 0 > 0, "Issue while fetch reminder subtype")
            
            print(reminderListViewModel.dicOfReminderSubtype.payload?[0].eventSubTypes ?? "")

            XCTAssert(reminderListViewModel.dicOfReminderSubtype.payload?[0].eventSubTypes?.count ?? 0 > 0, "Event subtype should not be nil")

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60 , handler: nil)
    }

    
    
    //    func test_08_GetReminderByBillID() throws {
    //        let expectation = self.expectation(description: "test_08_GetReminderByBillID")
    //        let reminderListViewModel = ReminderListViewModel()
    //
    //        reminderListViewModel.getReminderByBillID(billID: "\(myBillIDTestCase ?? "")", completion: { response in
    //
    //            let payload = reminderListViewModel.dicOfReminderByBill.payload?.filter{ $0.isEnable == true }
    //
    //            XCTAssert((payload?.count ?? 0) > 0, "Auto pay detail id should not be nil")
    ////            print("My bill auto pay detail id:\(homeViewModel.dicOfMyBillAutoPayDetail?.id ?? 0)")
    //
    //            expectation.fulfill()
    //        })
    //        waitForExpectations(timeout: 60 , handler: nil)
    //    }
    //
    //
    //    func test_08_GetBillAutoPayDetailByBillID() throws {
    //        let expectation = self.expectation(description: "test_08_GetBillAutoPayDetailByBillID")
    //        let homeViewModel = HomeViewModel()
    //
    //        homeViewModel.getBillAutoPayDetailByBillID(billID: "\(myBillIDTestCase ?? "")", completion: { response in
    //            XCTAssert((homeViewModel.dicOfMyBillAutoPayDetail?.id ?? 0) > 0, "Auto pay detail id should not be nil")
    //            print("My bill auto pay detail id:\(homeViewModel.dicOfMyBillAutoPayDetail?.id ?? 0)")
    //
    //            expectation.fulfill()
    //        })
    //        waitForExpectations(timeout: 60 , handler: nil)
    //    }
    
    
    
}
