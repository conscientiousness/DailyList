//
//  DateCenter.swift
//  DailyMind
//
//  Created by Jesselin on 2016/4/21.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import Foundation

struct DateCenter {
    
    static func currentDate(date: NSDate, calDayNumber: Int) -> NSDate {
        return calDayNumber.days.fromDate(date)
    }
    
}