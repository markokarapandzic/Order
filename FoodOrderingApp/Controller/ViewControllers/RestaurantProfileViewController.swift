//
//  RestaurantProfileViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit
import ChameleonFramework

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
    
    var delagate: HomeViewController?
    var restaurant: Restaurant?
    var tableViewData = [cellData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurant = (delagate?.collectRestaurantData())!
        
        // Table View Config
        tableView.delegate = self
        tableView.dataSource = self
        
        profileImage.backgroundColor = UIColor.black
        profileImage.layer.opacity = 0.85
        
        restaurantName.text = restaurant?.name
        restaurantAddress.text = restaurant?.address
        
    }

}


// MARK: TableView Data Config

extension RestaurantProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (restaurant?.categories.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Check if Row has Section, if it doesnt return 1
        if restaurant?.categories[section].opened == true {
            return (restaurant?.categories[section].food.count)! + 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        
        // Called for first row in Section(Title)
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name.text = restaurant?.categories[indexPath.section].name
            cell.backgroundColor = UIColor.flatWhite()
            
            cell.selectionStyle = .none
            cell.addFood.isHidden = true
            cell.editFood.isHidden = true
            
            return cell
            
        } else {
            
            // Called for Sections in Row
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name?.text = restaurant?.categories[indexPath.section].food[dataIndex].name
            
            cell.selectionStyle = .none
            cell.addFood.isHidden = false
            cell.editFood.isHidden = false
            
            // Config Button Tapped
            cell.addFood.food = restaurant?.categories[indexPath.section].food[dataIndex]
            cell.addFood.addTarget(self, action: #selector(onAddFood), for: .touchUpInside)
            cell.editFood.addTarget(self, action: #selector(onEditFood(sender:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    // Execute when Add Image is presed
    @objc func onAddFood(sender: SubclassUIButton) {
        
        let buttonTag = sender.food
        
        print("=============================")
        print(buttonTag!.name)
        print("=============================")
        
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
            if restaurant?.categories[indexPath.section].opened == true {
                
                restaurant?.categories[indexPath.section].opened = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .left)
                
            } else {
                
                restaurant?.categories[indexPath.section].opened = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .right)
                
            }
        }
        
    }
    
}

// MARK: - Config UIButton

class SubclassUIButton: UIButton {
    var food: Food?
}
