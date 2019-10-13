//
//  VMTestCounterCell.swift
//  counterTests
//
//  Created by Kyle Poole on 9/28/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

//

import XCTest
import Combine
@testable import counter

// Note: not using CoreData at all here. Using the Mock, so regular XCTestCase

final class VMTestCounterCell: XCTestCase {
    var cancellables: [AnyCancellable] = []
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Properties and Wiring -
    
    func test_default_values() {
        // given
        let model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, showTotalCount: true)
        
        // then
        XCTAssertEqual(model.name, vm.name)
        XCTAssertEqual(model.totalCount, vm.value)
    }
        
    func test_model_property_changes_update_vm() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, showTotalCount: true)
        let before: String = vm.name
        
        // when
        model.name = "\(before) text"
        
        // then
        let after: String = vm.name
        XCTAssertNotEqual(before, after)
        XCTAssertEqual(after, "\(before) text")
    }
    
//    func test_vm_property_changes_update_model() {
//        // Does Not Apply
//    }
    
    func test_model_change_notifies_vm_subscribers() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, showTotalCount: true)
        var receivedUpdate = false
        
        vm.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        model.name = "ping"
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
}
