//
//  UIColorExtention.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 03.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init? (resourceName resName : String) {
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Colors", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        } else {
            self.init()
            return nil
        }
        let red : CGFloat
        let green : CGFloat
        let blue : CGFloat
        if let dict = myDict, rgb = dict[resName] as? [Int] {
            red = CGFloat(rgb[0])/255
            green = CGFloat(rgb[1])/255
            blue = CGFloat(rgb[2])/255
        } else {
            self.init()
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}