//
//  Tick+CoreDataProperties.swift
//  counter
//
//  Created by Kyle Poole on 10/11/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//
//

import Foundation
import CoreData


extension Tick {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tick> {
        return NSFetchRequest<Tick>(entityName: "Tick")
    }

    @NSManaged public var count: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var counter: Counter?

}
