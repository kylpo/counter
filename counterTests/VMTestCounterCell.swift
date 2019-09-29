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
    
    private func onChangeStub() {}
    
    func test_default_values() {
        // given
        let model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeStub)
        
        // then
        XCTAssertEqual(model.name, vm.name)
        XCTAssertEqual(model.value, vm.value)
    }
        
    func test_model_change_updates_vm() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeStub)
        let before: Int = vm.value
        
        // when
        model.value = 10
        
        // then
        let after: Int = vm.value
        XCTAssertNotEqual(before, after)
        XCTAssertEqual(after, 10)
    }
    
    func test_vm_change_updates_model() {
        // given
        let model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeStub)
        let before: Int = model.value
        
        // when
        vm.value = 10
        
        // then
        let after: Int = model.value
        XCTAssertNotEqual(before, after)
        XCTAssertEqual(after, 10)
    }
    
    func test_increment_action_mutates_value() {
        // given
        let model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeStub)
        let before: Int = vm.value
        
        // when
        vm.incrementAction()
        
        // then
        let after: Int = vm.value
        XCTAssertEqual(after, before + 1)
        XCTAssertEqual(after, model.value)
    }
    
    func test_increment_action_triggers_side_effect() {
        // given
        let model: CounterModel = CounterModelMock()
        var didCallOnChange: Bool = false
        
        func onChangeSpy() {
            didCallOnChange = true
        }
        
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeSpy)

        // when
        vm.incrementAction()
        
        // then
        XCTAssertTrue(didCallOnChange)
    }
    
    func test_value_change_notifies_subscribers() {
        // given
        let vm: CounterCellVM = CounterCellVM(counter: CounterModelMock(), onUpdate: onChangeStub)
        var receivedUpdate = false
        
        vm.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        vm.value = 10
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
    
    // ERRORS!!!
    // TODO: fix in next commit
    func test_model_change_notifies_subscribers() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterCellVM = CounterCellVM(counter: model, onUpdate: onChangeStub)
        var receivedUpdate = false
        
        vm.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        model.value = 10
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
}
