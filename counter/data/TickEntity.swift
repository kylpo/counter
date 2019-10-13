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
public protocol TickEntity: AnyObject {
    var timestamp: Date? { get set }
    var count: Int32 { get set }
    
//    var objectWillChange: ObservableObjectPublisher { get }
}

//typealias TickEntityObject = TickEntity where Self: NSObject, Self: Hashable
typealias TickEntityObject = TickEntity & Hashable

/// **Implementation** (of protocol)
extension Tick: TickEntity {}

/// **Mock** implementation
#if DEBUG
class TickEntityMock: TickEntity, ObservableObject {
//    static func == (lhs: TickEntityMock, rhs: TickEntityMock) -> Bool {
//        return lhs.timestamp == rhs.timestamp
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(timestamp)
//    }
    
    @Published var timestamp: Date? = nil
    @Published var count: Int32 = 0
}
#endif
