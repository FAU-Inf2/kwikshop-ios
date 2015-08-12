//
//  ListOfShoppingListsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 07.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ListOfShoppingListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        let item1 = Item(id: 0, order: 0, name: "asdf")
        item1.comment = "bla"
        let item2 = Item(id: 1, order: 1, name: "qwerty")
        item2.brand = "blub"
        item2.bought = true
        let item3 = Item(id: 2, order: 2, name: "qwertz")
        item3.brand = "a"
        item3.comment = "b"
        item3.bought = true
        let item4 = Item(id: 3, order: 3, name: "item")
        item4.bought = true
        list1.items = [item1, item2, item3, item4]
        
       
        let list2 = ShoppingList(id: 1, name: "qwerty", sortType: 0)
        
        let list3 = ShoppingList(id: 2, name: "qwertz", sortType: 0)
        list3.items = [Item(id: 4, order: 0, name: "qwert")]
        
        shoppingLists += [list1, list2, list3]
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
               
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleGesture:")
        cell.addGestureRecognizer(longPress)
        

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteShoppingListAtIndexPath(indexPath)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }


    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let shoppingListViewController = segue.destinationViewController as? ShoppingListViewController {
            // navigating to shopping list
            if let selectedShoppingListCell = sender as? ShoppingListTableViewCell {
                let indexPath = shoppingListsTableView.indexPathForCell(selectedShoppingListCell)!
                let selectedShoppingList = shoppingLists[indexPath.row]
                shoppingListViewController.shoppingList = selectedShoppingList
                shoppingListViewController.returnToListOfShoppingListsDelegateMethod = unwindToListOfShoppingLists
            }
        }
    }
        
    func unwindToListOfShoppingLists(sender: UIViewController) {
        if let sourceViewController = sender as? ShoppingListViewController, shoppingList = sourceViewController.shoppingList {
            // shopping list could have new items
            if let selectedIndexPath = shoppingListsTableView.indexPathForSelectedRow() {
                shoppingLists[selectedIndexPath.row] = sourceViewController.shoppingList
                shoppingListsTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
        }
    }
    
    private var lastIndexPath : NSIndexPath?
    
    @IBAction func unwindToShoppingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ShoppingListDetailsViewController {
            if let shoppingList = sourceViewController.shoppingList {
                if !sourceViewController.newList {
                    if let selectedIndexPath = lastIndexPath {
                        shoppingLists[selectedIndexPath.row] = sourceViewController.shoppingList!
                        shoppingListsTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                    } else {
                        assertionFailure("Returning from shopping list details for an existing item allthough no table row was selected")
                    }
                } else {
                    let newIndexPath = NSIndexPath(forRow: shoppingLists.count, inSection: 0)
                    shoppingLists.append(shoppingList)
                    shoppingListsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
            } else {
                let indexPath = lastIndexPath!
                deleteShoppingListAtIndexPath(indexPath)
            }
        }
    }
    
    
    // MARK: Actions
    
    private func deleteShoppingListAtIndexPath(indexPath: NSIndexPath) {
        
        let index = indexPath.row
        shoppingLists.removeAtIndex(index)
        
        shoppingListsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
        
        let point = gestureRecognizer.locationInView(shoppingListsTableView)
        
        if let indexPath = shoppingListsTableView.indexPathForRowAtPoint(point) {
            if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
                if let detailsViewController = storyboard?.instantiateViewControllerWithIdentifier("ShoppingListDetailsView") as? ShoppingListDetailsViewController {
                    lastIndexPath = indexPath
                    let selectedShoppingList = shoppingLists[indexPath.row]
                    detailsViewController.shoppingList = selectedShoppingList
                    detailsViewController.newList = false
                    navigationController?.pushViewController(detailsViewController, animated: true)
                }
            }
        }
    }
    
    
    
}

