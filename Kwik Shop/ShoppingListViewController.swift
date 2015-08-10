//
//  ShoppingListController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var quickAddButton: UIButton!
    @IBOutlet weak var quickAddTextField: UITextField!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var returnToListOfShoppingListsDelegateMethod: (UIViewController -> ())?
    
    var shoppingList : ShoppingList!
    var items : [Item] {
        get {
            return shoppingList.items
        }
        set {
            shoppingList.items = newValue
        }
    }
    var boughtItems : [Item] {
        get {
            return shoppingList.boughtItems
        }
        set {
            shoppingList.boughtItems = newValue
        }
    }
    var notBoughtItems : [Item] {
        get {
            return shoppingList.notBoughtItems
        }
        set {
            shoppingList.notBoughtItems = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        assert(shoppingList != nil, "No shopping list was handed to Shopping List View")
        
        shoppingListTableView.estimatedRowHeight = 44.0
        shoppingListTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        var count = notBoughtItems.count
        let boughtCount = boughtItems.count
        if boughtCount > 0 {
            count += boughtCount + 1
        }
        return count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        if indexPath.row == notBoughtItems.count {
            let cellIdentifier = "ShoppingListSeperatorTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShoppingListSeperatorTableViewCell
            
            return cell
        }
        
        let index = getIndexForIndexPath(indexPath)
        
        let cellIdentifier = "ItemTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[index]
        
        cell.nameLabel.text = item.name
        if item.isHighlited {
            cell.nameLabel.highlightedTextColor = UIColor.redColor()
            cell.nameLabel.highlighted = true
        }
        
        let brand = item.brand ?? ""
        let comment = item.comment ?? ""
        
        var brandCommentText = brand
        if !brand.isEmpty && !comment.isEmpty {
            brandCommentText += "\n"
        }
        brandCommentText += comment
        
        cell.brandCommentLabel.text = brandCommentText
        
        var amountText = ""
        if item.amount != 1 && item.unit == nil{
            amountText = "\(item.amount)"
        } else if let unit = item.unit {
            amountText = "\(item.amount) \(unit.shortName)"
        }
        cell.amountLabel.text = amountText
        
        return cell
    }
    
    private func getIndexForIndexPath(indexPath: NSIndexPath) -> Int {
        if indexPath.row < items.count {
            return indexPath.row
        } else {
            return indexPath.row - 1
        }
    }

    // MARK: Navigaton
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItemDetails" {
            let itemDetailsViewController = segue.destinationViewController as! ItemDetailsViewController
            if let selectedItemCell = sender as? ItemTableViewCell {
                let indexPath = shoppingListTableView.indexPathForCell(selectedItemCell)!
                let index = getIndexForIndexPath(indexPath)
                let selectedItem = items[index]
                itemDetailsViewController.currentItem = selectedItem
                itemDetailsViewController.newItem = false
            }
        }
        else if segue.identifier == "AddItem" {
            //print("Adding new item.")
        }
    }
    
    @IBAction func unwindToShoppingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ItemDetailsViewController, item = sourceViewController.currentItem {
            if !sourceViewController.newItem {
                if let selectedIndexPath = shoppingListTableView.indexPathForSelectedRow() {
                    let index = getIndexForIndexPath(selectedIndexPath)
                    items[index] = sourceViewController.currentItem!
                    shoppingListTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                } else {
                    assertionFailure("Returning from item details for an existing item allthough no table row was selected")
                }
            } else {
                let newIndexPath = NSIndexPath(forRow: notBoughtItems.count, inSection: 0)
                notBoughtItems.append(item)
                shoppingListTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            if let returnMethod = returnToListOfShoppingListsDelegateMethod {
                returnMethod(self)
            }
        }
    }
}