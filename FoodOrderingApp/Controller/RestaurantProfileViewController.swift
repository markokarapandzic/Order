//
//  restaurantProfileViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelagate {
    func collectRestaurantData() -> Restaurant
}

class RestaurantProfileViewController: UIViewController {
    
    @IBOutlet weak var someLabel: UILabel!
    
    var delagate: HomeViewController?
    var restaurant: Restaurant = Restaurant(name: "No Name", image: UIImage(named: "burrito")!, address: "???", rating: "???", servise: 999)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurant = (delagate?.collectRestaurantData())!
        someLabel.text = restaurant.name
    }

}
