//
//  Cart.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/30/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation

class Cart {
    
    var cartID: String
    var food: [String]
    var price: [Int]
    var restaurantID: String
    
    init(cartID: String, food: [String], price: [Int], restaurantID: String) {
        self.cartID = cartID
        self.food = food
        self.price = price
        self.restaurantID = restaurantID
    }
    
}
