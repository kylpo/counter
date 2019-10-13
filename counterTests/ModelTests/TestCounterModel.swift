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

    // MARK: - Properties and Wiring -
    
    func test_default_values() {
        let counter: CounterModelImpl = CounterModelImpl(CounterEntityMock())

        XCTAssertNotNil(counter.name)
        XCTAssertEqual(counter.name, "")

        XCTAssertNotNil(counter.color)
        XCTAssertEqual(counter.color, .none)
        
        XCTAssertEqual(counter.totalCount, 0)
        XCTAssertEqual(counter.todayCount, 0)
    }
    
    func test_mutable_values() {
        // given
        let counter: CounterModelImpl = CounterModelImpl(CounterEntityMock())
        let name: String = "name"
        let color: CounterColor = .red

        // when
        counter.name = name
        counter.color = color

        // then
        XCTAssertEqual(counter.name, name)
        XCTAssertEqual(counter.color, color)
    }
    
    func test_it_updates_entity() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)

        // when
        counter.name = "name"
        counter.color = .red

        // then
        XCTAssertEqual(entity.name, "name")
        XCTAssertEqual(entity.color, "red")
    }
    
    func test_it_observes_entity_updates() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)

        // when
        entity.name = "name"
        entity.color = "red"

        // then
        XCTAssertEqual(counter.name, "name")
        XCTAssertEqual(counter.color, .red)
    }
    
    // Non-entity property does not currently exist
//    func test_nonEntity_backed_change_notifies_subscribers() {
//        // given
//        let entity = CounterEntityMock()
//        let counter: CounterModelImpl = CounterModelImpl(entity)
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

    func test_entity_change_notifies_model_subscribers() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        var receivedUpdate = false

        counter.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)

        // when
        entity.name = "ping"

        // then
        XCTAssertTrue(receivedUpdate)
    }
    
    // MARK: - Relations -

    func test_it_adds_ticks_to_entity() {
        // given
        let entity = CounterEntityMock()
        let counter: CounterModelImpl = CounterModelImpl(entity)
        XCTAssertFalse(entity.hasAddedTicks)
        
        // when
        counter.addToTicks(TickEntityMock())
        
        // then
        XCTAssertTrue(entity.hasAddedTicks)
    }
    
    // MARK: - Computed Properties -

    func test_it_has_total_count_of_ticks() {
        // given
        let entity: CounterEntityMock = CounterEntityMock()
        entity.ticks = NSSet(objects: TickEntityMock(), TickEntityMock())
        
        // when
        let counter: CounterModelImpl = CounterModelImpl(entity)
        
        // then
        XCTAssertEqual(2, counter.totalCount)
    }
    
    func test_it_has_today_count_of_ticks() {
        // given
        let entity: CounterEntityMock = CounterEntityMock()
        let todayTick = TickEntityMock()
        let yesterdayTick = TickEntityMock()
        let today = Date()

        todayTick.timestamp = today
        yesterdayTick.timestamp = Calendar.current.date(byAdding: .day, value: -1, to: today)
        
        entity.ticks = NSSet(objects: todayTick, yesterdayTick)
        
        // when
        let counter: CounterModelImpl = CounterModelImpl(entity)
        
        // then
        XCTAssertEqual(1, counter.todayCount)
        XCTAssertEqual(2, counter.totalCount)
    }
}
