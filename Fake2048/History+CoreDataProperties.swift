//
//  History+CoreDataProperties.swift
//  Fake2048
//
//  Created by john on 16/6/3.
//  Copyright © 2016年 BOLO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension History {

    @NSManaged var id: NSNumber?
    @NSManaged var create_date: Date?
    @NSManaged var modify_date: Date?
    @NSManaged var screen_shot: Data?
    @NSManaged var tile_map: String?
    @NSManaged var dimension: NSNumber?

}
