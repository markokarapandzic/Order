//
//  FoodViewCell.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/30/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

class FoodViewCell: UITableViewCell {
    
    @IBOutlet weak var editFood: SubclassUIButton!
    @IBOutlet weak var addFood: SubclassUIButton!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
