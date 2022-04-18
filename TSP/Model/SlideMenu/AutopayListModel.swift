//
//  AutopayListModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 01/10/21.
//

import Foundation

// MARK: - AutopayListModel
struct AutopayListModel: Codable {
    let id: Int?
    let userId: String?
    let maxLimitAmount: Int?
    let preferredPaymentMode: String?
    let paymentDate: String?
    let noOfDays: String?
    let createdBy: String?
    let createdAt: String?
    let updatedAt: String?
    let mihPayId: String?
    let billId: Int?
    let billerId: String?
    let pgType: String?
    let billerName: String?
    let billNickName: String?
    let billDue: Bool?
    let billAmount: Double?
    let customerParams: String?
}


// MARK: - AutoPay Prepayment Model
struct AutoPreparePayment: Codable {
    let email: String?
    let phone: String?
    let hash: String?
    let curl: String?
    let surl: String?
    let furl: String?
    let key: String?
    let txnid: String?
    let amount: Double?
    let firstname: String?
    let lastname: String?
    let productinfo: String?
    let discount: Int?
    let net_amount_debit: Int?
}

struct AutoPayUpdatePreparePayment: Codable {
    let transactionRequest: AutoPreparePayment?
}
