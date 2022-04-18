//
//  HomeModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit
import Foundation

// MARK: - Group
struct Group: Codable {
    let id: Int?
    let groupName: String?
    let description: String?
    let clientId: Int?
    let displayCategories: [GroupDisplayCategory]?
}

// MARK: - Group DisplayCategory
struct GroupDisplayCategory: Codable {
    let id: Int?
    let clientId: Int?
    let name: String?
    let description: String?
    let iconUrl: String?
    let displayName: String?
    let active: Bool?
}
typealias Groups = [Group]


struct UserProfile: Codable{
    var email : String?
    var firstName : String?
    var lastName : String?
    var username : String?
    var role : String?
    var clientId : String?
    var profilePicUrl : String?
    var phoneNumber : String?
}


struct BannerList: Codable{
    var id : Int?
    var clientId : Int?
    var logo : String?
    var redirectUrl : String?
    var title : String?
    var updatedAt : String?
    var createdAt : String?
    var createdBy : String?
    var updatedBy : String?
    var expiryDate : String?
}
