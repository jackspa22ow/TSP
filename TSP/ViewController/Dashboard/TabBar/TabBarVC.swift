//
//  TabBarVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 06/07/21.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tab abr title color for selected and unselected tab
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

        // set black color as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: UIDevice.current.hasNotch ? 83 : 49)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.black.withAlphaComponent(0.1), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)

        //set tabbar background color
        tabBar.backgroundColor = Utilities.sharedInstance.hexStringToUIColor(hex: TSP_PrimaryColor)
        
        //disable translucent
        tabBar.isTranslucent = false
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
        // Do any additional setup after loading the view.
    }
   

}
