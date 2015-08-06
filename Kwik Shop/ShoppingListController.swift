//
//  ShoppingListController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListController : UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var quickAddButton: UIButton!
    @IBOutlet weak var quickAddTextField: UITextField!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var items = [Item]()
    
    func loadSampleData() {
        var item1 = Item(id: 0, order: 0, name: "asdf")
        item1.comment = "bla"
        var item2 = Item(id: 1, order: 1, name: "qwerty")
        item2.brand = "blub"
        var item3 = Item(id: 2, order: 2, name: "qwertz")
        item3.brand = "a"
        item3.comment = "b"
        var item4 = Item(id: 3, order: 3, name: "item")
        
        items += [item1, item2, item3, item4]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        loadSampleData()
        
        shoppingListTableView.estimatedRowHeight = 44.0
        shoppingListTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: - Table view data source
    
    /*override*/ func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    /*override*/ func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count
    }
    
    
    /*override*/ func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) /*as! UITableViewCell*/ as! ItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.name
        
        if let brand = item.brand {
            cell.brandLabel.text = brand
        } else {
            //cell.brandLabel.hidden = true
            cell.brandLabel.removeFromSuperview()
        }
        
        if let comment = item.comment {
            cell.commentLabel.text = comment
        } else {
            cell.commentLabel.hidden = true
            cell.commentLabel.removeFromSuperview()
        }
        
        return cell
    }

}