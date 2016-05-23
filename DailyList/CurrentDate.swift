//
//  Date.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/23.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import Foundation

class CurrentDate {

    var nowDate = DateInRegion(year: NSDate().year, month: NSDate().month, day: NSDate().day)
    
    static let sharedInstance = CurrentDate()
    
    func changeDayWithIndex(index: Int) {
        self.nowDate = DateInRegion(year: nowDate.year, month: nowDate.month, day: (index + 1))
    }
    
}