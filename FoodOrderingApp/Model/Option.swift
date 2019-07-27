//
//  Option.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation

class Option {
    
    var name: String
    var price: Int
    var foodID: String = "?"
    
    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
    
}
