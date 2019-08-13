//
//  OrderItemViewCell.swift
//  FoodOrderingApp
//
//  Created by Marko K on 7/30/19.
//  Copyright © 2019 Marko K. All rights reserved.
//

import UIKit

class OrderItemViewCell: UITableViewCell {
    
    @IBOutlet weak var orderItemNameLbl: UILabel!
    @IBOutlet weak var orderItemPricelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
