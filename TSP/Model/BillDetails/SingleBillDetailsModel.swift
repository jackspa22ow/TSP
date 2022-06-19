//
//  SingleBillDetailsModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/09/21.
//

import UIKit

struct SingleBillDetails: Codable {
    let status: String?
    let txnId: String?
    let amount: Double?
    let billId: String?
    let paymentMode: String?
    let customerName: String?
    let billDate: String?
    let billerId: String?
    let email: String?
    let noOfInstallment: Int?
    let billToDueDate: String?
    let billerName: String?
    let paymentDate: String?
    let billNickName: String?
}

struct MultipleBillDetails: Codable {
    let status, txnId: String?
    let amount: Double?
    let billId, paymentMode, customerName, billerID: String?
    let email: String?
    let noOfInstallment: Int?
    let billerName, paymentDate, payuBillerId, gatewayTxnId: String?
    let categoryName: String?
    let customerParams: [MyBillsCustomerParam]?
    var isExpand: Bool?
}


struct ComplaintInfoModel: Codable {
    let message: String?
    let payload: [ComplaintInfoPayloadModel]?
}

// MARK: - Payload
struct ComplaintInfoPayloadModel: Codable {
    let complaintStatus, disposition, complaintDate, userComplaintMessage: String?
    let txnReferenceId: String?
}
