//
//  Category.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation

class Category {
    
    var name: String
    var food: [Food]
    var restaurantID: String = "?"
    var opened: Bool = false
    
    init(name: String, food: [Food]) {
        self.name = name
        self.food = food
    }
    
}
