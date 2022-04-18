//
//  TSPView.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class TSPView: UIView {
    
    // Storyboard Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        viewBorderSet()
    }
    
    private func viewBorderSet(){
        self.layer.borderWidth = 2
        self.layer.borderColor = Utilities.sharedInstance.hexStringToUIColor(hex: "DDDDDD").cgColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
}
