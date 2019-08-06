//
//  FavouritesCell.swift
//  FoodOrderingApp
//
//  Created by Marko K on 8/6/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

class FavouritesCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var serviseLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
