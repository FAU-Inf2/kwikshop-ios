//
//  ItemTableViewCell.swift
//  
//
//  Created by Adrian Kretschmer on 06.08.15.
//
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    //@IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel? {
        get {
            return currentBrandLabel
        }
        set (newValue) {
            if newValue != nil {
                storedBrandLabel = newValue
            }
            currentBrandLabel = newValue
        }
    }
    
    @IBOutlet weak var commentLabel: UILabel? {
        get {
            return currentCommentLabel
        }
        set (newValue) {
            if newValue != nil {
                storedCommentLabel = newValue
            }
            currentCommentLabel = newValue
        }
    }


    private weak var currentBrandLabel: UILabel?
    private var storedBrandLabel: UILabel?
    private weak var currentCommentLabel: UILabel?
    private var storedCommentLabel: UILabel?
    
    func restoreLabels() {
        if currentBrandLabel == nil {
            currentBrandLabel = storedBrandLabel
        }
        if currentCommentLabel == nil {
            currentCommentLabel = storedCommentLabel
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restoreLabels()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    deinit {
        storedBrandLabel = nil
        storedCommentLabel = nil
    }
}
