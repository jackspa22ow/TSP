//
//  TSPTextView.swift
//  TSP
//
//  Created by Jack on 02/07/21.
//

import UIKit

class TSPTextView: UITextView {
    
    // Storyboard Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        textViewFontSize()
    }
    
    private func textViewFontSize(){
        self.font = UIFont.systemFont(ofSize: TSP_FontSize)
    }
    
}
