//
//  PageItem+CoreDataProperties.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/3.
//  Copyright © 2016年 JesseLin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PageItem {

    @NSManaged var createDate: NSDate?
    @NSManaged var time: NSDate?
    @NSManaged var status: NSNumber?
    @NSManaged var title: String?
    @NSManaged var detail: String?
    @NSManaged var image: NSData?
    @NSManaged var page: Page?

}
