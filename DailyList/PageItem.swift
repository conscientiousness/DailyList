//
//  PageItem.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/3.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import Foundation
import CoreData


class PageItem: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.createDate = NSDate()
    }

}
