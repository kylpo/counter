//
//  CounterManager.swift
//  counter
//
//  Created by Kyle Poole on 9/30/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import CoreData

//
// This is a ModelManager
//
// It handles CRUD-related concerns of a single protocol type:
// - create
// - fetch
// - fetchAll
// - delete
//
// Rules: no Context
//

protocol CounterManager {
    func fetch(_ model: CounterModel) -> CounterModel?
//    func fetchAll() -> [CounterModel]
    func create(name: String, color: CounterColor) -> CounterModel
    func delete(_ model: CounterModel)
}

extension NSManagedObjectContext : CounterManager {
    var counterManager: CounterManager {
        get {
            return self as CounterManager
        }
    }
//    lazy var tallyRepo = {}()
//    static var tallyRepo = self as TallyRepository
//
    func fetch(_ model: CounterModel) -> CounterModel? {
        if let entity = model.entity as? Counter {
            let entity = self.object(with: entity.objectID) as! CounterEntity & NSObject
            return CounterModelImpl(entity)
        }
        else {
            print("Unable to fetch Tally because it isn't a ManagedTally")
            return nil
        }
    }

//    func fetchAll() -> [Tally] {
//        let request: NSFetchRequest<ManagedTally> = ManagedTally.fetchRequest()
//        let results = try? self.fetch(request)
//        return results ?? [ManagedTally]()
//    }
    func create(name: String, color: CounterColor) -> CounterModel {
        let it = CounterModelImpl(Counter(context: self))
        
        it.name = name
        it.color = color
        
        return it
    }
    
    func delete(_ model: CounterModel) {
        if let entity = model.entity as? Counter {
//            let obj = self.object(entity)
            self.delete(entity)
        }
        else {
            print("Unable to delete Tally because it isn't a ManagedTally")
        }
    }
}

/// **Mock** implementation
#if DEBUG
final class CounterManagerMock: CounterManager {
    var hasFetched: Bool = false
    var hasCreated: Bool = false
    var hasDeleted: Bool = false
    
    func fetch(_ model: CounterModel) -> CounterModel? {
        hasFetched = true
        return CounterModelMock()
    }
    
    func create(name: String, color: CounterColor) -> CounterModel {
        hasCreated = true
        let it = CounterModelMock()
//        it.name = name
//        it.color = color
        return it
    }
    func delete(_ model: CounterModel) {
        hasDeleted = true
    }
}
#endif
