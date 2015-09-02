//
//  SettingsViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class AlternativeSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var settingsTableView : UITableView!
    
    
    
    private let LANGUAGE_SECTION = 0
    private let AUTOCOMPLETION_SECTION = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        self.title = "navigation_bar_settings".localized
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = settingsTableView.indexPathForSelectedRow() {
            settingsTableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.numberOfLines = 2
        
        if section == LANGUAGE_SECTION {
            cell.textLabel?.text = "settings_language".localized
            cell.detailTextLabel?.text = "English"
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
            return "Autocompletion"
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

        let selectedIndexPath = settingsTableView.indexPathForSelectedRow()!
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
    
    // MARK: UIPickerview Data Source and Delegate
    /*func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageStrings.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return languageStrings[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == selectedLanguageIndex {
            return
        }
        
        let message = "alert_box_change_language_confirmation_beginning".localized + languageStrings[row] + "alert_box_change_language_confirmation_end".localized + "?"
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let confirmationYesTitle = "alert_box_change_language_confirmation_yes_beginning".localized + languageStrings[row] + "alert_box_change_language_confirmation_yes_end".localized
        
        alert.addAction(UIAlertAction(title: confirmationYesTitle, style: .Default, handler: { [unowned self] (action: UIAlertAction!) in
            self.selectedLanguageIndex = row
            let languageAbbreviation = self.languageAbbreviations[row]
            NSUserDefaults.standardUserDefaults().setObject(["\(languageAbbreviation)"], forKey: "AppleLanguages")
            }))
        
        alert.addAction(UIAlertAction(title: "alert_box_cancel".localized, style: .Cancel, handler: { [unowned self] (action: UIAlertAction!) in
            pickerView.selectRow(self.selectedLanguageIndex, inComponent: 0, animated: true)
            }))
        
        alert.popoverPresentationController?.sourceRect = languagePicker.bounds
        alert.popoverPresentationController?.sourceView = languagePicker
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Left
        
        presentViewController(alert, animated: true, completion: nil)
    }*/
}
