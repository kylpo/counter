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
    var ticks: NSSet { get set }
//    var ticks: Set<TickEntityObject> { get set }

//    func addToTicks(_ value: Tick)
    func addTicksObject(_ value: TickEntity)
    func addTicks(_ values: NSSet)
}

//typealias CounterEntityObject = CounterEntity & NSObject

//extension Counter {

extension CounterEntity where Self: NSObject {
    
    public func ticksPublisher() -> AnyPublisher<NSSet, Never> {
        return self.publisher(for: \.ticks)/*.print()*//*.map({$0 as? TickEntity})*/.eraseToAnyPublisher()
//        return self.publisher(for: \.ticks)
    }
//
//    public func colorPublisher() -> Publishers.Map<NSObject.KeyValueObservingPublisher<Self, String>, TallyColor?> {
//        return self.publisher(for: \.color).map({ TallyColor(rawValue: $0) })
//    }
//
    
    public var namePublisher: AnyPublisher<Optional<String>, Never> {
        self.publisher(for: \.name).print()/*.replaceNil(with: "")*/.eraseToAnyPublisher()
    }
}


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
class CounterEntityMock: NSObject, CounterEntity {
    var hasAddedTicks: Bool = false
    
    var id: UUID? = UUID()
    
    @objc dynamic var name: String? = nil
    @objc dynamic var color: String? = nil
    @objc dynamic var ticks: NSSet = NSSet()
    
    func addTicksObject(_ value: TickEntity) {
        hasAddedTicks = true
    }
    
    func addTicks(_ values: NSSet) {
        hasAddedTicks = true
    }
}
#endif
