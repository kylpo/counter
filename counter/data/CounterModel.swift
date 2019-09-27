//
//  CounterModel.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation

public enum TallyColor: String, CaseIterable {
    case none, red
}

/// Protocol
public protocol CounterModel {
    var name: String { get set }
    var color: TallyColor { get set }
    var value: Int { get set }
    
    init(_ entity: CounterEntity)
}

/// **Implementation** (of protocol)
final class CounterModelImpl: CounterModel {
    var name: String
    var color: TallyColor
    var value: Int
    
    init(_ entity: CounterEntity) {
        // Not as easy as commented code below. This is why a Model is necessary! Put this logic here, not in your UI code!
//        self.name = entity.name
//        self.color = entity.color
//        self.value = enetity.value
        
        self.name = entity.name ?? ""
        
        if let color = entity.color {
            self.color = TallyColor(rawValue: color) ?? .none
        }
        else {
            self.color = .none
        }
        
        self.value = Int(entity.value)
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterModelMock: CounterModel {
    var name: String = "Mock name"
    var color: TallyColor = .none
    var value: Int = 0
    
    init(_ entity: CounterEntity) {}
}
#endif
