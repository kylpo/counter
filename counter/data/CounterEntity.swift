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
@objc
public protocol CounterEntity {
    var id: UUID? { get set }
    var name: String? { get set }
    var color: String? { get set }
    var ticks: NSSet? { get set }
//    var ticks: Set<TickEntityObject> { get set }

//    func addToTicks(_ value: Tick)
    func addTicksObject(_ value: TickEntity)
    func addTicks(_ values: NSSet)
}

extension CounterEntity where Self: NSObject {
    public var ticksPublisher: AnyPublisher<Optional<NSSet>, Never> {
        return self.publisher(for: \.ticks)/*.print()*//*.map({$0 as? TickEntity})*/.eraseToAnyPublisher()
    }

    public var colorPublisher: AnyPublisher<Optional<String>, Never> {
        return self.publisher(for: \.color).eraseToAnyPublisher()
    }

    public var namePublisher: AnyPublisher<Optional<String>, Never> {
        self.publisher(for: \.name).print()/*.replaceNil(with: "")*/.eraseToAnyPublisher()
    }
}

/// **Implementation** (of protocol)
@objc(Counter)
public class Counter: NSManagedObject, CounterEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }
    
    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var ticks: NSSet?
    
    @objc(addTicksObject:)
    @NSManaged public func addTicksObject(_ value: TickEntity)

    @objc(removeTicksObject:)
    @NSManaged public func removeTicksObject(_ value: TickEntity)

    @objc(addTicks:)
    @NSManaged public func addTicks(_ values: NSSet)

    @objc(removeTicks:)
    @NSManaged public func removeTicks(_ values: NSSet)
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.id = UUID()
    }
}

/// **Mock** implementation
#if DEBUG
class CounterEntityMock: NSObject, CounterEntity {
    var hasAddedTicks: Bool = false
    
    var id: UUID? = UUID()
    @objc dynamic var name: String? = nil
    @objc dynamic var color: String? = nil
    @objc dynamic var ticks: NSSet? = nil
    
    func addTicksObject(_ value: TickEntity) {
        hasAddedTicks = true
    }
    
    func addTicks(_ values: NSSet) {
        hasAddedTicks = true
    }
}
#endif
