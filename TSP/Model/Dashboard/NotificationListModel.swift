//
//  NotificationListModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 28/02/22.
//

import Foundation

// MARK: - NotificationListModel
struct NotificationListModel: Codable {
    let content: [NotificationListContent]
}

// MARK: - Content
struct NotificationListContent: Codable {
    let name: String?
    let description: String?
    let displayOrder: Int?
    let time: String?
}
