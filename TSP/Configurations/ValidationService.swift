//
//  ValidationService.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/01/22.
//

import Foundation


struct ValidationService{
    
    func validateUsername(_ username: String?) throws -> String {
        guard let username = username else { throw
            ValidationError.invalidUsername}
        guard username.count > 3 else { throw
            ValidationError.usernameTooShort}
        return username
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else { throw
            ValidationError.invalidPassword}
        guard password.count >= 8 else { throw
            ValidationError.passwordTooShort}
        return password
    }
}



enum ValidationError: LocalizedError{
    case invalidUsername
    case usernameTooShort
    case invalidPassword
    case passwordTooShort
    
    var errorDescription: String?{
        switch self {
        case .invalidUsername:
            return "Invalid username."
        case .usernameTooShort:
            return "Username should contain atleast 3 characters."
        case .invalidPassword:
            return "Invalid password."
        case .passwordTooShort:
            return "Password should contain atleast 8 characters."
        }
    }
}
