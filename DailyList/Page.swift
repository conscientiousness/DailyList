//
//  Page.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/24.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import Foundation
import CoreData


class Page: NSManagedObject {

    func addPageItems(value: PageItem?) {
        
        if let value = value {
            if let pageItems = self.pageItems {
                let items = pageItems.mutableCopy() as! NSMutableSet
                items.addObject(value)
                self.pageItems = items
            }
        }
    }
}

