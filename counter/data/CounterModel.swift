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
    var objectWillChange: ObservableObjectPublisher { get }
    var name: String { get set }
    var color: CounterColor { get set }
    var entity: CounterEntity { get }
    var ticks: [TickEntity] { get }
    func addToTicks(_ value: TickEntity)

}

/// Protocol computed properties
extension CounterModel {
    var totalCount: Int {
        ticks.count
    }
    
    var todayCount: Int {
        let calendar = Calendar.current
        return ticks.filter({
            guard let timestamp = $0.timestamp else { return false }
            return calendar.isDateInToday(timestamp)
        }).count
    }
}

/// **Implementation** (of protocol)
final class CounterModelImpl: CounterModel, ObservableObject {
//    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    private var cancellable: AnyCancellable?
    private var cancellables: [AnyCancellable] = []

    private(set) var entity: CounterEntity
    @Published private var entityName: String?
    
    var name: String {
        get {
            entityName ?? ""
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
    
//    @objc dynamic var ticks: [TickEntity]
    
    var ticks: [TickEntity] = [] //{
//        get {
//            entity.ticks?.allObjects as? [TickEntity] ?? []
////            entity.ticks?.allObjects.map { $0 as! TickEntity } ?? []
//        }
//    }
//
//    var ticksPublisher: CurrentValueSubject<TickEntity, Never>
    
    func addToTicks(_ value: TickEntity) {
        self.objectWillChange.send() // ?: Needed?
        entity.addTicksObject(value)
//        entity.addTicks(NSSet(object: value))
    }
    
    init(_ entity: CounterEntity & NSObject) {
        self.entity = entity
//        self.entityName = entity.name
        
        entity.namePublisher.sink(receiveValue: {
            self.entityName = $0
//            self.objectWillChange.send()
        }).store(in: &cancellables)
        
        
        // Below completes, so not usable for this.
//        entity.ticks.publisher.sink(receiveCompletion: {
//            print ($0)
//
//        },
//                            receiveValue: {
//            print($0)
//        }).store(in: &cancellables)
        
        entity.ticksPublisher().sink(
            receiveCompletion: {
                print ($0)
        },
            receiveValue: {
                self.ticks = $0.allObjects as? [TickEntity] ?? []
        }).store(in: &cancellables)
        
//        Use publisher to stream values instead of recalculating + recreating ticks array?
//        entity.namePublisher().sink(receiveCompletion: { print ($0) },
//                    receiveValue: { print ($0) })
//        //            .sink {
//        //            /*[ticks] in*/ print($0)
//        //        }
////        entity.ticks?.publisher.map({$0 as? TickEntity})
////            .sink(receiveCompletion: { print ($0) },
////            receiveValue: { print ($0) })
//////            .sink {
//////            /*[ticks] in*/ print($0)
//////        }
//        .store(in: &cancellables)
//        entity.ticks?.publisher.map({$0 as? TickEntity}).assign(to: \.ticks, on: self).store(in: &cancellables)
        
//        cancellable = entity.objectWillChange.sink(receiveValue: {
//            self.objectWillChange.send()
//        })
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterModelMock: CounterModel, ObservableObject {
    var entity: CounterEntity = CounterEntityMock()
    
    @Published var name: String = "Mock name"
    @Published var color: CounterColor = .none
    @Published var ticks: [TickEntity] = []
    
    var hasAddedTick = false
    
    func addToTicks(_ value: TickEntity) {
        hasAddedTick = true
    }
}
#endif
