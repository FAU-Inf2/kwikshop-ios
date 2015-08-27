//
//  SettingsViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var manageAutocomletionHistoryButton: UIButton!
    @IBOutlet weak var manageAutocompletionBrandHistoryButton: UIButton!
    
    private var languageStrings : [String]!
    private let languageAbbreviations = ["en", "de", "pt"]
    private var selectedLanguageIndex : Int!
    private let languageIndexKey = "languageIndex"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "navigation_bar_settings".localized
        self.languageStrings = ["settings_english".localized, "settings_german".localized, "settings_portuguese".localized]
        languageLabel.text = "settings_language".localized
        manageAutocomletionHistoryButton.setTitle("settings_manage_autocompletion_history".localized, forState: UIControlState.Normal)
        manageAutocompletionBrandHistoryButton.setTitle("settings_manage_autocompletion_brand_history".localized, forState: UIControlState.Normal)
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        let languageAbbreviation : String
        if let storedLanguageAbbreviation = NSUserDefaults.standardUserDefaults().stringArrayForKey("AppleLanguages")?[0] as? String {
            if let index = find(languageAbbreviations, storedLanguageAbbreviation) {
                languageAbbreviation = storedLanguageAbbreviation
                selectedLanguageIndex = index
            } else {
                // found language is not supported
                languageAbbreviation = getPreferredLanguageOrEnglish()
                selectedLanguageIndex = 0
                NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
            }
        } else {
            // no language stored before
            languageAbbreviation = getPreferredLanguageOrEnglish()
            selectedLanguageIndex = 0
            NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
        }
        
        languagePicker.selectRow(selectedLanguageIndex, inComponent: 0, animated: false)
    
    }

    private func getPreferredLanguageOrEnglish() -> String {
        if let systemLanguage = NSLocale.preferredLanguages()[0] as? String {
            if contains(self.languageAbbreviations, systemLanguage) {
                return systemLanguage
            }
        }
        return "en"
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
        if let destinationController = segue.destinationViewController as? ManageAutoCompletionHistoryViewController {
            if sender === manageAutocomletionHistoryButton {
                destinationController.manageItemNameCompletion = true
            } else if sender === manageAutocompletionBrandHistoryButton {
                destinationController.manageItemNameCompletion = false
            }
        }
    }


    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {
        // this method is called, if a user selects "delete all" in the manage autocompletion history screen
        let autoCompletionHelper = AutoCompletionHelper.instance
        
        if let sourceViewController = sender.sourceViewController as? ManageAutoCompletionHistoryViewController {
            if sourceViewController.manageItemNameCompletion! {
                autoCompletionHelper.deleteAllAutoCompletionData()
            } else {
                autoCompletionHelper.deleteAllAutoCompletionBrandData()
            }
        }
        
        
    }
    
    // MARK: UIPickerview Data Source and Delegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
