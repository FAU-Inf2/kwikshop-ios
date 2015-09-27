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
            let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 1,
                toDate: todayAtMidnight,
                options: NSCalendarOptions(rawValue: 0))
            
            if self < tomorrow! && self >= todayAtMidnight{
                //self is today
                dateFormatter.timeStyle = .ShortStyle
            } else {
                dateFormatter.dateStyle = .MediumStyle
            }
            
            dateFormatter.doesRelativeDateFormatting = true
            let date = dateFormatter.stringFromDate(self)
            
            return date
        }
    }
    
}

public func < (left: NSDate, right: NSDate) -> Bool {
    return right > left
}
    
public func > (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == NSComparisonResult.OrderedDescending
}

public func >= (left:NSDate, right: NSDate) -> Bool {
    return left == right || left > right
}

public func <= (left:NSDate, right: NSDate) -> Bool {
    return right >= left
}
