//
//  Counter+CoreDataProperties.swift
//  counter
//
//  Created by Kyle Poole on 10/11/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var ticks: NSSet

}

// MARK: Generated accessors for ticks
extension Counter {

//    @objc(addTicksObject:)
//    @NSManaged public func addToTicks(_ value: Tick)
//
//    @objc(removeTicksObject:)
//    @NSManaged public func removeFromTicks(_ value: Tick)
//
//    @objc(addTicks:)
//    @NSManaged public func addToTicks(_ values: NSSet)
//
//    @objc(removeTicks:)
//    @NSManaged public func removeFromTicks(_ values: NSSet)
    @objc(addTicksObject:)
    @NSManaged public func addTicksObject(_ value: TickEntity)

    @objc(removeTicksObject:)
    @NSManaged public func removeTicksObject(_ value: TickEntity)

    @objc(addTicks:)
    @NSManaged public func addTicks(_ values: NSSet)

    @objc(removeTicks:)
    @NSManaged public func removeTicks(_ values: NSSet)
}
