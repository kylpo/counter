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
//public protocol CounterEntity where Self: NSObject {

//@objc
public protocol CounterEntity {
//    associatedtype Value

    var name: String? { get set }
    var color: String? { get set }
    var value: Int32 { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
    
//    func publisher(for: KeyPath<Self, Value>)
}

//typealias ObservableCounterEntity = CounterEntity & ObservableObject

//extension NSManagedObject : ObservableObject {
//
//    /// A publisher that emits before the object has changed.
//    public var objectWillChange: ObservableObjectPublisher { get }
//
//    /// The type of publisher that emits before the object has changed.
//    public typealias ObjectWillChangePublisher = ObservableObjectPublisher
//}

//extension CounterEntity where Self: NSObject {
//    public func valuePublisher() -> NSObject.KeyValueObservingPublisher<Self, Int32> {
//        return self.publisher(for: \.value)
//    }
//}
//
//extension CounterEntity where Self: NSManagedObject {
//    public func valuePublisher() -> NSObject.KeyValueObservingPublisher<Self, Int32> {
//        return self.publisher(for: \.value)
//    }
//}

/// **Implementation** (of protocol)
extension Counter: CounterEntity {
    // auto-generated from xcdatamodeld:
    
    // @NSManaged public var color: String?
    // @NSManaged public var name: String?
    // @NSManaged public var value: Int32
}

/// **Mock** implementation
#if DEBUG
class CounterEntityMock: CounterEntity, ObservableObject {
//    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()

    @Published var name: String? = nil
    @Published var color: String? = nil
    @Published var value: Int32 = 0
//    var value: Int32 = 0 {
//        willSet {
//            self.objectWillChange.send()
//        }
//    }
}
#endif
