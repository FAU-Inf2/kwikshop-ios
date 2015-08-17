//
//  ListOfShoppingListsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 07.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit
import CoreData

class ListOfShoppingListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListsTableView: UITableView!
    
    var shoppingLists = [ShoppingList]()
    let dbHelper = DatabaseHelper.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        shoppingListsTableView.delegate = self
        shoppingListsTableView.dataSource = self
        
        if shoppingLists.isEmpty {
            loadSampleData()
        }
    }
    
    private var goToShoppingList = false
    override func viewWillAppear(animated: Bool) {
        if goToShoppingList {
            goToShoppingList = false
            self.performSegueWithIdentifier("ShowShoppingList", sender: self)
        }
    }
    
    func loadFromDatabase() {
        if let shoppingLists = dbHelper.loadShoppingLists() {
            self.shoppingLists = shoppingLists
        }
    }
    
    func loadSampleData() {
        
        loadFromDatabase()
        if !shoppingLists.isEmpty {
            return
        }
        
        let item1 = Item(name: "Apple")
        item1.comment = "Type in the box above to add items"
        
        let item2 =  Item(name: "Sweets")
        //item2.comment = "Click a bit longer and then move your item to sort your list as you want" // not working yet
        
        let item3 = Item(name: "Coke")
        item3.amount = 5
        item3.unit = UnitHelper.instance.BOTTLE
        item3.comment = "Swipe items to the right to mark them as bought"
        
        let item4 = Item(name: "Spaghettis")
        item4.amount = 5
        item4.comment = "You can add detailed items with the navigation bar button on the right"
        
        let item5 = Item(name: "Toilet paper")
        item5.comment = "For example you can highlight important items like toilet paper"
        item5.highlighted = true
        
        let item6 = Item(name: "This item is already bought")
        item6.bought = true
        item6.comment = "At least it used to be; swipe it again to mark it as bought again"
        
        let list = ShoppingList(name: "My first shopping list")
        list.items = [item1, item2, item3, item4, item5, item6]
        
        shoppingLists = [list]
        
        dbHelper.saveData()
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
            let indexPath : NSIndexPath
            if let selectedShoppingListCell = sender as? ShoppingListTableViewCell {
                // a cell was tapped
                indexPath = shoppingListsTableView.indexPathForCell(selectedShoppingListCell)!
            } else {
                // a new shopping list has just been created
                indexPath = NSIndexPath(forRow: shoppingLists.count - 1, inSection: 0)
            }
            let selectedShoppingList = shoppingLists[indexPath.row]
            shoppingListViewController.shoppingList = selectedShoppingList
            shoppingListViewController.returnToListOfShoppingListsDelegateMethod = unwindToListOfShoppingLists

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
                        dbHelper.saveData()
                    } else {
                        assertionFailure("Returning from shopping list details for an existing item allthough no table row was selected")
                    }
                } else {
                    let newIndexPath = NSIndexPath(forRow: shoppingLists.count, inSection: 0)
                    shoppingLists.append(shoppingList)
                    shoppingListsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                    dbHelper.saveData()
                    self.goToShoppingList = true
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
        let shoppingList = shoppingLists.removeAtIndex(index)
        
        dbHelper.deleteShoppingList(shoppingList)
        
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

