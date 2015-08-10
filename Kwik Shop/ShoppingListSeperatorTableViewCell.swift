//
//  ShoppingListSeperatorTableViewCell.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 10.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListSeperatorTableViewCell: UITableViewCell {

    @IBOutlet weak var shoppingCartLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(resourceName: "primary_color")
        shoppingCartLabel.textColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
