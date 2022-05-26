//
//  MainTabbarController.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15, *) {
            self.tabBar.backgroundColor = .background
        } else {
            self.tabBar.barTintColor = .background
            self.tabBar.isTranslucent = false
            self.tabBar.clipsToBounds = true
        }
        self.tabBar.tintColor = .main
        self.tabBar.unselectedItemTintColor = .lightGray
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.rubikOne(size: 11)], for: .normal)
    }

}
