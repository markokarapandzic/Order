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
        
        closeByCollectionView.layer.cornerRadius = 6.0
        bestRatingCollectionView.layer.cornerRadius = 6.0
        
        restaurants = loadData()
        
        print("Inside viewDidLoad Function")
//        retriveDBData()
        
    }
    
    // Get Data from Firebase Firestore
    func retriveDBData() {
        
        dbReference.collection("food").getDocuments() { (querySnapshot, error) in
            
            if error != nil {
                print("Error getting data from Firestore")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
            
        }
        
    }
    
    func loadData() -> [Restaurant] {
        
        var loadingData: [Restaurant] = []
        
        let food1 = Food(name: "Pljeskavica 200g", image: UIImage(named: "burrito")!, price: 200, options: [Option(name: "Kecap", price: 30), Option(name: "Majonez", price: 25)])
        let food2 = Food(name: "Index sendvic", image: UIImage(named: "burrito")!, price: 250, options: [Option(name: "Sir", price: 50), Option(name: "Masline", price: 70)])
        let food3 = Food(name: "Cezar", image: UIImage(named: "burrito")!, price: 199, options: [Option(name: "Sir", price: 50), Option(name: "Masline", price: 70)])
        let food4 = Food(name: "Srpska", image: UIImage(named: "burrito")!, price: 100, options: [Option(name: "Sir", price: 50), Option(name: "Masline", price: 70)])
        let category1 = Category(name: "Burgers", food: [food1, food2])
        let category2 = Category(name: "Salads", food: [food3, food4])
        
        
        let restaurant1 = Restaurant(name: "Merak", image: UIImage(named: "burrito")!, address: "Novosadski Put 28", rating: "3.2", servise: 200, categories: [category1, category2])
        let restaurant2 = Restaurant(name: "Petrus", image: UIImage(named: "burrito")!, address: "Centar 2", rating: "4.8", servise: 350, categories: [category1, category2])
        let restaurant3 = Restaurant(name: "Retro Burger", image: UIImage(named: "burrito")!, address: "Temerinska 12", rating: "3.7", servise: 180, categories: [category1, category2])
        let restaurant4 = Restaurant(name: "Caio Picerija", image: UIImage(named: "burrito")!, address: "Socijalno 78", rating: "4.2", servise: 220, categories: [category1, category2])
        let restaurant5 = Restaurant(name: "Modena", image: UIImage(named: "burrito")!, address: "Centar 4", rating: "4.5", servise: 250, categories: [category1, category2])
        let restaurant6 = Restaurant(name: "Irish Pub", image: UIImage(named: "burrito")!, address: "Dunavska 5", rating: "4.6", servise: 300, categories: [category1, category2])
        let restaurant7 = Restaurant(name: "Atina", image: UIImage(named: "burrito")!, address: "Ribarska 8", rating: "4.0", servise: 230, categories: [category1, category2])
        let restaurant8 = Restaurant(name: "Solemio", image: UIImage(named: "burrito")!, address: "Futoski Put 56", rating: "4.4", servise: 400, categories: [category1, category2])
        let restaurant9 = Restaurant(name: "Foody", image: UIImage(named: "burrito")!, address: "Limanska 9", rating: "4.1", servise: 100, categories: [category1, category2])
        let restaurant10 = Restaurant(name: "McDonalds", image: UIImage(named: "burrito")!, address: "Bulevar Oslobodjenja 1", rating: "4.9", servise: 350, categories: [category1, category2])
        
        loadingData.append(restaurant1)
        loadingData.append(restaurant2)
        loadingData.append(restaurant3)
        loadingData.append(restaurant4)
        loadingData.append(restaurant5)
        loadingData.append(restaurant6)
        loadingData.append(restaurant7)
        loadingData.append(restaurant8)
        loadingData.append(restaurant9)
        loadingData.append(restaurant10)
        
        return loadingData
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Setting up CloseBy Collection View
        if collectionView == self.closeByCollectionView {
            
            let restaurant = restaurants[indexPath.row]
            
            let cell = closeByCollectionView.dequeueReusableCell(withReuseIdentifier: "closeByCell", for: indexPath) as! restaurantViewCell
            
            cell.setData(restaurant)
            
            return cell
            
        } else {
            
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

