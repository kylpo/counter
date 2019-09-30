//
//  Context.swift
//  counter
//
//  Created by Kyle Poole on 9/30/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import Foundation
import CoreData

protocol Context {

    func saveChanges()
    
    func saveChangesAndWait()
    
//    func createChild() -> Self
}

extension Context where Self: NSManagedObjectContext {
    func createChild() -> NSManagedObjectContext {
        let it = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        it.parent = self
        return it
    }
}

extension NSManagedObjectContext : Context {
    func saveChanges() {
        if hasChanges {
            perform {
                do {
                    try self.save()
                    
                    if let parentContext = self.parent {
                        parentContext.perform {
                            do {
                                try parentContext.save()
                            } catch let error as NSError {
                                print("Could not save parentContext. \(error), \(error.userInfo)")
                            }
                        }
                    }
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func saveChangesAndWait() {
        if hasChanges {
            performAndWait {
                do {
                    try self.save()
                    
                    if let parentContext = self.parent {
                        parentContext.performAndWait {
                            do {
                                try parentContext.save()
                            } catch let error as NSError {
                                print("Could not save parentContext. \(error), \(error.userInfo)")
                            }
                        }
                    }
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
//    func createChild() -> Context {
//        let it = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        it.parent = self
//        return it
//    }
    
}
