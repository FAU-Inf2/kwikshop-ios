//
//  NavigationController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let kwikShopGreen = UIColor(resourceName: "primary_color") {
            self.navigationBar.barStyle = UIBarStyle.Black
            self.navigationBar.barTintColor = kwikShopGreen
            self.navigationBar.tintColor = UIColor.whiteColor()
        }
    }
}
