//
//  Food.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation
import UIKit

class Food {
    
    var name: String
    var image: UIImage
    var price: Int
    var categoryID: String = "?"
    var options: [Option]
    
    // TOOD(1): Config CategotyID
    init(name: String, image: UIImage, price: Int, options: [Option]) {
        self.name = name
        self.image = image
        self.price = price
        self.options = options
    }
    
}
