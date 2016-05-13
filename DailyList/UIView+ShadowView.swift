//
//  ShadowView.swift
//  DailyList
//
//  Created by Jesselin on 2016/4/30.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

private var shadowKey = false
extension UIView {
    
    @IBInspectable var shadowDesign: Bool {
        get {
            return shadowKey
        }
        set {
            shadowKey = newValue
            
            if shadowKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 1.5
                self.layer.shadowOffset = CGSizeMake(1.5, 0.0)
                self.layer.shadowColor = UIColor(hex: "E3E3E3", alpha: 1).CGColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor =  nil
            }
        }
    }
}
