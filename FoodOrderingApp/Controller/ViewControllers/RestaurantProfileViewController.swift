//
//  RestaurantProfileViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import NotificationBannerSwift

protocol CollectionViewCellDelagate {
    func collectRestaurantData() -> Restaurant
}

struct cellData {
    var opened = Bool()
    var restaurant: Restaurant?
}

class RestaurantProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    
    var dbReference: Firestore?
    var delagate: HomeViewController?
    var restaurant: Restaurant?
    var tableViewData = [cellData]()
    var categories: [Category] = []
    var food: [Food] = []
    var foodCart: DocumentReference? = nil
    var banner: NotificationBanner?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbReference = Firestore.firestore()

        // Do any additional setup after loading the view.
        restaurant = (delagate?.collectRestaurantData())!
        
        // Table View Config
        tableView.delegate = self
        tableView.dataSource = self
        
        getFirestoreData()
        
        profileImage.backgroundColor = UIColor.black
        profileImage.layer.opacity = 0.85
        
        restaurantName.text = restaurant?.name
        restaurantAddress.text = restaurant?.address
        
    }
    
    // MARK: - Firebase Operations
    
    func getFirestoreData() {
        
        dbReference?.collection("categories").whereField("restaurantID", isEqualTo: String(restaurant!.restaurantID)).getDocuments() { (snapshot, error) in
            
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
                    
                    self.categories.append(pCategory)
                }
                
                self.getFoodFromFirestore()
                
            }
            
        }
        
        
    }
    
    // TODO(1): ASYNC Two Thread at the same time enter(Double values)
    // Get Food per Category From Firestore
    func getFoodFromFirestore() {
        
//        dbReference?.collection("food")
        
        for (index, category) in categories.enumerated() {
            print("========================CATEGORY BEGINING========================")
            print("\(category.food)")
            dbReference!.collection("food").whereField("categoryID", isEqualTo: category.categoryID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let pFood = Food(
                                foodID: document.documentID,
                                name: document.data()["name"] as! String,
                                image: UIImage(named: "burrito")!,
                                price: document.data()["price"] as! Int,
                                categoryID: document.data()["categoryID"] as! String
                            )
                            
                            category.food.append(pFood)
                            print("\(category.name) => \(pFood.name)")
                        }
                        
                        self.categories[index].food.append(contentsOf: category.food)
                        print("========================CATEGORY========================")
                        print("Name: \(self.categories[index].name)")
                        print("Food: \(category.food)")
                        
//                        self.categories[index].food = self.categories[index].food.removingDuplicates(byKey: \.categoryID)
//                        print("========================CATEGORY-AFTER-SORT========================")
//                        print("Name: \(self.categories[index].name)")
//                        print("Food: \(category.food)")
                    }
            }
        }
        
        tableView.reloadData()
        
    }
    
    // Remove Duplicates
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
}


// MARK: TableView Data Config

extension RestaurantProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (categories.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Check if Row has Section, if it doesnt return 1
        if categories[section].opened == true {
            return (categories[section].food.count) + 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        
        // Called for first row in Section(Title)
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name.text = categories[indexPath.section].name
            cell.backgroundColor = UIColor.flatWhite()
            
            cell.selectionStyle = .none
            cell.addFood.isHidden = true
            cell.editFood.isHidden = true
            
            return cell
            
        } else {
            
            // Called for Sections in Row
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name?.text = categories[indexPath.section].food[dataIndex].name
            
            cell.selectionStyle = .none
            cell.addFood.isHidden = false
            cell.editFood.isHidden = false
            
            // Define Color Animation
//            let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
//            colorAnimation.fromValue = UIColor.flatRed()?.cgColor
//            colorAnimation.duration = 1
            
            // Config Button Tapped
            cell.addFood.food = categories[indexPath.section].food[dataIndex]
            cell.addFood.addTarget(self, action: #selector(onAddFood), for: .touchUpInside)
            cell.editFood.addTarget(self, action: #selector(onEditFood(sender:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    // MARK: - Adding to Food Cart
    
    // Execute when Add Image is presed
    @objc func onAddFood(sender: SubclassUIButton) {
        
        let selectedFood = sender.food
        
        if foodCart != nil {
            
            foodCart?.updateData([
                "food": FieldValue.arrayUnion(["\(selectedFood?.name ?? "No Food Name"),\(selectedFood!.price)" ])
            ])
            
            notifyUserFoodAdded(selectedFood: selectedFood!)
            
        } else {
            foodCart = dbReference!.collection("carts").addDocument(data: [
                "restaurantID": restaurant?.restaurantID ?? "No Restaurant ID",
                "food": FieldValue.arrayUnion(["\(selectedFood?.name ?? "No Food Name"),\(selectedFood!.price)" ])
            ]) { err in
                
                if let err = err {
                    print("Error adding Food to Cart: \(err)")
                } else {
                    print("Document added to CART with ID: \(self.foodCart!.documentID)")
                    
                    // Save to UserDefauls
                    UserDefaults.standard.set(self.foodCart?.documentID, forKey: "cartID")
                    
                    self.notifyUserFoodAdded(selectedFood: selectedFood!)
                    
                }
                
            }
        }
        
    }
    
    func notifyUserFoodAdded(selectedFood: Food) {
        NotificationBanner(title: "Food Added", subtitle: selectedFood.name, style: .success).show()
    }
    
    // Execute when Edit Image is presed
    @objc func onEditFood(sender: UIButton) {
        
        let buttonTag = sender.tag
        
        print("=============================")
        print(buttonTag)
        print("=============================")
        
    }
    
    // Check if Cell is open or closed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if categories[indexPath.section].opened == true {

                categories[indexPath.section].opened = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .left)

            } else {

                categories[indexPath.section].opened = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .right)

            }
        }
        
    }
    
}

extension Array where Iterator.Element == Food {
    func removingDuplicates<T: Equatable>(byKey key: KeyPath<Element, T>)  -> [Element] {
        var result = [Element]()
        var seen = [T]()
        for value in self {
            let key = value[keyPath: key]
            if !seen.contains(key) {
                seen.append(key)
                result.append(value)
            }
        }
        return result
    }
}

// MARK: - Config UIButton

class SubclassUIButton: UIButton {
    var food: Food?
}
