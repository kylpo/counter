//
//  CounterEntity.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import CoreData
import Combine

/// Protocol
//@objc
public protocol CounterEntity {
    var id: UUID? { get set }
    var name: String? { get set }
    var color: String? { get set }
    var value: Int32 { get set }
    var ticks: NSSet? { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
}


//// MARK: Generated accessors for ticks
//extension Counter {
//
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
//
//}


/// **Implementation** (of protocol)
extension Counter: CounterEntity {
    // auto-generated from xcdatamodeld:
    
    // @NSManaged public var color: String?
    // @NSManaged public var name: String?
    // @NSManaged public var value: Int32
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.id = UUID()
    }
}

/// **Mock** implementation
#if DEBUG
class CounterEntityMock: CounterEntity, ObservableObject {
    var id: UUID? = UUID()
    
    @Published var name: String? = nil
    @Published var color: String? = nil
    @Published var value: Int32 = 0
    @Published var ticks: NSSet? = nil
}
#endif
