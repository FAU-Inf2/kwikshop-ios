//
//  LanguageSelectionViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 02.09.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var languagesTableView: UITableView!
    
    private var selectedLanguageIndex : Int {
        get {
            return languageHelper.selectedLanguageIndex
        }
        set {
            languageHelper.selectedLanguageIndex = newValue
            languagesTableView.reloadData()
        }
    }
    
    private let languageHelper = LanguageHelper.instance
    private var languageStrings : [String] {
        return languageHelper.languageStrings
    }
    
    override var hidesBottomBarWhenPushed : Bool {
        get {
            return true
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "settings_language".localized
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        
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
        return languageStrings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("languageCell", forIndexPath: indexPath) 
        
        // Configure the cell...
        cell.textLabel?.text = languageStrings[indexPath.row]
        if indexPath.row == selectedLanguageIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        languagesTableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let row = indexPath.row
        
        if row == selectedLanguageIndex {
            return
        }
        
        let message = "alert_box_change_language_confirmation_beginning".localized + languageStrings[row] + "alert_box_change_language_confirmation_end".localized + "?"
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let confirmationYesTitle = "alert_box_change_language_confirmation_yes_beginning".localized + languageStrings[row] + "alert_box_change_language_confirmation_yes_end".localized
        
        alert.addAction(UIAlertAction(title: confirmationYesTitle, style: .Default, handler: { [unowned self] (action: UIAlertAction!) in
            self.selectedLanguageIndex = row
            self.performSegueWithIdentifier("unwindToSettings", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "alert_box_cancel".localized, style: .Cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)!.bounds
        alert.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)!
        alert.popoverPresentationController?.permittedArrowDirections = [UIPopoverArrowDirection.Down, UIPopoverArrowDirection.Up]
        
        presentViewController(alert, animated: true, completion: nil)
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
