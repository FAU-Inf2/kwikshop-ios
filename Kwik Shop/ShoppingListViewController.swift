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
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        shoppingListTableView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    // MARK: Swipe Gesture
    func swipedView(sender : UISwipeGestureRecognizer) {
        let location = sender.locationInView(shoppingListTableView)
        if let indexPath = shoppingListTableView.indexPathForRowAtPoint(location) {
            
            let indexAndIndexPaths = getIndexAndIndexPathsForIndexPath(indexPath)
            
            if let index = indexAndIndexPaths.index {
                let boughtBeforeSwipe = items[index].bought
                //shoppingList.markItemWithIndex(index, asBought: !bought)
                let item = items.removeAtIndex(index)
                
                shoppingListTableView.deleteRowsAtIndexPaths(indexAndIndexPaths.indexPaths, withRowAnimation: .Fade)
                item.bought = !item.bought
                
                if boughtBeforeSwipe {
                    notBoughtItems.append(item)
                    let newIndexPath = NSIndexPath(forRow: notBoughtItems.count - 1, inSection: 0)
                    shoppingListTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                } else {
                    boughtItems.append(item)
                    let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)
                    let newIndexPaths = getIndexAndIndexPathsForIndexPath(newIndexPath).indexPaths
                    shoppingListTableView.insertRowsAtIndexPaths(newIndexPaths, withRowAnimation: .Bottom)
                }
                
                
                //shoppingListTableView.reloadData()
            } else {
                // Swiped the shoppinglist separator
                return
            }
        }
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
        
        let index = getIndexForIndexPath(indexPath)!
        
        let cellIdentifier = "ItemTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[index]
        
        if item.bought {
            let itemName = item.name
            let strikeThroughText = NSMutableAttributedString(string: itemName)
            strikeThroughText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, strikeThroughText.length))
            cell.nameLabel.attributedText = strikeThroughText
            cell.nameLabel.font = cell.brandCommentLabel.font
            cell.nameLabel.textColor = cell.brandCommentLabel.textColor
            
            cell.brandCommentLabel.text = ""
            cell.amountLabel.text = ""
        } else {
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
        }

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let indexAndIndexPaths = getIndexAndIndexPathsForIndexPath(indexPath)
            let index = indexAndIndexPaths.index
            let indexPaths = indexAndIndexPaths.indexPaths
            
            items.removeAtIndex(index!) // index != nil because the separator can't be swiped
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row != notBoughtItems.count
    }
    
    private func getIndexAndIndexPathsForIndexPath(indexPath: NSIndexPath) -> (index: Int?, indexPaths: [NSIndexPath]) {
        let index = getIndexForIndexPath(indexPath)
        if index == nil {
            return (nil, [indexPath])
        }
        let indexPaths : [NSIndexPath]
        if index == notBoughtItems.count && boughtItems.count == 1 {
            let separatorIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            indexPaths = [separatorIndexPath, indexPath]
        } else {
            indexPaths = [indexPath]
        }
        return (index, indexPaths)
    }
    
    private func getIndexForIndexPath(indexPath: NSIndexPath) -> Int? {
        if indexPath.row < notBoughtItems.count {
            return indexPath.row
        } else if indexPath.row == notBoughtItems.count {
            return nil
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
                let selectedItem = items[index!] // index can't be nil because otherwise the as? cast would fail
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
                    items[index!] = sourceViewController.currentItem!
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