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
        cancellables.forEach({ $0.cancel() })
        super.tearDown()
    }

    func test_default_values() {
        XCTAssertNil(counter.name)
        XCTAssertNil(counter.color)
        
        let ticks = try! XCTUnwrap(counter.ticks)
        XCTAssertEqual(ticks.count, 0)
    }
    
    func test_mutable_values() {
        // given
        let name = "name"
        let color = "color"
        
        // when
        counter.name = name
        counter.color = color
        
        // then
        XCTAssertEqual(counter.name, name)
        XCTAssertEqual(counter.color, color)
    }
    
    func test_it_can_add_ticks() {
        // given
        let ticksBefore = try! XCTUnwrap(counter.ticks).count
        
        // when
        counter.addTicksObject(Tick(context: container.viewContext))
        
        // then
        let ticksAfter = try! XCTUnwrap(counter.ticks).count
        XCTAssertNotEqual(ticksBefore, ticksAfter)
    }
    
    func test_name_publisher() {
//        let myCounter = Counter(context: container.viewContext)
        var receivedValue: String?
        let expectedValue: String = "hi"
        

//        counter.publisher(for: \.name).eraseToAnyPublisher().sink(receiveCompletion: { print ($0) },
//        receiveValue: { receivedValue = $0 }).store(in: &cancellables)
        // validation
        counter.namePublisher.sink(receiveCompletion: { print ($0) },
                    receiveValue: { receivedValue = $0 }).store(in: &cancellables)

        XCTAssertNotEqual(expectedValue, receivedValue)

        counter.name = expectedValue
        XCTAssertEqual(expectedValue, receivedValue)
    }
    
    func test_ticks_publisher() {
        let tick = Tick(context: container.viewContext)
        var receivedValue: Int = 0
        
        // validation
        counter.ticksPublisher.sink(receiveCompletion: {
            print ($0)
        }, receiveValue: {
//            print($0)
            if let ticks = $0 {
                receivedValue = ticks.count
            }
        }).store(in: &cancellables)
        
        // when
        counter.addTicksObject(tick)
        
        // then
        XCTAssertEqual(1, receivedValue)
    }
    
//    func test_tick_update_publishes() {
//        let tick = Tick(context: container.viewContext)
//        var receivedValue: Bool = false
//        counter.addTicksObject(tick)
//        
//        // validation
//        counter.ticksPublisher().dropFirst().sink(receiveCompletion: {
//            print ($0)
//        }, receiveValue: {
//            print($0)
//            receivedValue = true
//        }).store(in: &cancellables)
//        
//        // when
//        tick.count = 5
//        
//        // then
//        XCTAssertTrue(receivedValue)
//    }
    
//    func test_ticks_totals() {
//        let tick1 = Tick(context: container.viewContext)
//        let tick2 = Tick(context: container.viewContext)
//
//        XCTAssertEqual(counter.ticks.count, 0)
//
//        counter.addTicksObject(tick1)
//
////        XCTAssertEqual(counter., 0)
//
//
//    }
    
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
//        counter.name = "ping"
//
//        // then
//        XCTAssertTrue(receivedUpdate)
//    }
}
