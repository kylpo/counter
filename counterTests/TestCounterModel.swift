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
    var counter: CounterModelImpl!

    override func setUp() {
        super.setUp()
        counter = CounterModelImpl(CounterEntityMock())
    }

    override func tearDown() {
        counter = nil
        super.tearDown()
    }

    func test_default_values() {
        XCTAssertNotNil(counter.name)
        XCTAssertEqual(counter.name, "")

        XCTAssertNotNil(counter.color)
        XCTAssertEqual(counter.color, .none)

        XCTAssertNotNil(counter.value)
        XCTAssertEqual(counter.value, 0)
    }
    
    func test_mutable_values() {
        // given
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
}
