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

public enum TallyColor: String, CaseIterable {
    case none, red
}

/// Protocol
public protocol CounterModel {
    var name: String { get set }
    var color: TallyColor { get set }
    var value: Int { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
}

/// **Implementation** (of protocol)
final class CounterModelImpl: CounterModel, ObservableObject {
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    private var entity: CounterEntity
    private var cancellable: AnyCancellable?
    
    var name: String {
        get {
            entity.name ?? ""
        }
        set {
            entity.name = newValue
        }
    }
    
    var color: TallyColor {
        get {
            TallyColor(rawValue: entity.color ?? "none") ?? .none
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
    @Published var name: String = "Mock name"
    @Published var color: TallyColor = .none
    @Published var value: Int = 0
}
#endif
