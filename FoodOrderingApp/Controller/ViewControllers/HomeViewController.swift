//
//  ViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/23/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, CollectionViewCellDelagate {
    
    @IBOutlet weak var bestRatingCollectionView: UICollectionView!
    @IBOutlet weak var closeByCollectionView: UICollectionView!
    
    var dbReference: Firestore!
    var restaurants: [Restaurant] = []
    var selectedRestaurant: Restaurant?
    var rxRestaurants: BehaviorRelay<[Restaurant]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ger Firebase DB Reference
        dbReference = Firestore.firestore()
        
        retriveDBData()
        
        closeByCollectionView.layer.cornerRadius = 6.0
        bestRatingCollectionView.layer.cornerRadius = 6.0
        
        // RxSwift Methods
        handleCollectionViewDisplayCloseBy()
        handleCollectionViewDisplayBestRating()
        handeCollectionViewTappingCloseBy()
        handeCollectionViewTappingBestRating()
        
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
                    
                    // Add with RxSwift
                    let newValue = self.rxRestaurants.value + [pRestaurant]
                    self.rxRestaurants.accept(newValue)
                    
                }
            }
            
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

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return restaurants.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        // Setting up CloseBy Collection View
//        if collectionView == self.closeByCollectionView {
//
//            let restaurant = restaurants[indexPath.row]
//
//            let cell = closeByCollectionView.dequeueReusableCell(withReuseIdentifier: "closeByCell", for: indexPath) as! restaurantViewCell
//
//            cell.setData(restaurant)
//
//            return cell
//
//        } else {
//
//            print(restaurants)
//            // Setting up BestRating Collection View
//            let restaurant = restaurants[indexPath.row]
//
//            let cell = bestRatingCollectionView.dequeueReusableCell(withReuseIdentifier: "bestRatingCell", for: indexPath) as! restaurant2ViewCell
//
//            cell.setData(restaurant)
//
//            return cell
//
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        selectedRestaurant = restaurants[indexPath.row]
//
//    }
//
//}

//MARK: - RxSwift Config
extension HomeViewController {
    
    // Handling Display for Best Rating Collection View
    func handleCollectionViewDisplayBestRating() {
        rxRestaurants.bind(to: bestRatingCollectionView
            .rx
            .items(cellIdentifier: "bestRatingCell", cellType: restaurant2ViewCell.self)) { row, data, cell in
                cell.setData(data)
            }
            .disposed(by: disposeBag)
    }
    
    // Handling Display for Close By Collection View
    func handleCollectionViewDisplayCloseBy() {
        rxRestaurants.bind(to: closeByCollectionView
            .rx
            .items(cellIdentifier: "closeByCell", cellType: restaurantViewCell.self)) { row, data, cell in
                cell.setData(data)
            }
            .disposed(by: disposeBag)
    }
    
    // Handle Tapping for Close By Collection
    func handeCollectionViewTappingCloseBy() {
        closeByCollectionView.rx
            .modelSelected(Restaurant.self)
            .subscribe(onNext: { [unowned self] restaurant in
                self.selectedRestaurant = restaurant
            })
            .disposed(by: disposeBag)
    }
    
    // Handle Tapping for Best Rating Collection
    func handeCollectionViewTappingBestRating() {
        bestRatingCollectionView.rx
            .modelSelected(Restaurant.self)
            .subscribe(onNext: { [unowned self] restaurant in
                self.selectedRestaurant = restaurant
            })
            .disposed(by: disposeBag)
    }
    
}

