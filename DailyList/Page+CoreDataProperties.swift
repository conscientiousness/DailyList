//
//  Page+CoreDataProperties.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/24.
//  Copyright © 2016年 JesseLin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Page {

    @NSManaged var year: String?
    @NSManaged var month: String?
    @NSManaged var day: String?
    @NSManaged var pageItems: NSSet?

}
