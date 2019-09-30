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
    let onUpdate: () -> Void

    fileprivate var counter: CounterModel
    private var cancellable: AnyCancellable?

    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()

    private(set) var name: String
    var value: Int
        {
        get {
            counter.value
        }
        set {
            self.objectWillChange.send()
            counter.value = newValue
        }
    }
    // todo color
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.counter = counter
        self.onUpdate = onUpdate
        
        self.name = counter.name
        
        cancellable = counter.objectWillChange.sink(receiveValue: {
            self.objectWillChange.send()
        })
    }
    
    
    func incrementAction() {
        value += 1
        onUpdate()
    }

//    func deleteAction() {
//        
//    }
}

// Presentational View
private struct CounterDetailView: View {
    @ObservedObject private var vm: CounterDetailVM
    let onUpdate: () -> Void
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
        vm = CounterDetailVM(counter: counter, onUpdate: onUpdate)
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
//            Button(action: vm.deleteAction) {
//                            Text("Delete")
//                        }
        }
    }
}

// Connected View (controller/container)
struct CounterDetailContainer: View {
    let counter: CounterModel
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    func handleUpdate() {
        try! moc.save()
    }


    var body: some View {
        CounterDetailView(counter: counter, onUpdate: handleUpdate)
    }
}

typealias CounterDetail = CounterDetailContainer

struct CountersDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountersScene()
    }
}
