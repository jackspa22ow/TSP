//
//  TSPLabel.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class TSPLabel: UILabel {
    
    // Storyboard Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        labelFontSize()
    }
    
    private func labelFontSize(){
        self.font = UIFont.systemFont(ofSize: TSP_FontSize)
    }
    
}
