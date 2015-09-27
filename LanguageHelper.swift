//
//  LanguageHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 02.09.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class LanguageHelper {
    
    static let instance = LanguageHelper()
    let languageStrings : [String]
    private let languageAbbreviations = ["en", "de", "pt"]
    private var selectedIndex : Int
    var selectedLanguage : String {
        get {
            return languageStrings[selectedLanguageIndex]
        }
        set {
            if let index = languageStrings.indexOf(newValue) {
                selectedLanguageIndex = index
            } else {
                selectedLanguageIndex = 0
            }
        }
    }
    var selectedLanguageIndex : Int {
        get {
            return selectedIndex
        } set {
            if newValue >= 0 && newValue < languageStrings.count {
                selectedIndex = newValue
                let languageAbbreviation = self.languageAbbreviations[selectedIndex]
                NSUserDefaults.standardUserDefaults().setObject(["\(languageAbbreviation)"], forKey: "AppleLanguages")
            }
        }
    }
    
    
    private init() {
        self.languageStrings = ["settings_english".localized, "settings_german".localized, "settings_portuguese".localized]
        
        let languageAbbreviation : String
        if let storedLanguageAbbreviation = NSUserDefaults.standardUserDefaults().stringArrayForKey("AppleLanguages")?[0] as? String {
            if let index = languageAbbreviations.indexOf(storedLanguageAbbreviation) {
                languageAbbreviation = storedLanguageAbbreviation
                selectedIndex = index
            } else {
                // found language is not supported
                selectedIndex = 0
                languageAbbreviation = getPreferredLanguageOrEnglish()
                NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
            }
        } else {
            // no language stored before
            selectedIndex = 0
            languageAbbreviation = getPreferredLanguageOrEnglish()
            NSUserDefaults.standardUserDefaults().setObject(["en"], forKey: "AppleLanguages")
        }
    }
    
    private func getPreferredLanguageOrEnglish() -> String {
        if let systemLanguage = NSLocale.preferredLanguages()[0] as? String {
            if self.languageAbbreviations.contains(systemLanguage) {
                return systemLanguage
            }
        }
        return "en"
    }
}