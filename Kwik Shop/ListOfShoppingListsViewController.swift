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
        
        shoppingListsTableView.estimatedRowHeight = 44.0
        shoppingListsTableView.rowHeight = UITableViewAutomaticDimension
        
        if shoppingLists.isEmpty {
            loadSampleData()
        }
        self.title = "navigation_bar_shopping_lists".localized
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
            let sortedShoppingLists = shoppingLists.sort(sortByDate)
            self.shoppingLists = sortedShoppingLists
        }
    }
    
    private func sortByDate(firstList: ShoppingList, secondList: ShoppingList) -> Bool {
        return firstList.lastModifiedDate > secondList.lastModifiedDate
    }
    
    func loadSampleData() {
        
        loadFromDatabase()
        if !shoppingLists.isEmpty {
            return
        }
        
        let groupHelper = GroupHelper.instance
        
        let item1 = Item(name: "example_item_1".localized)
        item1.comment = "example_item_1_comment".localized
        item1.group = groupHelper.FRUITS_AND_VEGETABLES
        
        let item2 =  Item(name: "example_item_2".localized)
        item2.comment = "example_item_2_comment".localized //Click a bit longer and then move your item to sort your list as you want; not working yet
        item2.group = groupHelper.SWEETS_AND_SNACKS
        
        let item3 = Item(name: "example_item_3".localized)
        item3.amount = 5
        item3.unit = UnitHelper.instance.BOTTLE
        item3.comment = "example_item_3_comment".localized
        item3.group = groupHelper.BEVERAGES
        
        let item4 = Item(name: "example_item_4".localized)
        item4.amount = 5
        item4.comment = "example_item_4_comment".localized
        item4.group = groupHelper.PASTA
        
        let item5 = Item(name: "example_item_5".localized)
        item5.comment = "example_item_5_comment".localized
        item5.highlighted = true
        item5.group = groupHelper.HOUSEHOLD
        
        let item6 = Item(name: "example_item_6".localized)
        item6.bought = true
        item6.comment = "example_item_6_comment".localized
        item6.group = groupHelper.OTHER
        
        let list = ShoppingList(name: "example_shopping_list_title".localized)
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
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .ByWordWrapping
        cell.nameLabel.sizeToFit()
        
        let numberOfItems = shoppingList.items.count
        var numberOfItemsText = "\(numberOfItems) "
        if (numberOfItems == 1) {
            numberOfItemsText += "list_of_shopping_lists_item".localized
        } else {
            numberOfItemsText += "list_of_shopping_lists_items".localized
        }
        
        cell.numberOfItemsLabel.text = numberOfItemsText
        
        let date = shoppingList.lastModifiedDate.relativeLocalizedRepresentation
        cell.lastModifiedLabel.text = date
               
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleGesture:")
        cell.addGestureRecognizer(longPress)
        
        cell.updateConstraints()

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
                indexPath = NSIndexPath(forRow: 0, inSection: 0)
            }
            let selectedShoppingList = shoppingLists[indexPath.row]
            shoppingListViewController.shoppingList = selectedShoppingList
            shoppingListViewController.returnToListOfShoppingListsDelegateMethod = unwindToListOfShoppingLists

        }
    }
        
    func unwindToListOfShoppingLists(sender: UIViewController) {
        if let sourceViewController = sender as? ShoppingListViewController {
            // shopping list could have new items
            if let selectedIndexPath = shoppingListsTableView.indexPathForSelectedRow {
                shoppingLists[selectedIndexPath.row] = sourceViewController.shoppingList
                self.shoppingLists.sortInPlace(sortByDate)
                if let visibleRows = shoppingListsTableView.indexPathsForVisibleRows {
                    shoppingListsTableView.reloadRowsAtIndexPaths(visibleRows, withRowAnimation: .None)
                }
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
                    let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                    shoppingLists.insert(shoppingList, atIndex: 0)
                    shoppingListsTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                    shoppingListsTableView.selectRowAtIndexPath(newIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
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

