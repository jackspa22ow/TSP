//
//  SpendAnalysisModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import Foundation

// MARK: - SpendAnalysisElement
struct SpendAnalysisElement: Codable {
    let categoryId: Int?
    let categoryName: String?
    let totalAmount: Double?
    let txnCount: Int?
}

typealias SpendAnalysis = [SpendAnalysisElement]







// MARK: - SpendAnalysisListElement
struct SpendAnalysisListElement: Codable {
    let amount: Double?
    let status: String?
    let paymentDate: String?
    let paymentMode: String?
    let txnid: String?
    let billNickName: String?
    let billerName: String?
//    let billerId: String?
}

typealias SpendAnalysisList = [SpendAnalysisListElement]
