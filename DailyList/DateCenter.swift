//
//  DateCenter.swift
//  DailyMind
//
//  Created by Jesselin on 2016/4/21.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import Foundation

struct DateCenter {
    
    static func getCurrentDate(date: NSDate, currentCellIdx: Int) -> NSDate {
        
        let day = currentCellIdx + 1
        let newDate = NSDate(year: date.year, month: date.month, day: day)
        return newDate
    }
    
}