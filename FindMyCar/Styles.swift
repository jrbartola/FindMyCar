//
//  Styles.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/26/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

enum Styles: String {
    case darkBrown = "522B29"
    case lightGreen = "37FF8B"
    case lightBlue = "51D6FF"
    case lightGrey = "8D9EC6"
    case purple = "A06B9A"
    
    static func color(style: Styles) -> UIColor {
        return UIColor(hex: style.rawValue)
    }
}


/* Convienence extension for UIColor so we can construct them from hex values */

extension UIColor {
    convenience init(hex: String, alpha: Float = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1.0)
    }
}
