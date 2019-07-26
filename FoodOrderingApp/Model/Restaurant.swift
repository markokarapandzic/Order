//
//  Restaurant.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation
import UIKit

class Restaurant {
    
    var name: String
    var image: UIImage
    var address: String
    var rating: String
    var servise: Int
    
    init(name: String, image: UIImage, address: String, rating: String, servise: Int) {
        self.name = name
        self.image = image
        self.address = address
        self.rating = rating
        self.servise = servise
    }
    
}