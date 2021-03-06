//
//  DateCenter.swift
//  DailyMind
//
//  Created by Jesselin on 2016/4/21.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import Foundation

struct DateCenter {
    
    static func timeWithLeadingZero(time: Int) -> String {
        return String(format: "%02d", time)
    }
    
    
    static func getCurrentDateWithCellIndex(currentCellIdx: Int) -> DateInRegion {
        
        let day = currentCellIdx + 1
        let currentDate = CurrentDate.sharedInstance.nowDate
        let newDate = DateInRegion(year: currentDate.year, month: currentDate.month, day: day)

        return newDate
    }
    
    static func getWeekDayString(shortString: Bool) -> String {
        
        
        let weekDay = CurrentDate.sharedInstance.nowDate.weekday
        var weekDayStr: (shortString: String,normalString: String)
        
        switch weekDay {
        case 2:
            weekDayStr = ("週一","星期一")
        case 3:
            weekDayStr = ("週二","星期二")
        case 4:
            weekDayStr = ("週三","星期三")
        case 5:
            weekDayStr = ("週四","星期四")
        case 6:
            weekDayStr = ("週五","星期五")
        case 7:
            weekDayStr = ("週六","星期六")
        case 1:
            weekDayStr = ("週日","星期日")
        default:
            weekDayStr = ("","")
        }
        
        if(shortString) {
            return weekDayStr.shortString
        }
        else {
            return weekDayStr.normalString
        }
    }
    
    static func getDateString(date: DateInRegion) -> (year: String, month: String, day: String) {
        return (String(date.year), String(format: "%02d", date.month), String(format: "%02d", date.day))
    }
    
}