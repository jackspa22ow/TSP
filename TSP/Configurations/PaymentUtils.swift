//
//  Utils.swift
//  PayUCheckoutPro
//
//  Created by Ankur Kathiriya on 09/09/21.
//

import UIKit
import Foundation
import CommonCrypto
import PayUBizCoreKit
import PayUCheckoutProKit
import PayUCheckoutProBaseKit

class Utils: NSObject {
    
    class func sha512Hex(string: String) -> String {
        PayUDontUseThisClass().getHash(string)
    }
    
    class func hmacsha1(of string: String, secret: String) -> String {
        PayUDontUseThisClass.hmacsha1(string, secret: secret)
    }

    class func txnId() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss"
        let txnID = "iOS" + formatter.string(from: Date())
        return txnID
    }
    
    class func JSONFrom(string: String) -> Any? {
        guard let data = string.data(using: .utf8) else { return nil}
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return nil
        }
    }
    
    class func paymentModeFrom(paymentType: String?, paymentOptionID: String?) -> PaymentMode? {
        var paymentMode: PaymentMode?
        if paymentType == "Cards".lowercased() {
            paymentMode = PaymentMode(paymentType: .ccdc)
        } else if paymentType == "NetBanking".lowercased() {
            paymentMode = PaymentMode(paymentType: .netBanking, paymentOptionID: paymentOptionID ?? "")
        } else if paymentType == "UPI".lowercased() {
            paymentMode = PaymentMode(paymentType: .upi, paymentOptionID: paymentOptionID ?? "")
        } else if paymentType == "Wallet".lowercased() {
            paymentMode = PaymentMode(paymentType: .wallet, paymentOptionID: paymentOptionID ?? "")
        } else if paymentType == "emi".lowercased() {
            paymentMode = PaymentMode(paymentType: .emi, paymentOptionID: paymentOptionID ?? "")
        }
        return paymentMode
    }
    
    class func paymentTypeFrom(paymentType: String?) -> PaymentType? {
        if (paymentType?.caseInsensitiveCompare("Cards") == .orderedSame) {
            return .ccdc
        } else if (paymentType?.caseInsensitiveCompare("NetBanking") == .orderedSame) {
            return .netBanking
        } else if (paymentType?.caseInsensitiveCompare("UPI") == .orderedSame) {
            return .upi
        } else if (paymentType?.caseInsensitiveCompare("Wallet") == .orderedSame) {
            return .wallet
        } else if (paymentType?.caseInsensitiveCompare("emi") == .orderedSame) {
            return .emi
        } else {
            return nil
        }
    }
}
