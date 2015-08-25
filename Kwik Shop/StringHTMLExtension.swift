//
//  StringHTMLExtension.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

extension String {
    var htmlParagraph: String {
        return "<p>\(self)</p>\n"
    }
    
    var htmlH1: String {
        return "<h1>\(self)</h1>\n"
    }
    
    var htmlH2: String {
        return "<h2>\(self)</h2>\n"
    }
    
    var htmlH3: String {
        return "<h3>\(self)</h3>\n"
    }
    
    func htmlLinkWithDescription(description: String) -> String {
        return "<a href=\"\(self)\">\(description)</a>"
    }
}