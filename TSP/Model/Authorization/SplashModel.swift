//
//  SplashModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 05/07/21.
//

import Foundation

struct ClientConfiguration: Codable {
    let id: Int?
    let name: String?
    let short_name: String?
    let logo: String?
    let clientConfigs: [ClientConfig]
}

// MARK: - ClientConfig
struct ClientConfig: Codable {
    let id: Int?
    let name: String?
    let value: String?
    let clientId: Int?
    let dataType: String?
    let externalConfig: Bool?
}

// MARK: - ServerErrorModel
struct ServerErrorModel: Codable {
    let httpStatus: String?
    let message: String?
    let errorCode: String?
    let debugMessage: String?
    let success: String?
}

















