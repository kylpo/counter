//
//  TestCounterEntity.swift
//  counterTests
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import XCTest
import CoreData
import Combine
@testable import counter

final class TestCounterEntity: CoreDataTestCase {
    var counter: Counter!
    var cancellables: [AnyCancellable] = []

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
        
        let ticks = try! XCTUnwrap(counter.ticks)
        XCTAssertEqual(ticks.count, 0)
        
        XCTAssertNotNil(counter.value)
        XCTAssertEqual(counter.value, 0)
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
    
    func test_it_can_add_ticks() {
        let tick = Tick(context: container.viewContext)
        
        let ticksBefore = try! XCTUnwrap(counter.ticks).count
        
        counter.addToTicks(tick)
        
        let ticksAfter = try! XCTUnwrap(counter.ticks).count
        XCTAssertNotEqual(ticksBefore, ticksAfter)
    }
    
    // BELOW ERRORS: Does Core Data not actually objectWillChange.send() ?
//    func test_value_change_notifies_subscribers() {
//        // given
//        var receivedUpdate = false
//
//        counter.objectWillChange.sink(receiveValue: {
//            receivedUpdate = true
//        }).store(in: &cancellables)
//
//        // when
//        counter.value = 10
//
//        // then
//        XCTAssertTrue(receivedUpdate)
//    }
}
