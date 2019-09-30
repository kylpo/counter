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
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(ObjectIdentifier(self))
//      }
//
//    static func == (lhs: TickEntityMock, rhs: TickEntityMock) -> Bool {
//        return lhs.timestamp.hashValue == rhs.timestamp.hashValue

//        return lhs.hashValue == rhs.hashValue
//    }
    
//    static func < (lhs: TickEntityMock, rhs: TickEntityMock) -> Bool {
//        return lhs.timestamp.hashValue >= rhs.timestamp.hashValue
//    }
    

    @Published var timestamp: Date? = nil
    @Published var count: Int32 = 0
}
//
//class TickMock: Tick {
//
////    init() {
////        super.init()
//        
////        self.timestamp = Date()
////    }
//    
////    var mockTimestamp: Date? = nil
////    override var timestamp: Date? {
////        get { mockTimestamp }
////        set {}
////    }
////    override var count: Int32 = 0
//}
#endif
