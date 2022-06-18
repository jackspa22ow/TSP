//
//  AddBillerModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import Foundation

// MARK: - AddBillerModel
struct AddBillerModel: Codable {
    let content: [AddBillerModelContent]
}

// MARK: - Contentregex
struct AddBillerModelContent: Codable {
    let id: Int?
    let billerId: String?
    let billerName: String?
    let fetchOption: String?
    let state: String?
    let flowType: String?
    let status: String?
    let billerMode: String?
    let billerEffctvTo: String?
    let supportDeemed: Bool?
    let supportPendingStatus: Bool?
    let customerParams: [AddBillerCustomerParam]
    let paymentModesAllowed: [AddBillerModelPaymentSAllowed]
    let paymentChannelsAllowed: [AddBillerModelPaymentSAllowed]
    let interchangeFee: [AddBillerModelInterchangeFee]
}

// MARK: - CustomerParam
struct AddBillerCustomerParam: Codable {
    let dataType: String?
    let maxLength: String?
    let minLength: String?
    let optional: String?
    let paramName: String?
    let visibility: Bool?
    let primary: Bool?
    var inputedValue: String?
    var regex: String?
}

// MARK: - PaymentSAllowed
struct AddBillerModelPaymentSAllowed: Codable {
    let paymentMode: String?
    let minLimit: String?
    let maxLimit: String?
}

// MARK: - InterchangeFee
struct AddBillerModelInterchangeFee: Codable {
    let feeDesc: String?
    let feeCode: String?
}

//// MARK: - AddBillerModel
//struct AddBillerModel: Codable {
//    var id: Int?
//    var billerId: String?
//    var billerName: String?
//    var fetchOption: String?
//    var state: String?
//    var flowType: String?
//    var status: String?
//    var billerMode: String?
//    var supportDeemed: Bool?
//    var supportPendingStatus: Bool?
//    var customerParams: [AddBillerCustomerParams]
//    var paymentModesAllowed: [AddBillerPaymentModesAllowed]
//    var paymentChannelsAllowed: [AddBillerPaymentChannelsAllowed]
//}
//
//// MARK: - AddBillerCustomerParam
//struct AddBillerCustomerParams: Codable {
//    var dataType: String?
//    var maxLength: String?
//    var minLength: String?
//    var optional: String?
//    var paramName: String?
//    var regex: String?
//    var visibility: Bool?
//    var primary: Bool?
//    var inputedValue: String?
//}
//
//// MARK: - AddBillerPaymentModesAllowed
//struct AddBillerPaymentModesAllowed: Codable {
//    var paymentMode: String?
//    var minLimit: String?
//}
//
//// MARK: - AddBillerPaymentModesAllowed
//struct AddBillerPaymentChannelsAllowed: Codable {
//    var paymentMode: String?
//    var minLimit: String?
//    var maxLimit: String?
//}

// MARK: - FetchedContact
struct FetchedContact {
    var firstName: String
    var lastName: String
    var telephone: String
}

// MARK: - GetOperatorCircleInfoModel
struct GetOperatorCircleInfoModel: Codable {
    let code: String?
    let status: String?
    let payload: GetOperatorCircleInfoPayload
}

// MARK: - GetOperatorCircleInfoPayload
struct GetOperatorCircleInfoPayload: Codable {
    let operatorCode: String?
    let operatorName: String?
    let circleName: String?
    let circleRefID: String?
}

// MARK: - GetAllOperatorsModel
struct GetAllOperatorsModel: Codable {
    let content: [GetAllOperatorsContent]
}

// MARK: - GetAllOperatorsContent
struct GetAllOperatorsContent: Codable {
    let id: Int?
    let operatorName: String?
    let operatorCode: String?
    let fixedBill: Bool?
}

// MARK: - GetAllCirclesModel
struct GetAllCirclesModel: Codable {
    let content: [GetAllCirclesContent]
}

// MARK: - GetAllCirclesContent
struct GetAllCirclesContent: Codable {
    let circleId: String?
    let circleName: String?
}

// MARK: - GetPlanTypesModel
struct GetPlanTypesModel: Codable {
    let content: [String]
}

// MARK: - GetRechargePlansModel
struct GetRechargePlansModel: Codable {
    let content: [GetRechargePlansContent]
}

// MARK: - GetRechargePlansContent
struct GetRechargePlansContent: Codable {
    let createdBy: String?
    let updatedBy: String?
    let createdAt: String?
    let updatedAt: String?
    let id: Int?
    let operatorName: String?
    let operatorId: String?
    let circleName: String?
    let circleId: String?
    let planName: String?
    let price: String?
    let validity: String?
    let talkTime: String?
    let validityDescription: String?
    let packageDescription: String?
    let planType: String?
    let identityHash: String?
}

// MARK: - GetPlanDetailByPlanIDModel
struct GetPlanDetailByPlanIDModel: Codable {
    let id: Int?
    let operatorName: String?
    let operatorId: String?
    let circleName: String?
    let circleId: String?
    let planName: String?
    let price: String?
    let validity: String?
    let talkTime: String?
    let validityDescription: String?
    let packageDescription: String?
    let planType: String?
    let sms: String?
    let data: String?
    let calls: String?
}

class PlanInfo {
    var name: String?
    var value: String?
    
    init(itemName: String, itemValue: String?){
        self.name = itemName
        self.value = itemValue
    }
}




// MARK: - AddBillModel
struct AddBillModel: Codable {
    let id: Int?
    let customerPhoneNumber: String?
    let customerParams: [AddBillCustomerParam]
    let amount: Int?
    let noOfInstallation: Int?
    let accountHolderName: String?
    let billDue: Bool?
    let billDate: String?
    let dueDate: String?
    let billerName: String?
    let billerShortName: String?
    let billerPayuId: String?
    let operatorId: String?
    let autoPay: Bool?
    let enableReminder: Bool?
    let paymentAmountExactness: String?
    let paymentChannelsAllowed: [AddBillerModelPaymentSAllowed]?
}

struct AddBillPaymentChannel: Codable {
    let paymentMode: String?
    let minLimit: String?
    let maxLimit: String?
}

// MARK: - AddBill CustomerParam
struct AddBillCustomerParam: Codable {
    let value: String?
    let primary: Bool?
    let paramName: String?
}


// MARK: - GenerateHashModel
struct GenerateHashModel: Codable {
    let hash: String
}


// MARK: - VerifyPaymentModel
struct VerifyPaymentModel: Codable {
    let status, txnId: String?
    let amount: Int?
    let billId, paymentMode, customerName, billerId: String?
    let email: String?
    let noOfInstallment: Int?
    let billerName, paymentDate, payuBillerId, gatewayTxnId: String?
}
