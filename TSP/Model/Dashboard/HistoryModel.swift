//
//  HistoryModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import Foundation

// MARK: - TransactionsModel
struct TransactionsModel: Codable {
    let amount: Double?
    let status: String?
    let paymentDate: String?
    let paymentMode: String?
    let txnid: String?
    let billNickName: String?
    let billerName: String?
}

struct ServiceGroupModel: Codable {
    let faqGroupId: Int?
    let groupName: String?
    let clientId: Int?
    let description: String?
}

struct ServiceQuestionModel: Codable {
    let faqId: Int?
    let question: String?
    let answer: String?
    let faqGroup: String?
//    let description: String?
}

// MARK: - ComplaintsModel
struct ComplaintsModel: Codable {
    let message: String?
    let payload: [TransactionsPayload]?
}

// MARK: - Transactions Payload
struct TransactionsPayload: Codable {
    let billerName: String?
    let billAmount: Double?
    let billNickName: String?
    let customerParams: [TransactionsCustomerParam]?
    let paymentDate: String?
    let txnId: String?
    let complaintStatus: String?
    let complaintDate: String?
    let complaintId: String?
}

// MARK: - Transactions CustomerParam
struct TransactionsCustomerParam: Codable {
    let value: String?
    let primary: Bool?
    let paramName: String?
}

