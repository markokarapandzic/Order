//
//  bestRatingViewCell.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

class restaurantViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var servise: UILabel!
    
    func setData(_ restourant: Restaurant) {
        self.servise.layer.cornerRadius = 6.0
        self.name.text = restourant.name
        self.image.image = UIImage(named: "burrito")
        self.address.text = restourant.address
        self.rating.text = String(restourant.rating)
        self.servise.text = "\(restourant.servise)RSD"
    }

}
