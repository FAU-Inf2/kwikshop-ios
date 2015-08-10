//
//  ItemTableViewCell.swift
//  
//
//  Created by Adrian Kretschmer on 06.08.15.
//
//

import UIKit

class ItemTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandCommentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
