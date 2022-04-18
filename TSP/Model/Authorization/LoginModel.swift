//
//  LoginModel.swift
//  TSP
//
//  Created by Ankur Kathiriya on 26/10/21.
//

import Foundation

struct LoginModel: Codable {
    let access_token: String?
    let expires_in: Int?
    let refresh_expires_in: Int?
    let refresh_token: String?
    let token_type: String?
    let id_token: String?
    let session_state: String?
    let scope: String?
    let message: String?
    let errorCode: String?
}

struct Login_Param{
    var username : String?
    var password : String?
}

struct CustomSSO_Login_Param{
    var authKey : String?
    var custId : String?
    var tenantName : String?
    var token : String?
}
