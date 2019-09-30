//
//  TestCounterModel.swift
//  counterTests
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import XCTest
import Combine
@testable import counter

// Note: not using CoreData at all here. Using the Mock, so regular XCTestCase

final class TestCounterModel: XCTestCase {
    var cancellables: [AnyCancellable] = []

    func test_default_values() {
        let counter: CounterModelImpl = CounterModelImpl(CounterEntityMock())

        XCTAssertNotNil(counter.name)
        XCTAssertEqual(counter.name, "")

        XCTAssertNotNil(counter.color)
        XCTAssertEqual(counter.color, .none)

        XCTAssertNotNil(counter.value)
        XCTAssertEqual(counter.value, 0)
        
        XCTAssertEqual(counter.totalCount, 0)
    }
    
    func test_mutable_values() {
        // given
        let counter: CounterModelImpl = CounterModelImpl(CounterEntityMock())
        let name: String = "name"
        let color: CounterColor = .red
        let value: Int = 10

        // when
        counter.name = name
        counter.color = color
        counter.value = value

        // then
        XCTAssertEqual(counter.name, name)
        XCTAssertEqual(counter.color, color)
        XCTAssertEqual(counter.value, value)
    }
    
    func test_it_updates_entity() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)

        // when
        counter.name = "name"
        counter.color = .red
        counter.value = 10

        // then
        XCTAssertEqual(entity.name, "name")
        XCTAssertEqual(entity.color, "red")
        XCTAssertEqual(entity.value, 10)
    }
    
    func test_it_observes_entity_updates() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)

        // when
        entity.name = "name"
        entity.color = "red"
        entity.value = 10

        // then
        XCTAssertEqual(counter.name, "name")
        XCTAssertEqual(counter.color, .red)
        XCTAssertEqual(counter.value, 10)
    }
    
    func test_value_change_notifies_subscribers() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        var receivedUpdate = false
        
        counter.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        counter.value = 10
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
    
    func test_entity_change_notifies_subscribers() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        var receivedUpdate = false
        
        counter.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        entity.value = 10
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
    
    func test_it_adds_ticks() {
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        
        let before = counter.ticks.count
        
        counter.addToTicks(TickEntityMock())
        
        let after = counter.ticks.count
        XCTAssertNotEqual(before, after)
    }
    
    func test_it_has_count_of_ticks() {
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        
        let before = counter.totalCount
        
        counter.addToTicks(TickEntityMock())
        
        let after = counter.totalCount
        XCTAssertNotEqual(before, after)
    }
}
