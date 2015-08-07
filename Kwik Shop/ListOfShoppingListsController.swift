//
//  ListOfShoppingListsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 07.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ListOfShoppingListsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListsTableView: UITableView!
    
    var shoppingLists = [ShoppingList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        shoppingListsTableView.delegate = self
        shoppingListsTableView.dataSource = self
        loadSampleData()
    }
    
    func loadSampleData() {
        let list1 = ShoppingList(id: 0, name: "asdf", sortType: 0)
       
        let list2 = ShoppingList(id: 1, name: "qwerty", sortType: 0)
        
        shoppingLists += [list1, list2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return shoppingLists.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShoppingListTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)  as! ShoppingListTableViewCell
        
        let shoppingList = shoppingLists[indexPath.row]
        
        cell.nameLabel.text = shoppingList.name
        
        let numberOfItems = shoppingList.items.count
        var numberOfItemsText = "\(numberOfItems) "
        if (numberOfItems == 1) {
            numberOfItemsText += "Item"
        } else {
            numberOfItemsText += "Items"
        }
        
        cell.numberOfItemsLabel.text = numberOfItemsText
        
        let date = shoppingList.lastModifiedDate.relativeLocalizedRepresentation
        cell.lastModifiedLabel.text = date

        
        return cell
    }

    
    // MARK: Actions
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
    }
    
    
}

