//
//  CounterCell.swift
//  counter
//
//  Created by Kyle Poole on 9/27/19.
//  Copyright © 2019 Kyle Poole. All rights reserved.
//

import SwiftUI
import CoreData
import Combine


// View Machine
final class CounterCellVM: ObservableObject {
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
}

// Presentational View
private struct CounterCellView: View {
    @ObservedObject private var vm: CounterCellVM
    let onUpdate: () -> Void
    
    init(counter: CounterModel, onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
        vm = CounterCellVM(counter: counter, onUpdate: onUpdate)
    }
    
    var body: some View {
        NavigationLink(destination: CounterDetail(counter: vm.counter)) {
//        Button(action: vm.incrementAction) {
            HStack {
                Text(vm.name)
                Spacer()
                Text("\(vm.value)")
            }
        }
    }
}

// Connected View (controller/container)
struct CounterCellContainer: View {
    let counter: CounterModel
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    
    func handleUpdate() {
        try! moc.save()
    }

    var body: some View {
        CounterCellView(counter: counter, onUpdate: handleUpdate)
    }
}

typealias CounterCell = CounterCellContainer

//struct CounterCell_Previews: PreviewProvider {
//    let counter = Counter()
//
//    static var previews: some View {
//        CounterCell()
//    }
//}
