//
//  Restaurant.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import RxSwift
import RxCocoa

class Restaurant {
    
    var restaurantID: String
    var name: String
    var image: UIImage
    var address: String
    var rating: String
    var servise: Int
    
    init(restaurantID: String, name: String, image: UIImage, address: String, rating: String, servise: Int) {
        self.restaurantID = restaurantID
        self.name = name
        self.image = image
        self.address = address
        self.rating = rating
        self.servise = servise
    }
    
    //MARK: - Firebase Functions
    static func getAllData(dbReference: Firestore, restaurants: BehaviorRelay<[Restaurant]>) {
        
        dbReference.collection("users").document("5Trlr4CSkEYLvf2lJnX3").getDocument(completion: { (snapshot, error) in
            
            // Fucked up the Database
            let restaurant1 = Restaurant(
                restaurantID: "1aJJZdlpbTpW4BPJgxMr",
                name: "Modena",
                image: UIImage(named: "burrito")!,
                address: "Centar 4",
                rating: "4.3",
                servise: 250
            )
            
            let restaurant2 = Restaurant(
                restaurantID: "6oAvEgbZVpEsRnSBltYq",
                name: "Solemio",
                image: UIImage(named: "burrito")!,
                address: "Futoski Put 56",
                rating: "4.3",
                servise: 400
            )
            
            let restaurant3 = Restaurant(
                restaurantID: "8389012830jdas",
                name: "Merak",
                image: UIImage(named: "burrito")!,
                address: "Novosadski Put 28",
                rating: "4.8",
                servise: 200
            )
            
            restaurants.accept([restaurant1, restaurant2, restaurant3])
            
        })
        
    }
    
}
