//
//  Date.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/23.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import Foundation

class CurrentDate {

    var nowDate: NSDate = NSDate()
    
    static let sharedInstance = CurrentDate()
    
    func changeDay(index: Int) {
        self.nowDate = NSDate(year: nowDate.year, month: nowDate.month, day: (index + 1))
    }
    
}