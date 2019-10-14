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
import SwiftUI

public enum CounterColor: String, CaseIterable {
    case none
    case red
    
    public var value: Color {
        switch self {
        case .red: return .red
        case .none: return .black
        }
    }
}

/// Protocol
public protocol CounterModel {
    var objectWillChange: ObservableObjectPublisher { get }
    var name: String { get set }
    var color: CounterColor { get set }
    var entity: CounterEntity & NSObject { get }
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
    
    private var cancellables: [AnyCancellable] = []
    private(set) var entity: NSObject & CounterEntity

    @Published private var entityName: String?
    var name: String {
        get {
            entityName ?? ""
        }
        set {
            entity.name = newValue
        }
    }
    
    @Published private var entityColor: CounterColor?
    var color: CounterColor {
        get {
            entityColor ?? .none
        }
        set {
            entity.color = newValue.rawValue
        }
    }
    
    @Published var ticks: [TickEntity] = []

    func addToTicks(_ value: TickEntity) {
        entity.addTicksObject(value)
    }
    
    init(_ entity: CounterEntity & NSObject) {
        self.entity = entity
        
        cancellables.append(contentsOf: [
            entity.namePublisher.sink { self.entityName = $0 },
            entity.colorPublisher.map({ CounterColor(rawValue: $0 ?? "none") ?? CounterColor.none }).sink { self.entityColor = $0 },
            entity.ticksPublisher.sink { self.ticks = $0?.allObjects as? [TickEntity] ?? [] },
        ])
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterModelMock: CounterModel, ObservableObject {
    var hasAddedTick = false

    var entity: NSObject & CounterEntity = CounterEntityMock()
    @Published var name: String = "Mock name"
    @Published var color: CounterColor = .none
    @Published var ticks: [TickEntity] = []
    
    func addToTicks(_ value: TickEntity) {
        hasAddedTick = true
    }
}
#endif
