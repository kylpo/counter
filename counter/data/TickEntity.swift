//
//  TickEntity.swift
//  counter
//
//  Created by Kyle Poole on 9/30/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import CoreData
import Combine

/// Protocol
@objc
public protocol TickEntity {
    var timestamp: Date? { get set }
    var count: Int32 { get set }
}

/// **Implementation** (of protocol)
@objc(Tick)
public class Tick: NSManagedObject, TickEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tick> {
        return NSFetchRequest<Tick>(entityName: "Tick")
    }

    @NSManaged public var count: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var counter: CounterEntity?
}

/// **Mock** implementation
#if DEBUG
class TickEntityMock: TickEntity {
    var timestamp: Date? = nil
    var count: Int32 = 0
}
#endif
