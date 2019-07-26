//
//  TabBarController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var tarBarItem = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Images for Tab Bar
        let selectedImage1 = UIImage(named: "home selected")
        let deSelectedImage1 = UIImage(named: "home")
        tabBarItem = self.tabBar.items![0]
        tabBarItem.image = deSelectedImage1
        tabBarItem.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "starBar selected")
        let deSelectedImage2 = UIImage(named: "starBar")
        tabBarItem = self.tabBar.items![1]
        tabBarItem.image = deSelectedImage2
        tabBarItem.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "shopping-cart selected")
        let deSelectedImage3 = UIImage(named: "shopping-cart")
        tabBarItem = self.tabBar.items![2]
        tabBarItem.image = deSelectedImage3
        tabBarItem.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "history selected")
        let deSelectedImage4 = UIImage(named: "history")
        tabBarItem = self.tabBar.items![3]
        tabBarItem.image = deSelectedImage4
        tabBarItem.selectedImage = selectedImage4
        
        let selectedImage5 = UIImage(named: "user-profile selected")
        let deSelectedImage5 = UIImage(named: "user-profile")
        tabBarItem = self.tabBar.items![4]
        tabBarItem.image = deSelectedImage5
        tabBarItem.selectedImage = selectedImage5
        
        self.selectedIndex = 0
        
    }

}

extension UIImage {
    
//    func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
//
//    }
    
}
