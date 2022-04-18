//
//  ReminderListModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 01/10/21.
//

import Foundation

// MARK: - ReminderListModel
struct ReminderListModel: Codable {
    let message: String
    let payload: [ReminderListPayload]
}

// MARK: - Payload
struct ReminderListPayload: Codable {
    let id: Int?
    let billId: Int?
    let billerName: String?
    let billAmount: Double?
    let customerParams: [ReminderListCustomerParam]
    let billDue: Bool?
    let eventTypeId: Int?
    let eventType: String?
    let eventSubType: String?
    let eventSubTypeId: Int?
    let daysAfterBillGenerated: Int?
    let daysBeforeDueDate: Int?
    let isEnable: Bool?
    let billNickName: String?
}

// MARK: - ReminderList CustomerParam
struct ReminderListCustomerParam: Codable {
    let value: String?
    let primary: Bool?
    let paramName: String?
}

// MARK: - ReminderOption Subtype
struct ReminderSubtypeList: Codable {
    var payload: [ReminderSubtype]?
}
struct ReminderSubtype: Codable {
    let eventSubTypeId: Int?
    let eventTypeId: Int?
    let eventSubTypes: String?
    var isChecked : Bool?
    var value : String?
}

// MARK: - Reminder Desable
struct ReminderUpdate: Codable {
    let message: String?
    let payload: [ReminderUpdatePayload]?
    
}

struct ReminderUpdatePayload: Codable {
    let billAmount: Int?
    let billDue: Bool?
    let billId: Int?
    let billNickName: String?
    let billerName: String?
    let daysAfterBillGenerated: Int?
    let daysBeforeDueDate: Int?
    let eventSubType: String?
    let eventSubTypeId: Int?
    let eventType: String?
    let eventTypeId: Int?
    let id: Int?
    let isEnable: Bool?

}

struct RemindersForBillModel: Codable {
    let message: String
    let payload: [ReminderListPayload]?
}

//struct ReminderForBillPayload: Codable {
//    let id: Int?
//    let eventTypeId: Int?
//    let eventType: String?
//    let eventSubType: String?
//    let eventSubTypeId: Int?
//    let daysAfterBillGenerated: Int?
//    let daysBeforeDueDate: Int?
//    let isEnable: Bool?
//}

//{
//  "message": "Successfully fetched Reminder(s) pertaining to the bill",
//  "payload": [
//    {
//      "id": 130,
//      "billId": 117,
//      "billerName": "AIRTEL",
//      "billAmount": 3598,
//      "customerParams": [
//        {
//          "value": "5",
//          "primary": true,
//          "paramName": "CircleId"
//        },
//        {
//          "value": "7778853800",
//          "primary": false,
//          "paramName": "Mobile Number"
//        },
//        {
//          "value": "AT",
//          "primary": false,
//          "paramName": "Operator"
//        }
//      ],
//      "billDue": true,
//      "eventTypeId": 1,
//      "eventType": "Reminders",
//      "eventSubType": "Days After bill Generated",
//      "eventSubTypeId": 1,
//      "daysAfterBillGenerated": 5,
//      "daysBeforeDueDate": 0,
//      "isEnable": true
//    },
//    {
//      "id": 131,
//      "billId": 117,
//      "billerName": "AIRTEL",
//      "billAmount": 3598,
//      "customerParams": [
//        {
//          "value": "5",
//          "primary": true,
//          "paramName": "CircleId"
//        },
//        {
//          "value": "7778853800",
//          "primary": false,
//          "paramName": "Mobile Number"
//        },
//        {
//          "value": "AT",
//          "primary": false,
//          "paramName": "Operator"
//        }
//      ],
//      "billDue": true,
//      "eventTypeId": 2,
//      "eventType": "Reminders",
//      "eventSubType": "Days Before Due Date",
//      "eventSubTypeId": 2,
//      "daysAfterBillGenerated": 0,
//      "daysBeforeDueDate": 7,
//      "isEnable": true
//    }
//  ]
//}
//
//{
//  "message": "Reminder Not Found for the bill"
//}
//
