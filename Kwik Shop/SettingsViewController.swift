//
//  SettingsViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var settingsTableView : UITableView!
    
    private let LANGUAGE_SELECTION_ENABLED = false
    private var LANGUAGE_SECTION : Int {
        return LANGUAGE_SELECTION_ENABLED ? 0 : -1
    }
    private var AUTOCOMPLETION_SECTION : Int {
        return LANGUAGE_SELECTION_ENABLED ? 1 : 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        self.title = "navigation_bar_settings".localized
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = settingsTableView.indexPathForSelectedRow {
            settingsTableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        if LANGUAGE_SELECTION_ENABLED {
            settingsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: LANGUAGE_SECTION)], withRowAnimation: .None)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return LANGUAGE_SELECTION_ENABLED ? 2 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == LANGUAGE_SECTION {
            return 1
        }
        if section == AUTOCOMPLETION_SECTION {
            return 2
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier : String
        let row = indexPath.row
        let section = indexPath.section
        
        if section == LANGUAGE_SECTION {
            identifier = "languageSettingsCell"
        } else /*if section == AUTOCOMPLETION_SECTION*/ {
            if row == 0 {
                identifier = "autocompletionSettingsCell"
            } else /*if row == 1*/ {
                identifier = "brandAutocompletionSettingsCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) 
        
        cell.textLabel?.numberOfLines = 2
        
        if section == LANGUAGE_SECTION {
            cell.textLabel?.text = "settings_language".localized
            cell.detailTextLabel?.text = LanguageHelper.instance.selectedLanguage
        } else {
            if row == 0 {
                cell.textLabel?.text = "settings_manage_autocompletion_history".localized
            } else if row == 1 {
                cell.textLabel?.text = "settings_manage_brand_autocompletion_history".localized
            }
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == LANGUAGE_SECTION {
            return "settings_language".localized
        }
        if section == AUTOCOMPLETION_SECTION {
            return "settings_autocompletion".localized
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        let selectedIndexPath = settingsTableView.indexPathForSelectedRow!
        let row = selectedIndexPath.row
        let section = selectedIndexPath.section
        
        if section == LANGUAGE_SECTION {
            
        } else if section == AUTOCOMPLETION_SECTION {
            if let destinationController = segue.destinationViewController as? ManageAutoCompletionHistoryViewController {
                if row == 0 {
                    destinationController.manageItemNameCompletion = true
                } else /*if row == 1*/ {
                    destinationController.manageItemNameCompletion = false
                }
            }

        }
    }
    
    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {
        // this method is called, if a user selects "delete all" in the manage autocompletion history screen
        let autoCompletionHelper = AutoCompletionHelper.instance
        
        //settingsTableView.deselectRowAtIndexPath(settingsTableView.indexPathForSelectedRow()!, animated: true)
        
        if let sourceViewController = sender.sourceViewController as? ManageAutoCompletionHistoryViewController {
            if sourceViewController.manageItemNameCompletion! {
                autoCompletionHelper.deleteAllAutoCompletionData()
            } else {
                autoCompletionHelper.deleteAllAutoCompletionBrandData()
            }
        }
        
        
    }
}
