//
//  TestCounterModel.swift
//  counterTests
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import XCTest
@testable import counter

// Note: not using CoreData at all here. Using the Mock, so regular XCTestCase

final class TestCounterModel: XCTestCase {
    func test_default_values() {
        let counter: CounterModel = CounterModelImpl(CounterEntityMock())

        XCTAssertNotNil(counter.name)
        XCTAssertEqual(counter.name, "")

        XCTAssertNotNil(counter.color)
        XCTAssertEqual(counter.color, .none)

        XCTAssertNotNil(counter.value)
        XCTAssertEqual(counter.value, 0)
    }
    
    func test_mutable_values() {
        // given
        var counter: CounterModel = CounterModelImpl(CounterEntityMock())
        let name: String = "name"
        let color: TallyColor = .red
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
        var counter: CounterModel = CounterModelImpl(entity)

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
        let counter: CounterModel = CounterModelImpl(entity)

        // when
        entity.name = "name"
        entity.color = "red"
        entity.value = 10

        // then
        XCTAssertEqual(counter.name, "name")
        XCTAssertEqual(counter.color, .red)
        XCTAssertEqual(counter.value, 10)    }
}
