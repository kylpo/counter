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

// View Machine
final class CounterDetailVM: ObservableObject {
    let onExit: () -> Void
    let manager: CounterManager
    let tickManager: TickManager
    let context: Context

    fileprivate var counter: CounterModel
    private var cancellable: AnyCancellable?

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    /*@Published*/ var showEditModal = false

    var name: String {
        counter.name
    }
    
    var value: Int
        {
        get {
            counter.totalCount
        }
        set {
            counter.addToTicks(tickManager.create(0))
        }
    }
    
    init(counter: CounterModel, manager: CounterManager, tickManager: TickManager, context: Context, onExit: @escaping () -> Void) {
        self.counter = counter
        self.manager = manager
        self.tickManager = tickManager
        self.context = context
        self.onExit = onExit
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
    
    
    func incrementAction() {
        value += 1
        context.saveChanges()
    }
    
    func editAction() {
        objectWillChange.send()
        showEditModal = true
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
    let onEdit: () -> Void

//    @State var showEditModal = false
    
    init(counter: CounterModel, manager: CounterManager ,tickManager: TickManager, context: Context, onExit: @escaping () -> Void, onEdit: @escaping () -> Void) {
        self.onEdit = onEdit
        vm = CounterDetailVM(counter: counter, manager: manager, tickManager: tickManager, context: context, onExit: onExit)
    }
    
//    func editAction() {
////        objectWillChange.send()
//        showEditModal = true
//    }
    
    var body: some View {
        VStack {
            Button(action: vm.incrementAction) {
                HStack {
                    Text(vm.name)
                    Spacer()
                    Text("\(vm.value)")
                }
            }
            Button(action: onEdit) {
                Text("Edit")
            }
            Button(action: vm.deleteAction) {
                Text("Delete")
            }
        }
//        .sheet(isPresented: $showEditModal, content: {
//            CounterEdit(counter: self.vm.counter)
//        })//.environment(\.managedObjectContext, self.appState.contextHolder!)
        
//        .sheet(isPresented: $showSheet, onDismiss: {
//            self.appState.editingTally = nil
//        }, content: {
//            //                ScrollView {
//            AddTallyScene(
//                tally: self.appState.editingTally!
//            ).environment(\.managedObjectContext, self.appState.contextHolder!)
//            //                }
//        })
    }
}

// Connected View (controller/container)
struct CounterDetailContainer: View {
    let counter: CounterModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    @State var showEditModal = false

    func handleExit() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func handleEdit() {
        showEditModal = true
    }

    var body: some View {
        CounterDetailView(counter: counter, manager: moc.counterManager, tickManager: moc.tickManager, context: moc as Context, onExit: handleExit, onEdit: handleEdit)
        .sheet(isPresented: $showEditModal, content: {
            CounterEdit(counter: self.counter).environment(\.managedObjectContext, self.moc.createChild())
        })
    }
}

typealias CounterDetail = CounterDetailContainer

//struct CountersDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        CountersScene()
//    }
//}
