//
//  ViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/23/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, CollectionViewCellDelagate {
    
    @IBOutlet weak var bestRatingCollectionView: UICollectionView!
    @IBOutlet weak var closeByCollectionView: UICollectionView!
    
    var dbReference: Firestore!
    var restaurants: [Restaurant] = []
    var selectedRestaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ger Firebase DB Reference
        dbReference = Firestore.firestore()
        
        retriveDBData()
        
        closeByCollectionView.layer.cornerRadius = 6.0
        bestRatingCollectionView.layer.cornerRadius = 6.0
        
    }
    
    // Get Data from Firebase Firestore
    func retriveDBData() {
        
        dbReference.collection("restaurants").getDocuments() { (querySnapshot, error) in
            
            if error != nil {
                print("Error getting data from Firestore")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let pRestaurant = Restaurant(
                        restaurantID: document.documentID,
                        name: document.data()["name"] as! String,
                        image: UIImage(named: "burrito")!,
                        address: document.data()["address"] as! String,
                        rating: document.data()["rating"] as! String,
                        servise: document.data()["servise"] as! Int
                    )
                    
                    self.restaurants.append(pRestaurant)
                    
                }
            }
            
            // Reload Data to Collection View's
            self.closeByCollectionView.reloadData()
            self.bestRatingCollectionView.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToRestaurant" {

            let destinationVC = segue.destination as! RestaurantProfileViewController
            destinationVC.delagate = self

        }

    }
    
    // Delagate Pattern
    func collectRestaurantData() -> Restaurant {
        return selectedRestaurant!
    }

}

// MARK: - Collection View Config

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Setting up CloseBy Collection View
        if collectionView == self.closeByCollectionView {
            
            let restaurant = restaurants[indexPath.row]
            
            let cell = closeByCollectionView.dequeueReusableCell(withReuseIdentifier: "closeByCell", for: indexPath) as! restaurantViewCell
            
            cell.setData(restaurant)
            
            return cell
            
        } else {
            
            print(restaurants)
            // Setting up BestRating Collection View
            let restaurant = restaurants[indexPath.row]
            
            let cell = bestRatingCollectionView.dequeueReusableCell(withReuseIdentifier: "bestRatingCell", for: indexPath) as! restaurant2ViewCell
            
            cell.setData(restaurant)
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedRestaurant = restaurants[indexPath.row]

    }
    
}

