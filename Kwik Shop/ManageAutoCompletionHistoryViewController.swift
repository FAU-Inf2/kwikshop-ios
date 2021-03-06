//
//  ManageAutoCompletionHistoryTableViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 26.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ManageAutoCompletionHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var autoCompletionTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var manageItemNameCompletion : Bool!
    
    override var hidesBottomBarWhenPushed : Bool {
        get {
            return true
        }
        set {
            
        }
    }

    private let autoCompletionHelper = AutoCompletionHelper.instance
    private var sortedData : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autoCompletionHelper = AutoCompletionHelper.instance
        autoCompletionTableView.dataSource = self
        autoCompletionTableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        if manageItemNameCompletion! {
            sortedData = autoCompletionHelper.allAutoCompletionItemNames.sort(isOrderedBefore)
        } else {
            sortedData = autoCompletionHelper.allAutoCompletionBrandNames.sort(isOrderedBefore)
        }
    }
    
    private func isOrderedBefore(first: String, second: String) -> Bool {
        return first.caseInsensitiveCompare(second) == .OrderedAscending
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sortedData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("autoCompletionDataCell", forIndexPath: indexPath) 
        
        // Configure the cell...
        cell.textLabel?.text = sortedData[indexPath.row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let nameToDelete = sortedData.removeAtIndex(indexPath.row)
            if manageItemNameCompletion! {
                autoCompletionHelper.deleteAutocompletionDataWithItemName(nameToDelete)
            } else {
                autoCompletionHelper.deleteAutocompletionBrandDataWithName(nameToDelete)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // if a confirmation dialoge should be displayed before the item is deleted: here is the place to do so
        if sender === deleteButton {
            let alert = DeleteConfirmationAlertHelper.getDeleteConfirmationAlertWithDeleteHandler(
                { [unowned self] (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("unwindToSettings", sender: self)
                },
                forASingularValue: false)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
