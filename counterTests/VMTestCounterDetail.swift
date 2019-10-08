//
//  VMTestCounterDetail.swift
//  counterTests
//
//  Created by Kyle Poole on 10/7/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import XCTest
import Combine
@testable import counter

// Note: not using CoreData at all here. Using the Mock, so regular XCTestCase

final class VMTestCounterDetail: XCTestCase {
    var cancellables: [AnyCancellable] = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    private func createVM(counter: CounterModel = CounterModelMock(), manager: CounterManager = CounterManagerMock(), tickManager: TickManager = TickManagerMock(), context: Context = ContextMock(), onExit: @escaping () -> Void = {() in }) -> CounterDetailVM {
        return CounterDetailVM(counter: counter, manager: manager, tickManager: tickManager, context: context, onExit: onExit)
    }
    
    // MARK: - Properties and Wiring -

    func test_default_values() {
        // given
        let model: CounterModel = CounterModelMock()
        let vm: CounterDetailVM = createVM(counter: model)
        
        // then
        XCTAssertEqual(model.name, vm.name)
        XCTAssertEqual(model.totalCount, vm.value)
    }
        
    func test_model_property_changes_update_vm() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterDetailVM = createVM(counter: model)
        let before: String = vm.name

        // when
        model.name = "\(before) test"

        // then
        let after: String = vm.name
        XCTAssertNotEqual(before, after)
        XCTAssertEqual(after, model.name)
    }
    
    // Future: uncomment for Color
    func test_vm_change_updates_model() {
        // given
        let model: CounterModelMock = CounterModelMock()
        let vm: CounterDetailVM = createVM(counter: model)
        XCTAssertFalse(model.hasAddedTick)

        // when
        vm.value = 1

        // then
        XCTAssertTrue(model.hasAddedTick)
    }
    
    // Future: uncomment for Color
//    func test_value_change_notifies_subscribers() {
//        // given
//        let model: CounterModel = CounterModelMock()
//        let vm: CounterDetailVM = CounterDetailVM(counter: model, manager: CounterManagerMock(), tickManager: TickManagerMock(), context: ContextMock(), onExit: onExitStub)
//        var receivedUpdate = false
//
//        vm.objectWillChange.sink(receiveValue: {
//            receivedUpdate = true
//        }).store(in: &cancellables)
//
//        // when
//        vm.value = 10
//
//        // then
//        XCTAssertTrue(receivedUpdate)
//    }
    
    func test_model_change_notifies_vm_subscribers() {
        // given
        var model: CounterModel = CounterModelMock()
        let vm: CounterDetailVM = createVM(counter: model)
        var receivedUpdate = false
        
        vm.objectWillChange.sink(receiveValue: {
            receivedUpdate = true
        }).store(in: &cancellables)
        
        // when
        model.name = "ping"
        
        // then
        XCTAssertTrue(receivedUpdate)
    }
    
    // MARK: - Actions -

    func test_increment_action_adds_tick() {
        // given
        let model: CounterModelMock = CounterModelMock()
        let vm: CounterDetailVM = createVM(counter: model)
        XCTAssertFalse(model.hasAddedTick)

        // when
        vm.incrementAction()

        // then
        XCTAssertTrue(model.hasAddedTick)
    }
    
    func test_increment_action_saves_context() {
        // given
        let context = ContextMock()
        let vm: CounterDetailVM = createVM(context: context)
        
        XCTAssertFalse(context.hasSaved)

        // when
        vm.incrementAction()
        
        // then
        XCTAssertTrue(context.hasSaved)
    }
    
    func test_delete_action_deletes_from_manager() {
        // given
        let manager: CounterManagerMock = CounterManagerMock()
        let vm: CounterDetailVM = createVM(manager: manager)
        XCTAssertFalse(manager.hasDeleted)

        // when
        vm.deleteAction()
        
        // then
        XCTAssertTrue(manager.hasDeleted)
    }
    
    func test_delete_action_saves_context() {
        // given
        let context: ContextMock = ContextMock()
        let vm: CounterDetailVM = createVM(context: context)
        XCTAssertFalse(context.hasSaved)

        // when
        vm.deleteAction()
        
        // then
        XCTAssertTrue(context.hasSaved)
    }
    
    func test_delete_action_exits_scene() {
        // given
        var didExit: Bool = false
        let vm: CounterDetailVM = createVM(onExit: {() in didExit = true})
        
        // when
        vm.deleteAction()
        
        // then
        XCTAssertTrue(didExit)
    }
    
    // Keeping commented below to show the alt version which tests multiple effects of single action
    
    //    func test_delete_action() {
    //        // given
    //        let model: CounterModelMock = CounterModelMock()
    //        let manager: CounterManagerMock = CounterManagerMock()
    //        let context: ContextMock = ContextMock()
    //        var didCallOnChange: Bool = false
    //        func onExitSpy() {
    //            didCallOnChange = true
    //        }
    //
    //        let vm: CounterDetailVM = createVM(counter: model, manager: manager, context: context, onExit: onExitSpy)
    //
    //        XCTAssertFalse(manager.hasDeleted)
    //        XCTAssertFalse(context.hasSaved)
    //
    //        // when
    //        vm.deleteAction()
    //
    //        // then
    //        XCTAssertTrue(manager.hasDeleted)
    //        XCTAssertTrue(context.hasSaved)
    //        XCTAssertTrue(didCallOnChange)
    //    }
}
