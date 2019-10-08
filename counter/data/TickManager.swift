//
//  TickManager.swift
//  counter
//
//  Created by Kyle Poole on 9/30/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import CoreData

//
// This is a ModelManager (well, an EntityManager for now, but that will change)
//
// It handles CRUD-related concerns of a single protocol type:
// - create
// - fetch
// - fetchAll
// - delete
//
// Rules: no Context
//

protocol TickManager {
//    func fetch(_ model: CounterModel) -> CounterModel?
//    func fetchAll() -> [CounterModel]
    func create(_ count: Int?) -> TickEntity
//    func delete(_ model: CounterModel)
}

extension NSManagedObjectContext : TickManager {
    var tickManager: TickManager {
        get {
            return self as TickManager
        }
    }
//    lazy var tallyRepo = {}()
//    static var tallyRepo = self as TallyRepository
//
//    func fetch(_ tally: Tally) -> Tally? {
//        if let managedTally = tally as? ManagedTally {
//            return self.object(with: managedTally.objectID) as! ManagedTally
//        }
//        else {
//            print("Unable to fetch Tally because it isn't a ManagedTally")
//            return nil
//        }
//    }
//
//    func fetchAll() -> [Tally] {
//        let request: NSFetchRequest<ManagedTally> = ManagedTally.fetchRequest()
//        let results = try? self.fetch(request)
//        return results ?? [ManagedTally]()
//    }
    func create(_ count: Int? = nil) -> TickEntity {
        let it = Tick(context: self)
        
        it.timestamp = Date()
        
        if let count = count {
            it.count = Int32(count)
        }
//        else {
//            it.count = 0
//        }
//        it.count = Int32(count)
        
        return it
    }
    
//    func delete(_ model: CounterModel) {
//        if let entity = model.entity as? Counter {
////            let obj = self.object(entity)
//            self.delete(entity)
//        }
//        else {
//            print("Unable to delete Tally because it isn't a ManagedTally")
//        }
//    }
}

/// **Mock** implementation
#if DEBUG
final class TickManagerMock: TickManager {
    func create(_ count: Int?) -> TickEntity {
        let it = TickEntityMock()
//        it.name = name
//        it.color = color
        return it
    }
}
#endif
