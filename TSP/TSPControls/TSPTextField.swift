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
