//
//  Utilities.swift
//  TSP
//
//  Created by Ankur Kathiriya on 26/07/21.
//

import UIKit
import Alamofire
import Foundation
import SVProgressHUD

class Utilities {
    static let sharedInstance = Utilities()
    
    var historyDateFormate = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
    
    func showAlertView(title:String,message:String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func showSVProgressHUD(){
        SVProgressHUD.show()
        
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(hexStringToUIColor(hex: TSP_PrimaryColor))
    }
    
    func dismissSVProgressHUD(){
        SVProgressHUD.dismiss()
    }
    
    func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView){
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return #colorLiteral(red: 0.2509803922, green: 0.7215686275, blue: 0.5843137255, alpha: 1)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var familyName = "Avenir"
    enum AppFont: String {
        case black = "Black"
        case black_oblique = "Black Oblique"
        case book = "Book"
        case book_oblique = "Book Oblique"
        case heavy = "Heavy"
        case heavy_oblique = "Heavy Oblique"
        case light = "Light"
        case light_oblique = "Light Oblique"
        case medium = "Medium"
        case medium_oblique = "Medium Oblique"
        case oblique = "Oblique"
        case roman = "Roman"

        func size(_ size: CGFloat) -> UIFont {
            if let font = UIFont(name: fullFontName, size: size + 1.0) {
                return font
            }
            fatalError("Font '\(fullFontName)' does not exist.")
        }
        
        fileprivate var fullFontName: String {
            return rawValue.isEmpty ? Utilities.sharedInstance.familyName : Utilities.sharedInstance.familyName + "-" + rawValue
        }
    }


    public struct MyCustomEncoding : ParameterEncoding {
        private let data: Data
        init(data: Data) {
            self.data = data
        }
        public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            
            var urlRequest = try urlRequest.asURLRequest()
            do{
                urlRequest.httpBody = data
            }
            
            return urlRequest
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ number: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: number)
    }
    
    
}
