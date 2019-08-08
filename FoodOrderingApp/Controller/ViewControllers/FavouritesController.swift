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
        
        // Get Restaurants from Firestore
        Restaurant.getFavouriteData(dbReference: dbReference!, restaurants: favouriteRestaurants.self)
        
        // RxSwift
        displayFavouriteRestaurantsOnTable()
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
