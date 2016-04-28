//
//  UIColor+hex.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/22.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // Usage: UIColor(hex: 0xFC0ACE, alpha: 0.25)
    convenience init(hex: String, alpha: Double) {
        
        let hexString:NSString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let hexInt = Int(color)
        let mask = 0x000000FF
        
        self.init(
            red: CGFloat((hexInt >> 16) & mask) / 255,
            green: CGFloat((hexInt >> 8) & mask) / 255,
            blue: CGFloat(hexInt & mask) / 255,
            alpha: CGFloat(alpha)
        )
    }
    
}
