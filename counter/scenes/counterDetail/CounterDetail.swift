//
//  CounterDetail.swift
//  counter
//
//  Created by Kyle Poole on 9/30/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

//extension Counter: Identifiable {}


// View Machine
final class CounterDetailVM: ObservableObject {
//    let onUpdate: () -> Void
    let onExit: () -> Void
    let manager: CounterManager
    let tickManager: TickManager
    let context: Context

    fileprivate var counter: CounterModel
    private var cancellable: AnyCancellable?

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()

    private(set) var name: String
    var value: Int
        {
        get {
            counter.totalCount
        }
        set {
            self.objectWillChange.send()
//            counter.value = newValue
            counter.addToTicks(tickManager.create(0))
        }
    }
    // todo color
    
    init(counter: CounterModel, manager: CounterManager, tickManager: TickManager, context: Context, onExit: @escaping () -> Void) {
//    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.counter = counter
        self.manager = manager
        self.tickManager = tickManager
        self.context = context
        self.onExit = onExit
        
        self.name = counter.name
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
    
    
    func incrementAction() {
        value += 1
        context.saveChanges()
//        onUpdate()
    }

    func deleteAction() {
        manager.delete(counter)
        context.saveChangesAndWait()
        onExit()
    }
}

// Presentational View
private struct CounterDetailView: View {
    @ObservedObject private var vm: CounterDetailVM
//    let onExit: () -> Void
//    let manager: CounterManager
//    let context: Context
    
    init(counter: CounterModel, manager: CounterManager ,tickManager: TickManager, context: Context, onExit: @escaping () -> Void) {
//        self.onExit = onExit
//        self.manager = manager
//        self.context = context
        vm = CounterDetailVM(counter: counter, manager: manager, tickManager: tickManager, context: context, onExit: onExit)
    }
    
    var body: some View {
        VStack {
        Button(action: vm.incrementAction) {

            HStack {
                Text(vm.name)
                Spacer()
                Text("\(vm.value)")
            }
        }
            //            Button(action: editAction) {
            //                Text("Edit")
            //            }
            Button(action: vm.deleteAction) {
                            Text("Delete")
                        }
        }
    }
}

// Connected View (controller/container)
struct CounterDetailContainer: View {
    let counter: CounterModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext

    func handleExit() {
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        CounterDetailView(counter: counter, manager: moc.counterManager, tickManager: moc.tickManager, context: moc as Context, onExit: handleExit)
    }
}

typealias CounterDetail = CounterDetailContainer

struct CountersDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountersScene()
    }
}
