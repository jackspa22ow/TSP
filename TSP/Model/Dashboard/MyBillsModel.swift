//
//  MyBillsModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import Foundation

// MARK: - MyBills
struct MyBills: Codable {
    let total: Int?
    let content: [MyBillsContent]
}

// MARK: - Content
struct MyBillsContent: Codable {
    let id: Int?
    let customerPhoneNumber: String?
    let customerParams: [MyBillsCustomerParam]
    let amount: Double?
    let accountHolderName: String?
    let dueDate: String?
    let billDate: String?
    let billDue: Bool?
    let billNickName: String?
    let billerName: String?
    let billerShortName: String?
    let billerPayuId: String?
    let autoPay: Bool?
    var enableReminder: Bool?
}

// MARK: - MYBILL DETAIL BY BILL ID
struct BillDetailModel: Codable {
    let id: Int?
    let noOfInstallation: Int?
    let customerPhoneNumber: String?
    var customerParams: [MyBillsCustomerParam]
    let amount: Double?
    let accountHolderName: String?
    let dueDate: String?
    let billDate: String?
    let billDue: Bool?
    let billNickName: String?
    let billerName: String?
    let billerShortName: String?
    let billerPayuId: String?
    let autoPay: Bool?
    var enableReminder: Bool?
    let reminders: [MyBillDetailReminderModel]?
    let standingInstruction: AutopayListModel?
    let paymentAmountExactness: String?
    let paymentChannelsAllowed: [AddBillerModelPaymentSAllowed]?
}

struct MyBillDetailReminderModel: Codable {
    let id: Int?
    let eventTypeId: Int?
    let eventSubType: String?
    let billerShortName: String?
    let eventSubTypeId: Int?
    let daysAfterBillGenerated: Int?
    let daysBeforeDueDate: Int?
    var isEnable: Bool?
}

// MARK: - CustomerParam
struct MyBillsCustomerParam: Codable {
    var value: String?
    var paramName: String?
    var primary: Bool?
}

// MARK: - PreparePayment
struct PreparePayment: Codable {
    let email: String?
    let phone: String?
    let hash: String?
    let curl: String?
    let surl: String?
    let furl: String?
    let key: String?
    let txnid: String?
    let amt: Double?
    let firstname: String?
    let lastname: String?
    let productinfo: String?
    let discount: Int?
    let netAmountDebit: Int?
}


// MARK: - MyBill Detail
struct MyBillDetailModel: Codable {
    let amount: Int?
    let billDate: String?
    let billFromDueDate: String?
    let billId: String?
    let billNickName: String?
    let billToDueDate: String?
    let billerId: String?
    let billerName: String?
    let categoryName: String?
    let customerId: String?
    let customerName: String?
    let email: String?
    let gatewayTxnId: String?
    let noOfInstallment: Int?
    let paymentDate: String?
    let paymentMode: String?
    let payuBillerId: String?
    let requestId: String?
    let status: String?
    let txnId: String?
}


// MARK: - BillShortNameResponse
struct BillShortNameResponse: Codable {
    let id, billId: Int?
    let userId, active, billNickName, updatedAt: String?
}
