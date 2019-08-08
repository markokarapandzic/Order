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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self

        dbReference = Firestore.firestore()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseCartData()
    }
    
    func getFirebaseCartData() {
        
        // Read data from UserDefaults
        if let cartID = UserDefaults.standard.object(forKey: "cartID") as? String {
            
            // Get Cart data from Firestore
            dbReference?.collection("carts").document(cartID).getDocument() { (document, error) in
                
                if let document = document, document.exists {
                    
                    var food: [String] = []
                    var price: [Int] = []
                    let arrayOfFoodsAndPrices = document.data()?["food"] as! [String]
                    
                    for foodArray in arrayOfFoodsAndPrices {
                        var array = foodArray.components(separatedBy: ",")
                        food.append(array[0])
                        price.append(Int(array[1]) ?? 0)
                    }
                    
                    self.dbReference?.collection("restaurants").document(document.data()?["restaurantID"] as! String).getDocument() { (restaurantSnapshot, error) in
                        
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
                            
                            self.restaurant = pRestaurant
                            self.cart = pCart
                            
                            self.updateUI()
                            
                        } else {
                            print("Document does not exist")
                        }
                        
                    }
                    
                } else {
                    print("Document does not exist")
                }
                
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

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cart != nil {
            return (cart?.food.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mTableView.dequeueReusableCell(withIdentifier: "orderItem") as! OrderItemViewCell
        
        cell.orderItemNameLbl.text = cart?.food[indexPath.row]
        cell.orderItemPricelbl.text = String(cart!.price[indexPath.row])
        
        return cell
        
    }
    
}
