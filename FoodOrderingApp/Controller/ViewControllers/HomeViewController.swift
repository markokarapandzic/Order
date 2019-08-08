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
        
        Restaurant.getAllData(dbReference: dbReference) { [weak self] restaurants in
            self!.rxRestaurants.accept(restaurants)
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

