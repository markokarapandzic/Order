//
//  Category.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/26/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import Foundation
import Firebase

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
    
    //MARK: - Firebase Functions
    static func getCategoriesByRestaurantID(dbReference: Firestore, restaurantID: String, completion: @escaping ((_ data: [Category]) -> Void)) {
        
        var categoriesOne: [Category] = []
        
        dbReference.collection("categories").whereField("restaurantID", isEqualTo: restaurantID).getDocuments() { (snapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let pCategory = Category(
                        categoryID: document.documentID,
                        name: document.data()["name"] as! String,
                        restaurantID: document.data()["restaurantID"] as! String
                    )
                    
                    categoriesOne.append(pCategory)
                }
                
                completion(categoriesOne)
                
            }
            
        }
        
    }
    
}
