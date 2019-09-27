//
//  TestCounterEntity.swift
//  counterTests
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import XCTest
import CoreData
@testable import counter

final class TestCounterEntity: CoreDataTestCase {
    var counter: Counter!

    override func setUp() {
        super.setUp()
        counter = Counter(context: container.viewContext)
    }

    override func tearDown() {
        counter = nil
        super.tearDown()
    }

    func test_default_values() {
        XCTAssertNil(counter.name)
        XCTAssertNil(counter.color)
        XCTAssertEqual(0, counter.value)
    }
    
    func test_mutable_values() {
        // given
        let name = "name"
        let color = "color"
        let value = Int32(10)
        
        // when
        counter.name = name
        counter.color = color
        counter.value = value
        
        // then
        XCTAssertEqual(counter.name, name)
        XCTAssertEqual(counter.color, color)
        XCTAssertEqual(counter.value, value)
    }
    
}
