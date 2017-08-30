//
//  Location+CoreDataProperties.swift
//  FindMyCar
//
//  Created by Jesse Bartola on 8/29/17.
//  Copyright © 2017 runners. All rights reserved.
//
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
