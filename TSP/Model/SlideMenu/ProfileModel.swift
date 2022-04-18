//
//  ProfileModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 05/08/21.
//

import UIKit

struct UserProfile_Param: Codable{
    var firstName : String?
    var lastName : String?
    var email : String?
    var username : String?
    var password : String?
    var confirmPassword : String?
    var role : String?
    var profilePicUrl : String?
}
