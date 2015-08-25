//
//  TabBarViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let shoppingListsItem = self.tabBar.items![0] as! UITabBarItem
        let settingsItem = self.tabBar.items![1] as! UITabBarItem
        let aboutItem = self.tabBar.items![2] as! UITabBarItem
        
        shoppingListsItem.title = "navigation_bar_shopping_lists".localized
        settingsItem.title = "navigation_bar_settings".localized
        aboutItem.title = "navigation_bar_about".localized
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
