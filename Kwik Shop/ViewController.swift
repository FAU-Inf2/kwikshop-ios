//
//  ViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 26.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
    }


}

