//
//  NSDateFormatterExtension.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 07.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

extension NSDate {
    
    var relativeLocalizedRepresentation : String {
        get {
            let dateFormatter = NSDateFormatter()
            let now = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let todayAtMidnight = calendar.startOfDayForDate(now)
            
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.doesRelativeDateFormatting = true
            let date = dateFormatter.stringFromDate(self)
            
            return date
        }
    }
}