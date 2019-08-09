//
//  Cart.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/30/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation
import Firebase

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
    
    //MARK: - Firebase Functions
    static func getCartData(dbReference: Firestore, cartID: String, completion: @escaping ((_ restaurant: Restaurant, _ cart: Cart) -> Void)) {
        
        dbReference.collection("carts").document(cartID).getDocument() { (document, error) in
            
            if let document = document, document.exists {
                
                var food: [String] = []
                var price: [Int] = []
                let arrayOfFoodsAndPrices = document.data()?["food"] as! [String]
                
                for foodArray in arrayOfFoodsAndPrices {
                    var array = foodArray.components(separatedBy: ",")
                    food.append(array[0])
                    price.append(Int(array[1]) ?? 0)
                }
                
                dbReference.collection("restaurants").document(document.data()?["restaurantID"] as! String).getDocument() { (restaurantSnapshot, error) in
                    
                    if let restaurantFirestore = restaurantSnapshot, restaurantSnapshot!.exists {
                        
                        let pRestaurant = Restaurant(
                            restaurantID: restaurantFirestore.documentID,
                            name: restaurantFirestore.data()!["name"] as! String,
                            image: UIImage(named: "burrito")!,
                            address: restaurantFirestore.data()!["address"] as! String,
                            rating: restaurantFirestore.data()!["rating"] as! String,
                            servise: restaurantFirestore.data()!["servise"] as! Int
                        )
                        
                        let pCart = Cart(
                            cartID: document.documentID,
                            food: food,
                            price: price,
                            restaurantID: document.data()?["restaurantID"] as! String
                        )
                        
                        // Return data with Callback
                        completion(pRestaurant, pCart)
                        
                    } else {
                        print("Document does not exist")
                    }
                    
                }
                
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
    
}
