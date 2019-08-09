//
//  OrderViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/30/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class OrderViewController: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var restaurantAddressLbl: UILabel!
    @IBOutlet weak var serviseLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var dbReference: Firestore?
    var cart: Cart?
    var restaurant: Restaurant?
    var foodInCart: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbReference = Firestore.firestore()
        
        // RxSwift Functions
        displayTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseCartData()
    }
    
    func getFirebaseCartData() {
        
        // Read data from UserDefaults
        if let cartID = UserDefaults.standard.object(forKey: "cartID") as? String {
            
            Cart.getCartData(dbReference: dbReference!, cartID: cartID) { (restaurant, cart) in
                self.restaurant = restaurant
                self.cart = cart
                self.foodInCart.accept(cart.food)
                self.updateUI()
            }
            
        } else {
            restaurantNameLbl.text = "No Items Added"
            restaurantAddressLbl.isHidden = true
            serviseLbl.isHidden = true
            totalLbl.isHidden = true
        }
        
    }
    
    func updateUI() {
        restaurantAddressLbl.isHidden = false
        serviseLbl.isHidden = false
        totalLbl.isHidden = false
        restaurantNameLbl.text = restaurant?.name
        restaurantAddressLbl.text = restaurant?.address
        print(String(restaurant!.servise))
        serviseLbl.text = String(restaurant!.servise)
        totalLbl.text = String(cart!.price.reduce(0, +) + restaurant!.servise) // Calculate Sum of Price Array
        mTableView.reloadData()
    }

}

// MARK: - RxSwift
extension OrderViewController {
    
    func displayTableView() {
        foodInCart.bind(to: mTableView
            .rx
            .items(cellIdentifier: "orderItem", cellType: OrderItemViewCell.self)) { row, data, cell in
                
                cell.orderItemNameLbl.text = data
                cell.orderItemPricelbl.text = String(self.cart!.price[row])
                
        }
        .disposed(by: disposeBag)
    }
    
}
