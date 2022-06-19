//
//  TSPTextField.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class TSPTextField: UITextField {
    
    // Storyboard Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        textFieldPlaceHolder()
    }
    
    private func textFieldPlaceHolder(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedString.Key.foregroundColor: Utilities.sharedInstance.hexStringToUIColor(hex: "4A4545").withAlphaComponent(0.50)])
        self.textColor = Utilities.sharedInstance.hexStringToUIColor(hex: "4A4545")
    }
    
}

class TSPPedingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
