//
//  FavouritesController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 8/3/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class FavouritesController: UIViewController {
    @IBOutlet weak var mTableView: UITableView!
    
    var favouriteRestaurants: BehaviorRelay<[Restaurant]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    var dbReference: Firestore?
}

extension FavouritesController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbReference = Firestore.firestore()
        
//        addUsersToDatabase()
        getFavouritesFromDatabase()
        displayFavouriteRestaurantsOnTable()
    }
}

extension FavouritesController {
    
    func getFavouritesFromDatabase() {
        
        dbReference?.collection("users").document("5Trlr4CSkEYLvf2lJnX3").getDocument(completion: { (snapshot, error) in
            
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
            
            self.favouriteRestaurants.accept([restaurant1, restaurant2, restaurant3])
            
        })
        
    }
    
}

//MARK: - RxSwift Config
extension FavouritesController {
    
    func displayFavouriteRestaurantsOnTable() {
        favouriteRestaurants.bind(to: mTableView
            .rx
            .items(cellIdentifier: "favouriteRestaurant", cellType: FavouritesCell.self)) { row, data, cell in
                
                cell.nameLbl.text = data.name
                cell.addressLbl.text = data.address
                cell.serviseLbl.text = "\(String(data.servise))RSD"
                
            }
            .disposed(by: disposeBag)
    }
    
}
