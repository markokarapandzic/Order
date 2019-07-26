//
//  restaurantProfileViewController.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/25/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelagate {
    func collectRestaurantData() -> Restaurant
}

struct cellData {
    var opened = Bool()
    var restaurant: Restaurant?
}

class RestaurantProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
    }

}


// MARK: TableView Data Config

extension RestaurantProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (restaurant?.categories.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if restaurant?.categories[section].opened == true {
            return (restaurant?.categories[section].food.count)! + 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name.text = restaurant?.categories[indexPath.section].name
//            cell.layer.backgroundColor =
            
            if restaurant?.categories[indexPath.section].opened == true {
                cell.editImage.image = UIImage(named: "arrow-caret down")
            } else {
                cell.editImage.image = UIImage(named: "arrow-caret right")
            }
            
            cell.addImage.image = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "food_category", for: indexPath) as! FoodViewCell
            
            cell.name?.text = restaurant?.categories[indexPath.section].food[dataIndex].name
            cell.editImage.image = UIImage(named: "food-edit")
            cell.addImage.image = UIImage(named: "food-add")
            
            return cell
        }
        
    }
    
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
