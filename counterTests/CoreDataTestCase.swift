//
//  CoreDataTestCase.swift
//  counterTests
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//
// From https://developer.apple.com/videos/play/wwdc2018/224/ at time 30:50

import CoreData
import XCTest

class CoreDataTestCase: XCTestCase {
    
    var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer(name: "counter", managedObjectModel: self.managedObjectModel)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (description, error) in
            XCTAssertNil(error)
        }
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    // NOTE: This will fail if your .xcdatamodeld is not a member of your Tests target!!!
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
}
