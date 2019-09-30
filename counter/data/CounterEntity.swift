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
    var name: String? { get set }
    var color: String? { get set }
    var value: Int32 { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
}

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
    @Published var name: String? = nil
    @Published var color: String? = nil
    @Published var value: Int32 = 0
}
#endif
