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
public protocol CounterModel: AnyObject {
    var name: String { get set }
    var color: TallyColor { get set }
    var value: Int { get set }
    
    var objectWillChange: ObservableObjectPublisher { get }
//    init(_ entity: CounterEntity)
}

/// **Implementation** (of protocol)
final class CounterModelImpl: CounterModel, ObservableObject {
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
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
    
//    @Published
    private var entity: CounterEntity
    private var cancellable: AnyCancellable?
    
    
    //    private var observation: NSKeyValueObservation?
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "value" {
//            self.value = Int(entity.value)
////            print("HIIII")
//        }
////        print(keyPath)
////        if keyPath == \.entity.value {
//            // Update Time Label
////            print("HIIII")
////            timeLabel.text = configurationManager.updatedAt
////        }
//    }
    
    init(_ entity: CounterEntity) {
        self.entity = entity
        
//        super.init()
        
//        entity.publisher(for: \.value)
        
//        entity.publisher(for: <#T##KeyPath<CounterEntity, Value>#>)
        
        cancellable = entity.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
//        entity.publisher(for: \.value)
        
        
//        (entity as NSObject).publisher(for: \entity.value)
        
//        entity.publisher(for: \.value)
        
        
//        observation = observe(\.entity.value, options: [.old, .new]
//        ) { object, change in
//            print("myDate changed from: \(change.oldValue!), updated to: \(change.newValue!)")
//        }
        
//        entity.addObserver(self, forKeyPath: "value", options: [.new, .old], context: nil)
        
//        entity.publisher()
        
//        entity.valuePublisher()
//        entity.publisher(for: <#T##KeyPath<(NSObject & CounterEntity), Value>#>)
//        entity.publisher(for: \.value)
//        self.value = entity.valuePublisher()
//        entity.publisher(for: \.name)
        
//        self.value = entity.value.pub
        
        
        // Not as easy as commented code below. This is why a Model is necessary! Put this logic here, not in your UI code!
//        self.name = entity.name
//        self.color = entity.color
//        self.value = enetity.value
        
//        self.name = entity.name ?? ""
        
//        if let color = entity.color {
//            self.color = TallyColor(rawValue: color) ?? .none
//        }
//        else {
//            self.color = .none
//        }
        
//        self.value = Int(entity.value)
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterModelMock: CounterModel, ObservableObject {
//    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()

    @Published var name: String = "Mock name"
    @Published var color: TallyColor = .none
    @Published var value: Int = 0
    
//    init(_ entity: CounterEntity) {}
}
#endif
