//
//  Date.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/23.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import Foundation

class CurrentDate {

    static let sharedInstance = CurrentDate()
    private var _nowDate = DateInRegion(year: NSDate().year, month: NSDate().month, day: NSDate().day)
    
    var nowDate: DateInRegion {
        set {
            _nowDate = nowDate
        }
        get {
            return _nowDate
        }
    }
    
    func changeDayWithIndex(index: Int) {
        self.nowDate = DateInRegion(year: nowDate.year, month: nowDate.month, day: (index + 1))
    }
    
}