//
//  CounterModel.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import Combine
import CoreData

public enum CounterColor: String, CaseIterable {
    case none, red
}

/// Protocol
public protocol CounterModel {
    var name: String { get set }
    var color: CounterColor { get set }
    var value: Int { get set }
//    var ticks: Set<Tick> { get }
    var ticks: NSSet { get }
    
    var totalCount: Int { get }
    var entity: CounterEntity { get }

//    var ticks: Set<T where T:Tick> { get }
    
    func addToTicks(_ value: TickEntity)

    var objectWillChange: ObservableObjectPublisher { get }
}

/// **Implementation** (of protocol)
final class CounterModelImpl: CounterModel, ObservableObject {
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    private var cancellable: AnyCancellable?
    private(set) var entity: CounterEntity
    
    var name: String {
        get {
            entity.name ?? ""
        }
        set {
            entity.name = newValue
        }
    }
    
    var color: CounterColor {
        get {
            CounterColor(rawValue: entity.color ?? "none") ?? .none
        }
        set {
            entity.color = newValue.rawValue
        }
    }
    
    var value: Int {
        get {
            Int(entity.value)
        }
        set {
            self.objectWillChange.send()
            entity.value = Int32(newValue)
        }
    }
    
//    var ticks: Set<Tick> {
//        get {
//            if let ticks = entity.ticks {
//                return ticks as! Set<Tick>
//            }
//            else {
//                return Set<Tick>()
//            }
////            entity.ticks as Set<Tick> ?? Set<Tick>()
//        }
////        set {
////            entity.addToTicks(NSSet(object: newValue))
////        }
//    }
    var ticks: NSSet {
        get {
            entity.ticks ?? NSSet()
            //            entity.ticks as Set<Tick> ?? Set<Tick>()
        }
        //        set {
        //            entity.addToTicks(NSSet(object: newValue))
        //        }
    }
    
    var totalCount: Int {
        get {
            entity.ticks?.count ?? 0
        }
    }
    
    func addToTicks(_ value: TickEntity) {
        self.objectWillChange.send() // ?: Needed?
        entity.addToTicks(NSSet(object: value))
    }
    
    init(_ entity: CounterEntity) {
        self.entity = entity
        
        cancellable = entity.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterModelMock: CounterModel, ObservableObject {
    var entity: CounterEntity = CounterEntityMock()
    
    func addToTicks(_ value: TickEntity) {}
    
    @Published var name: String = "Mock name"
    @Published var color: CounterColor = .none
    @Published var value: Int = 0
    @Published var ticks: NSSet = NSSet()
    var totalCount: Int = 0
}
#endif
