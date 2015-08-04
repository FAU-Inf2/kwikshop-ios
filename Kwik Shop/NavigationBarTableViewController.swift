//
//  NavigationBarTableViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class NavigationBarTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationBar = navigationController?.navigationBar, let kwikShopGreen = UIColor(resourceName: "primary_color") {
            navigationBar.barTintColor = kwikShopGreen
            navigationBar.tintColor = UIColor.whiteColor()
        }
        
    }
}