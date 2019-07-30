//
//  Category.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation

class Category {
    
    var categoryID: String
    var name: String
    var restaurantID: String
    var opened: Bool = false
    var food: [Food] = []
    
    init(categoryID: String, name: String, restaurantID: String) {
        self.categoryID = categoryID
        self.name = name
        self.restaurantID = restaurantID
    }
    
}
