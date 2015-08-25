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
    
    private let languageStrings = ["Default", "English", "German", "Portuguese"]
    private var selectedLanguageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagePicker.delegate = self
        languagePicker.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
        let alert = UIAlertController(title: nil, message: "Would you like to change the application language to \(languageStrings[row])?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Change to \(languageStrings[row])", style: .Default, handler: { [unowned self] (action: UIAlertAction!) in
            self.selectedLanguageIndex = row
            // TODO: Change the language
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { [unowned self] (action: UIAlertAction!) in
            pickerView.selectRow(self.selectedLanguageIndex, inComponent: 0, animated: true)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
