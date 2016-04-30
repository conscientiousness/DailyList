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
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSizeMake(0.0, 2.0)
                self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor =  nil
            }
        }
    }
}
