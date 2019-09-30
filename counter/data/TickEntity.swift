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
//@objc
public protocol TickEntity {
    var timestamp: Date? { get set }
    var count: Int32 { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
}

/// **Implementation** (of protocol)
extension Tick: TickEntity {}

/// **Mock** implementation
#if DEBUG
class TickEntityMock: TickEntity, ObservableObject {
    @Published var timestamp: Date? = nil
    @Published var count: Int32 = 0
}
#endif
