//
//  TSPButton.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class TSPButton: UIButton {
    
    // Storyboard Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        buttonFontSize()
    }
    
    private func buttonFontSize(){
        self.titleLabel?.font = UIFont.systemFont(ofSize: TSP_FontSize)
    }
    
}
