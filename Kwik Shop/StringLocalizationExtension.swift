//
//  StringLocalizationExtension.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 03.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}